fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### remove_temp_keychain

```sh
[bundle exec] fastlane remove_temp_keychain
```



----


## iOS

### ios test_ci

```sh
[bundle exec] fastlane ios test_ci
```

Run tests for integration purposes

### ios e2e_ci

```sh
[bundle exec] fastlane ios e2e_ci
```

Run end to end tests

### ios ship_app_to_testflight

```sh
[bundle exec] fastlane ios ship_app_to_testflight
```

Build and ship the app to TestFlight

### ios deploy_test_ci

```sh
[bundle exec] fastlane ios deploy_test_ci
```

Build and deploy the app for Test via Firebase from CI

### ios deploy_acc_ci

```sh
[bundle exec] fastlane ios deploy_acc_ci
```

Build and deploy the app for Acc via Firebase from CI

### ios deploy_prod_ci

```sh
[bundle exec] fastlane ios deploy_prod_ci
```

Build and deploy the app for Prod via Firebase from CI

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
