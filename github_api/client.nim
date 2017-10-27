## This module is the backbone of the github_api wrapper.
## It provides a layer of abstraction on top of Nim's ``HttpClient``
## and allows you to persist an access token.
##
## Getting started
## ===============
##
## To get started using `github_api` you will need to get an
## instance of the ``GithubApiClient`` object. To do so,
## just call the ``newGithubApiClient`` proc.
##
## .. code-block:: nim
##   
##   import github_api
##   
##   var client = newGithubApiClient()
##
## Alternately, you can instantiate a ``GithubApiClient`` instance 
## with an access token.
##
## .. code-block:: nim
##   
##   import github_api
##
##   var client = newGithubApiClient("b24123832b745c3fe5e4e6606het7co73e31f21")

import httpclient, tables, ospaths, strutils, json, cgi

type
    GithubApiClient* = ref object
        ## The client object is responsible for connecting everything else to the GitHub API. It
        ## wraps `HttpClient` and provides a layer of abstraction on top.
        httpClient: HttpClient
        baseUrl*: string
        accessToken*: string

proc toQueryString*(json: JsonNode): string =
    ## Take a json node and turn it into a query string to be sent to GitHub
    if json == nil: return ""
    result = ""
    var
        sep = '?'
        strVal = ""
    for key, val in json:
        case val.kind
        of JString:
            strVal = val.getStr()
        of JNull: continue
        else:
            strVal = $val
        result.add(sep)
        result.add(key)
        result.add('=')
        result.add(encodeUrl(strVal))
        sep = '&'

proc newGithubApiClient*(
    accessToken: string = nil,
    userAgent = defUserAgent,
    maxRedirects = 5,
    proxy: Proxy = nil,
    timeout = -1): GithubApiClient =
    ## Create a new instance of the ``GithubApiClient`` object

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
        result.add(repo.to(T))

proc request*(client: GithubApiClient, path: string, body: string = "", query: JsonNode = nil, httpMethod: string = $HttpGet): Response =
    var url = client.baseUrl / path & toQueryString(query)
    var headers: HttpHeaders = nil
    if client.accessToken != nil:
        headers = newHttpHeaders({ "Authorization": "token " & client.accessToken })
    client.httpClient.request(url, httpMethod, body, headers)