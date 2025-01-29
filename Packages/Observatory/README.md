# Observatory

## Overview

This package provides an observatory, a helper class to fascilitate subscription to changes. 

## Usage

Extending a class with an observatory is as simple as adding two properties to the class and initializing those in the `init` method

```swift
import Observatory

class Foo {
	public let observatory: Observatory<Bool>
  private let observers: (Bool) -> Void

  init() {
		(self.observatory, self.observers) = Observatory<Bool>.create()
  	...
	}

	func bar() {
    ...
    observers(true)
	}
}
```

Note that the class Observatory is a generic class `Observatory<T>`, where T can be anything. (a Bool in the example)

You can subscribe to a observatory to get notified of changes.

```swift
// Register
import Observatory

let foo = Foo()
let token: Oberservatory.ObserverToken? = foo.observatory.append { [weak self] changed in
	if changed {
  	...
	}                                                            
}

// Unregister
observerToken.map(foo.observatory.remove)

```

---

## Contribution process

The development team works on the repository in a private fork (for reasons of compliance with existing processes) and shares its work as often as possible.

If you plan to make non-trivial changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).

Note that all commits should be signed using a [gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account).

---

## License

License is released under the EUPL 1.2 license. See [LICENSE.txt](https://github.com/minvws/nl-mgo-app-ios-private/blob/main/Packages/Observatory/LICENSE.txt) for details.
