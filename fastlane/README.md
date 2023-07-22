fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Run all iOS unit and ui tests.

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sync certificates

### ios releaseWaiterRobot_develop

```sh
[bundle exec] fastlane ios releaseWaiterRobot_develop
```

Push a new lava build to TestFlight

### ios releaseWaiterRobot_main

```sh
[bundle exec] fastlane ios releaseWaiterRobot_main
```

Push a new prod build to TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
