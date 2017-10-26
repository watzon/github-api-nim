import httpclient, ospaths, json
import ./client

proc search*(
    client: GithubApiClient,
    searchType: string,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    var data = %*{
        "q": query,
        "sort": sort,
        "order": order,
        "per_page": limit,
        "page": page
    }
    var path = "/search" / searchType
    client.request(path, query = data)

proc searchRepositories*(
    client: GithubApiClient,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    search(client, "repositories", query, sort, order, limit, page)

proc searchCommits*(
    client: GithubApiClient,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    search(client, "commits", query, sort, order, limit, page)

proc searchCode*(
    client: GithubApiClient,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    search(client, "code", query, sort, order, limit, page)

proc searchIssues*(
    client: GithubApiClient,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    search(client, "issues", query, sort, order, limit, page)

proc searchUsers*(
    client: GithubApiClient,
    query: string,
    sort: string = nil,
    order: string = nil,
    limit: int = 100,
    page: int = 1): Response =

    search(client, "users", query, sort, order, limit, page)