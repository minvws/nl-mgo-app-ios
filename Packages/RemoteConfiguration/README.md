# RemoteConfiguration

## Overview

On startup of the app, a remote configuration is fetched with the latest app settings.

## Usage

```swift

import RemoteConfiguration

let serverURL = URL(string: "https://example.com")
let repository = RemoteConfigurationRepository(
    apiClient: RemoteConfigurationClient(serverUrl: serverURL)
)

// Listen to changes in the remote configuration
let observerToken = repository.observatory.append { [weak self] remoteConfiguration in
	guard let self else { return }
	
	// handle remote configuration changes
	...

}

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

--- 

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/RemoteConfiguration/LICENSE.txt) for details.
