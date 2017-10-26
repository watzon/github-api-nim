import httpclient, tables, ospaths, strutils, json, cgi

type
    GithubApiClient* = ref object
        httpClient: HttpClient
        baseUrl*: string
        accessToken*: string

proc toQueryString*(json: JsonNode): string =
    if json == nil: return ""
    var parts: seq[string] = @[]
    for key, val in json:
        if val.kind != JNull:
            if val.kind == JString:
                parts.add(key & "=" & val.getStr().encodeUrl())
            else:
                parts.add(key & "=" & $val)
    result = "?" & parts.join("&")

proc newGithubApiClient*(
    accessToken: string = nil,
    userAgent = defUserAgent,
    maxRedirects = 5,
    proxy: Proxy = nil,
    timeout = -1): GithubApiClient =

    var httpClient = newHttpClient(userAgent, maxRedirects, nil, proxy, timeout)
    httpClient.headers = newHttpHeaders({
        # "Accept": "application/vnd.github.v3+json",
        "Accept": "application/vnd.github.mercy-preview+json", # Allows use of preview APIs
        "Content-Type": "application/json"
    })

    GithubApiClient(
        httpClient: httpClient,
        baseUrl: "https://api.github.com",
        accessToken: accessToken
    )

proc seqTo[T](data: string): seq[T] =
    var json = parseJson(data)
    result = @[]
    for repo in json:
        result.add(repo.to(Repository))

proc request*(client: GithubApiClient, path: string, body: string = "", query: JsonNode = nil, httpMethod: string = $HttpGet): Response =
    var url = client.baseUrl / path & toQueryString(query)
    echo(url)
    var headers: HttpHeaders = nil
    if client.accessToken != nil:
        headers = newHttpHeaders({ "Authorization": "token " & client.accessToken })
    client.httpClient.request(url, httpMethod, body, headers)