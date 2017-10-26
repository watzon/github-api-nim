# Package

version       = "0.1.0"
author        = "Chris Watson"
description   = "Connector for the GitHub API v3"
license       = "WTFNMFPL-1.0"

srcDir        = "src"
bin           = @["github_api"]
skipDirs      = @["test"]

# Dependencies

requires "nim >= 0.17.2"

