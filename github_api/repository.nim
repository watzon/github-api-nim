## This module contains procs related to Repository management
## in GitHub. Information on the procs in this file can be
## found in the GitHub API documentation.
## https://developer.github.com/v3/repos/

import httpclient, ospaths, strutils, json, marshal
import ./client

type
    User* = ref object
        login*: string
        id*: int
        avatar_url*: string
        gravatar_id*: string
        url*: string
        html_url*: string
        followers_url*: string
        following_url*: string
        gists_url*: string
        starred_url*: string
        subscriptions_url*: string
        organizations_url*: string
        repos_url*: string
        events_url*: string
        received_events_url*: string
        # type*: string
        site_admin*: bool
    Repository* = ref object
        id*: int
        name*: string
        full_name*: string
        owner*: User
        private*: bool
        html_url*: string
        description*: string
        fork*: bool
        url*: string
        forks_url*: string
        keys_url*: string
        collaborators_url*: string
        teams_url*: string
        hooks_url*: string
        issue_events_url*: string
        events_url*: string
        assignees_url*: string
        branches_url*: string
        tags_url*: string
        blobs_url*: string
        git_tags_url*: string
        git_refs_url*: string
        trees_url*: string
        statuses_url*: string
        languages_url*: string
        stargazers_url*: string
        contributors_url*: string
        subscribers_url*: string
        subscription_url*: string
        commits_url*: string
        git_commits_url*: string
        comments_url*: string
        issue_comment_url*: string
        contents_url*: string
        compare_url*: string
        merges_url*: string
        archive_url*: string
        downloads_url*: string
        issues_url*: string
        pulls_url*: string
        milestones_url*: string
        notifications_url*: string
        labels_url*: string
        releases_url*: string
        deployments_url*: string
        created_at*: string
        updated_at*: string
        pushed_at*: string
        git_url*: string
        ssh_url*: string
        clone_url*: string
        svn_url*: string
        homepage*: string
        size*: int
        stargazers_count*: int
        watchers_count*: int
        language*: string
        has_issues*: bool
        has_projects*: bool
        has_downloads*: bool
        has_wiki*: bool
        has_pages*: bool
        forks_count*: int
        mirror_url*: string
        archived*: bool
        open_issues_count*: int
        forks*: int
        open_issues*: int
        watchers*: int
        default_branch*: string

proc listRepos*(
    client: GithubApiClient,
    visibility: string = nil,
    affiliation: string = nil,
    repoType: string = nil,
    sort: string = nil,
    direction: string = nil,
    limit: int = 100,
    page: int = 1): Response =
    ## https://developer.github.com/v3/repos/#list-your-repositories

    var data = %*{
        "visibility": visibility,
        "affiliation": affiliation,
        "type": repoType,
        "sort": sort,
        "direction": direction,
        "per_page": limit,
        "page": page
    }
    var path = "/user/repos"
    client.request(path, query = data)

proc listUserRepos*(
    client: GithubApiClient,
    username: string,
    repoType: string = nil,
    sort: string = nil,
    direction: string = nil,
    limit: int = 100,
    page: int = 1): Response =
    ## https://developer.github.com/v3/repos/#list-user-repositories

    var data = %*{
        "type": repoType,
        "sort": sort,
        "direction": direction,
        "per_page": limit,
        "page": page
    }
    var path = "/users" / username / "repos"
    client.request(path, query = data)

proc listOrgRepos*(
    client: GithubApiClient,
    orgName: string,
    repoType: string = nil,
    limit: int = 100,
    page: int = 1): Response =
    ## https://developer.github.com/v3/repos/#list-organization-repositories

    var data = %*{
        "type": repoType,
        "per_page": limit,
        "page": page
    }
    var path = "/orgs" / orgName / "repos"
    client.request(path, query = data)

proc listAllRepos*(
    client: GithubApiClient,
    since: int = 0): Response =
    ## https://developer.github.com/v3/repos/#list-all-public-repositories

    var data = %*{
        "since": since
    }
    var path = "/repositories"
    client.request(path, query = data)

