# Nim GitHub API Wrapper

This is a wrapper for the GitHub API written in Nim. To get started add this to your `.nimble` file:

```nim
requires "github_api >= 0.1.0"
```

The import it into your project and create an instance of the `GithubApiClient`

```nim
import github_api

var client = newGithubApiClient()

# Or, with a auth token

var client = newGithubApiClient("b24123832b745c3fe5e4e6606het7co73e31f21")
```

## Usage

After importing `github_api` and creating an instance of the `GithubApiClient` you can use the client to easily send requests, authenticated or not, to the GitHub API. Note: some requests do require authentication.

```nim
import json, streams
import github_api

var client = newGithubApiClient("b24123832b745c3fe5e4e6606het7co73e31f21")

var res = client.listUserRepos("watzon")

if res.status.startsWith("200"):
    var repos = parseJson(res.bodyStream.readAll())
    echo(repos.pretty())
```

## Roadmap

I have gotten a lot done on this in a very short period of time, but there is still a lot left to do. Here are the planned features:

- [x] Base Client
- [-] Data Types
    - [ ] Activity
    - [x] Gists
    - [ ] Gist Data
    - [ ] Apps
    - [ ] Migration
    - [ ] Organizations
    - [ ] Projects
    - [ ] Pull Requests
    - [ ] Reactions
    - [x] Repositories
    - [x] Search
    - [ ] Miscellaneous
        - [ ] Codes of Conduct
        - [ ] Emojis
        - [ ] Gitignore
        - [ ] Licenses
        - [ ] Markdown
        - [ ] Meta
        - [ ] Rate Limit
- [ ] OAuth Authorizations
- [ ] Basic Authentication