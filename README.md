<p align="center">
    <img src="documentation/wr-square-rounded.png" style="width:200px; border-radius: 15px;" alt="kellner.team logo"/>
</p>
<h1 align="center">kellner.team</h1>
<div align="center">
    <p>Lightning fast and simple gastronomy</p>
    <a href="https://apps.apple.com/at/app/waiterrobot/id1610157234?itsct=apps_box_badge&itscg=30200">
      <img src="https://toolbox.marketingtools.apple.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&releaseDate=1660003200" alt="Download on the App Store" style="border-radius: 13px; width: 155px;">
    </a>
</div>

# iOS

This Repository includes the iOS version of the kellner.team App. It is based on a shared Kotlin-Multiplatform (KMM)
module, which can be found [here](https://github.com/DatepollSystems/waiterrobot-mobile_android-shared) (there you can
also find the Android version of the app).
The KMM module is integrated as a Swift-Package (shared).

## Getting started

This project uses XcodeGen for generating the Xcode project.

1. Xcodegen

Run in your terminal: 

```bash
swift run xcodegen
```

> This command must also be run after switching branches and it's advisable to also run it after a `git pull`

2. Git pre-commit hook

To have unified formatting, we use SwiftFormat. The pre-commit hook can be installed if the code should be formatted automatically before every commit. Execute following command in your terminal:

```bash
bash install-git-hook.sh
```


3. Add credentials for the GitHub Maven Package Registry

To be able to download the shared SPM package from the GitHub Package Registry you need to authenticate against GitHub.
Therefore you need to add the following to your `~/.netrc` file (create the file if it doesn't exist).
The personal access token can be created on GitHub under 
[Settings -> Developer settings -> Personal access tokens -> Fine-grained tokens -> Generate new token](https://github.com/settings/personal-access-tokens/new).
The token just needs the "Public Repositories (read-only)" access. No additional permissions are needed.

```
machine maven.pkg.github.com
  login [github username]
  password [your new personal access token]
```

4. Open the `WaiterRobot.xcodeproj` in Xcode and start coding :)


## Dev with local KMM module version

For a guide to use a local version of the KMM module
see [KMMBridge local dev spm](https://touchlab.github.io/KMMBridge/spm/IOS_LOCAL_DEV_SPM)

### TLRD

1. Run `./gradlew spmDevBuild` in the KMM project (must be run after each change in the KMM module)
2. Drag the whole KMM project folder (top level git folder) into the WaiterRobot project in Xcode
3. Start programming :)
4. When finished delete folder, make sure to select "Remove References"!!! (otherwise the whole KMM
   project will be deleted locally)

## Releasing

Production release is triggered on push to main. The CI then builds the app and deploys it to
TestFlight. After testing the app then must be released manually from there. A tag in the form of 
`major.minor.patch` (e.g. 1.0.0) is created. (see [publish.yml](.github/workflows/publish.yml))

> Do not forget to bump the iOS app version ([project.yml](project.yml), CFBundleShortVersionString & CFBundleVersion) 
> on the dev branch after a production release was made.

On each push to develop also a lava (dev) build is triggered and published to TestFlight of
the WaiterRobot Lava app. A tag in the form of `major.minor.patch-lava-epochMinutes` is created 
(e.g. 1.0.1-lava-27935730). (see [publish.yml](.github/workflows/publish.yml))

# Language, libraries and tools

- [Swift](https://www.apple.com/de/swift/)
- [XcodeGen](https://yonaskolb.github.io/XcodeGen/)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [CodeScanner](https://github.com/twostraws/CodeScanner) QR-Code scanner
- [UIPilot](https://canopas.github.io/UIPilot/) SwiftUI navigation
- [Fastlane](https://docs.fastlane.tools/)
  - [Match](https://docs.fastlane.tools/actions/match/)
