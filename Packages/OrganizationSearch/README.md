# Organization Search

## Overview

The `OrganizationSearch` Swift package provides fast, offline search over a bundled dataset of Dutch healthcare organizations. It exposes a single `OrganizationSearchClientProtocol` with two concrete implementations:

| Implementation | Backend | Use case |
|---|---|---|
| `OrganizationSearchClient` | SQLite + GRDB FTS5 | Production app |
| `OrganizationSearchJSClient` | JavaScriptCore | Reference / benchmarks |

### Search strategy (`OrganizationSearchClient`)

Queries run in two passes:

1. **Prefix pass** — every typed word must appear in the document (AND + prefix semantics). Fast and exact for correctly-spelled input.
2. **Fuzzy fallback** — when the prefix pass returns nothing, each token is expanded to all strings within edit distance 1 (deletion, substitution, insertion, transposition). This handles common typos like `"hiusman"` matching `"Huisman"`.

### Datasets

The package bundles several JSON organization datasets selected via `OrganizationDataset`:

| Case | File | Purpose |
|---|---|---|
| `.full` | `organizations-full.json` | Complete dataset (default) |
| `.medmij` | `organizations-medmij.json` | MedMij-filtered subset |
| `.test` | `organizations-test.json` | Small fixture for unit tests |
| `.benchmark` | `organizations-benchmark.json` | Benchmark measurements |


## Usage

```swift
import OrganizationSearch

// 1. Create a client (GRDB-backed, recommended for production)
let client = OrganizationSearchClient()

// 2. Prepare the search index (loads JSON and builds the SQLite FTS5 table)
try await client.prepare()          // uses .full dataset by default
// try await client.prepare(dataset: .medmij)  // or a specific subset

// 3. Search
let results = try await client.searchHealthcareOrganizations("huisarts Amsterdam")
for hit in results.hits {
    print(hit.document.displayName ?? "", hit.document.city ?? "")
}

// 4. Release resources when done
await client.teardown()
```

For dependency injection and testing, use `OrganizationSearchClientProtocol` and the bundled `OrganizationSearchClientSpy`.


## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE](https://github.com/minvws/nl-mgo-app-ios?tab=License-1-ov-file#readme) for details.

