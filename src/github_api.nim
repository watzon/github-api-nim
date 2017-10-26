import streams, json
import ./github_api/client
import ./github_api/repository
import ./github_api/gist

var cli = newGithubApiClient(accessToken = "5634974f1b611f092ba91ec7ce8eb593f11aec67")
var response = cli.deleteGist("d8b6d133fa33eef1aeacd5adee9cf864")

echo(parseJson(readAll(response.bodyStream)).pretty())


