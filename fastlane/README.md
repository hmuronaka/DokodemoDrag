fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## Mac
### mac release
```
fastlane mac release
```
release. option version: 0.3.0 ...
### mac set_version_number
```
fastlane mac set_version_number
```
set version number
### mac increment_all_app_build_numbers
```
fastlane mac increment_all_app_build_numbers
```
increment all app's build_numbers
### mac build
```
fastlane mac build
```
build and zip app-file

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
