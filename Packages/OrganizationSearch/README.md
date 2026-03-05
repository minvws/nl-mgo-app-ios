# Organization Search

## Overview

The `OrganizationSearch` Swift package provides fast, offline search over a bundled dataset of Dutch healthcare organizations. It exposes `OrganizationSearchClientProtocol` with one production implementation: `OrganizationSearchClient`, backed by SQLite + GRDB FTS5.

### Search strategy

Queries run in two passes:

1. **Prefix pass** — every typed word must appear in the document (AND + prefix semantics). Fast and exact for correctly-spelled input.
2. **Fuzzy fallback** — when the prefix pass returns nothing, each token is expanded to all strings within edit distance 1 (deletion, substitution, insertion, transposition). This handles common typos like `"hiusman"` matching `"Huisman"`.

### Datasets

The package bundles several JSON organization datasets selected via `OrganizationDataset`:

| Case | File | Purpose |
|---|---|---|
| `.medmij` | `organizations-medmij.json` | MedMij-filtered subset |
| `.test` | `organizations-test.json` | Small fixture for unit tests |
| `.benchmark` | `organizations-benchmark.json` | Benchmark measurements |


### Hash-based populate skip

`prepare()` stores a SHA-256 digest of the bundled JSON file in a `metadata` table inside the SQLite database. On subsequent launches the digest is recomputed and compared:

- **Hash matches** — the database is already up to date; `prepare()` returns immediately without touching the schema or inserting any rows.
- **Hash differs** — the JSON has changed (e.g. after an app update); the schema is rebuilt and all records are re-inserted, then the new hash is stored.

Because the hash lives in the same file as the data it describes, the two can never get out of sync: if the database is deleted the hash is gone too, and the next `prepare()` repopulates from scratch.

### Memory-efficient loading

When a repopulate is needed, `prepare()` uses two techniques to keep memory usage low:

- **Memory-mapped I/O** — the JSON file is opened with `.mappedIfSafe`, so the OS pages bytes in on demand rather than copying the entire file into RAM. Pages that have already been consumed by `JSONDecoder` can be evicted under memory pressure.
- **Chunked inserts** — records are written to SQLite in batches of 1 000. Each committed transaction releases GRDB's internal WAL state before the next batch starts, avoiding a single large transaction that would hold all data in memory simultaneously.

## Usage

```swift
import OrganizationSearch

// 1. Create a client
let client = OrganizationSearchClient()

// 2. Prepare the search index (memory-maps the JSON and builds the SQLite FTS5 table)
try await client.prepare()          // uses .medmij dataset by default
// try await client.prepare(dataset: .benchmark)  // or a specific subset

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

