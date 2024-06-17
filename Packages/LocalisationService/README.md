# LocalisationService

## Overview

With the use of the [open-api generator](https://github.com/apple/swift-openapi-generator) this package creates methods to find Dutch Healthcare Providers from [ZorgAB](https://www.vzvz.nl/diensten/gemeenschappelijke-diensten/zorg-ab) through the [lo-ad server](https://lo-ad.test.mgo.irealisatie.nl/docs#/) from iRealisatie. 

## Usage

### Searching for Healthcare Providers

You can search for healthcare providers with the LocalisationServiceClient by using two String parameters, city and name. It will return a list of healthcare providers. 

```swift
import LocalisationService

let client: LocalisationServiceClientProtocol = LocalisationServiceClient()
let city: String = "Roermond"
let name: String = "Tandarts"

do {
	let searchResultsList: [HealthcareProvider] = try await client.searchHealthcareProviders(city: city, name: name)
	print("We found \(searchResultsList.count) organisations.")
} catch {
	print("Error fetching organisations \(error)")
}
```

### Storing Healthcare Providers

A healthcare provider can be stored to and read from local disk with the HealthcareProviderRepository

```swift
// Storing
import LocalisationService

let repository: HealthcareProviderRepositoryProtocol = HealthcareProviderRepository()
let healthcareProvider = searchResultList.first!
repository.store(healthcareProvider)

```

```swift
// Reading
import LocalisationService

let repository: HealthcareProviderRepositoryProtocol = HealthcareProviderRepository()
let healthcareProviders = repository.providers

```

### Observatory

You can subscribe to a repository to get notified of changes in the provider list.

```swift
// Register
import LocalisationService

let repository: HealthcareProviderRepositoryProtocol = HealthcareProviderRepository()
@Published var healthcareProviders = repository.providers
let observerToken: Observatory.ObserverToken? = repository.observatory.append { [weak self] changed in
	if changed {
		// refetch the providers
		self?.healthcareProviders = repository.providers
	}
}

// Unregister
observerToken.map(repository.observatory.remove)

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

--- 

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/LICENSE.txt) for details.
