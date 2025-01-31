# FileStorage

## Overview

This package provides fileStorage, a helper class to read and store files to disc.

## Usage

The FileStorage class contains four methods for creating, reading and deleting files. 

### CRUD operations

To store a file
```swift

import FileStorage

let storage = FileStorage()
let element: Codable = ...
let fileName = "filename.json"
let encoded = try JSONEncoder().encode(element)
try storage.store(encoded, as: fileName)

```

To read a file
```swift

if let jsonData = storage.read(fileName: fileName), 
	if let data = try JSONDecoder().decode([Object].self, from: jsonData) {
	...
}
```

To check for the existence of a file
```swift
let exists = storage.fileExists(fileName) // True if the file exists, false otherwise

```

And to remove a file
```swift
	storage.remove(fileName)
```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/FileStorage/LICENSE.txt) for details.