proc createRepo*(
    client: GithubApiClient,
    name: string,
    orgName: string = nil,
    description: string = nil,
    homepage: string = nil,
    private: bool = false,
    has_issues: bool = true,
    has_projects: bool = false,
    has_wiki: bool = true,
    team_id: int = -1,
    auto_init: bool = false,
    gitignore_template: string = nil,
    license_template: string = nil,
    allow_squash_merge: bool = true,
    allow_merge_commit: bool = true,
    allow_rebase_merge: bool = true): Response =
    ## https://developer.github.com/v3/repos/#create

    var data = %*{
        "name": name,
        "description": description,
        "homepage": homepage,
        "private": private,
        "has_issues": has_issues,
        "has_projects": has_projects,
        "has_wiki": has_wiki,
        "team_id": team_id,
        "auto_init": auto_init,
        "gitignore_template": gitignore_template,
        "license_template": license_template,
        "allow_squash_merge": allow_squash_merge,
        "allow_merge_commit": allow_merge_commit,
        "allow_rebase_merge": allow_rebase_merge
    }
    var path = if orgName != nil: "/orgs" / orgName / "repos" else: "/user/repos"
    client.request(path, body = $data, httpMethod = $HttpPost)

proc getRepo*(
    client: GithubApiClient,
    owner: string,
    repo: string): Response =
    ## https://developer.github.com/v3/repos/#get

    var path = "/repos" / owner / repo
    client.request(path)

proc editRepo*(
    client: GithubApiClient,
    owner: string,
    repo: string,
    name: string,
    description: string = nil,
    homepage: string = nil,
    private: bool = false,
    has_issues: bool = true,
    has_projects: bool = false,
    has_wiki: bool = true,
    default_branch: string = nil,
    allow_squash_merge: bool = true,
    allow_merge_commit: bool = true,
    allow_rebase_merge: bool = true): Response =
    ## https://developer.github.com/v3/repos/#edit

    var data = %*{
        "name": if name != nil: name else: repo,
        "description": description,
        "homepage": homepage,
        "private": private,
        "has_issues": has_issues,
        "has_projects": has_projects,
        "has_wiki": has_wiki,
        "default_branch": default_branch,
        "allow_squash_merge": allow_squash_merge,
        "allow_merge_commit": allow_merge_commit,
        "allow_rebase_merge": allow_rebase_merge
    }
    var path = "/repos" / owner / repo
    client.request(path, body = $data, httpMethod = $HttpPatch)

proc listRepoTopics*(
    client: GithubApiClient,
    owner: string,
    repo: string): Response =
    ## https://developer.github.com/v3/repos/#list-all-topics-for-a-repository

    var path = "/repos" / owner / repo / "topics"
    client.request(path)

proc replaceRepoTopics*(
    client: GithubApiClient,
    owner: string,
    repo: string,
    names: seq[string]): Response =
    ## https://developer.github.com/v3/repos/#replace-all-topics-for-a-repository

    var data = %*{
        "names": names
    }
    var path = "/repos" / owner / repo / "topics"
    client.request(path, body = $data, httpMethod = $HttpPut)

proc listContributors*(
    client: GithubApiClient,
    owner: string,
    repo: string,
    anon: bool = false): Response =
    ## https://developer.github.com/v3/repos/#list-contributors

    var data = %*{
        "anon": anon
    }
    var path = "/repos" / owner / repo / "contributors"
    client.request(path, query = data)

proc listLanguages*(
    client: GithubApiClient,
    owner: string,
    repo: string): Response =
    ## https://developer.github.com/v3/repos/#list-languages

    var path = "/repos" / owner / repo / "languages"
    client.request(path)

proc listTeams*(
    client: GithubApiClient,
    owner: string,
    repo: string,
    limit: int = 0,
    page: int = 1): Response =
    ## https://developer.github.com/v3/repos/#list-teams

    var data = %*{
        "per_page": limit,
        "page": page
    }
    var path = "/repos" / owner / repo / "teams"
    client.request(path, query = data)

proc listTags*(
    client: GithubApiClient,
    owner: string,
    repo: string,
    limit: int = 0,
    page: int = 1): Response =
    ## https://developer.github.com/v3/repos/#list-tags

    var data = %*{
        "per_page": limit,
        "page": page
    }
    var path = "/repos" / owner / repo / "tags"
    client.request(path, query = data)

proc deleteRepo*(
    client: GithubApiClient,
    owner: string,
    repo: string): Response =
    ## https://developer.github.com/v3/repos/#delete-a-repository
    
    var path = "/repos" / owner / repo
    client.request(path, httpMethod = $HttpDelete)