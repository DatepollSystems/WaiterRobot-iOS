# WaiterRobot iOS
This Repository include the iOS version of the WaiterRobot App. It is based on a shared Kotlin-Multiplatform (KMM) module, which can be found [here](https://github.com/DatepollSystems/waiterrobot-mobile_android-shared) (there you can also find the Android version of the app).
The KMM module is integrated as an SPM Package (shared).

## Getting started
This project uses xcodegen for generating the Xcode project.

1. If not installed, you can install xcode gen using brew:
```bash
brew install xcodegen
```

2. Generate the xcode project (run in root folder, where the `project.yml` lives):
```bash
xcodegen
```
This command must also be run after switching branches and it's advisable to also run it after a `git pull`

3. Open the `WaiterRobot.xcodeproj` in xCode and start coding :)

## Dev with local KMM module version
For a guide to use a local version of the KMM module see [KMMBridge local dev spm](https://touchlab.github.io/KMMBridge/spm/IOS_LOCAL_DEV_SPM)

### Short version
1. `./gradlew spmDevBuild` (must be run after each change in the KMM module)
2. Drag the whole KMM project folder into the WaiterRobot project in Xcode
3. Start programming :)
4. When finished delete folder, make sure to select "Remove References"!!! (otherwise the whole KMM project will be deleted locally)
5. Do not push the changes of Package.swift file!
