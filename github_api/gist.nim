import httpclient, ospaths, json
import ./client

type
    GistFileArray = JsonNode

proc listGists*(
    client: GithubApiClient,
    since: string = nil,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "since": since,
        "per_page": limit,
        "page": page
    }
    var path = "/gists"
    client.request(path, query = data)

proc listUserGists*(
    client: GithubApiClient,
    username: string,
    since: string = nil,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "since": since,
        "per_page": limit,
        "page": page
    }
    var path = "/users" / username / "gists"
    client.request(path, query = data)

proc listAllGists*(
    client: GithubApiClient,
    since: string = nil,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "since": since,
        "per_page": limit,
        "page": page
    }
    var path = "/gists/public"
    client.request(path, query = data)

proc getStarredGists*(
    client: GithubApiClient,
    since: string = nil,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "since": since,
        "per_page": limit,
        "page": page
    }
    var path = "/gists/starred"
    client.request(path, query = data)

proc getGist*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id
    client.request(path)

proc getGist*(
    client: GithubApiClient,
    id: string,
    sha: string): Response =

    var path = "/gists" / id / sha
    client.request(path)

proc createGist*(
    client: GithubApiClient,
    files: GistFileArray,
    description: string = nil,
    public: bool = false): Response =

    var data = %*{
        "files": files,
        "description": description,
        "public": public
    }
    var path = "/gists"
    client.request(path, body = $data, httpMethod = $HttpPost)
    
proc editGist*(
    client: GithubApiClient,
    id: string,
    files: GistFileArray,
    description: string = nil): Response =

    var data = %*{
        "files": files,
        "description": description
    }
    var path = "/gists" / id
    client.request(path, body = $data, httpMethod = $HttpPatch)
        
proc getGistCommits*(
    client: GithubApiClient,
    id: string,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "per_page": limit,
        "page": page
    }
    var path = "/gists" / id / "commits"
    client.request(path)

proc starGist*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id / "star"
    client.request(path, httpMethod = $HttpPut)

proc unstarGist*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id / "star"
    client.request(path, httpMethod = $HttpDelete)

proc getGistStarStatus*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id / "star"
    client.request(path)

proc forkGist*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id / "forks"
    client.request(path, httpMethod = $HttpPost)

proc getGistForks*(
    client: GithubApiClient,
    id: string,
    limit: int = 0,
    page: int = 1): Response =

    var data = %*{
        "per_page": limit,
        "page": page
    }
    var path = "/gists" / id / "forks"
    client.request(path)

proc deleteGist*(
    client: GithubApiClient,
    id: string): Response =

    var path = "/gists" / id
    client.request(path, httpMethod = $HttpDelete)