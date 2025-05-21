# GitHub Artifact Download

## Overview

This package will download an artifact from a GitHub repository

## Usage

The `GithubArtifactDownload` command take the following parameters:
* token: the GitHub API Token (see [github.com](https://github.com/settings/tokens) for your tokens)
* owner: the owner of the repository (github.com/*owner*/repository)
* repository: the repository (github.com/owner/*repository*)
* workflow-id: the identifer of the workflow (see [github.com](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#list-repository-workflows) for details how to get the id)
* output: the output file for the artifact

```swift

	swift run GithubArtifactDownload --token ${GITHUB_API_KEY} --owner "minvws" --repository "nl-mgo-app-web-private" --workflow-id "114414377" --output tmp/artifact.zip
```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/CopyImport/LICENSE.txt) for details.
