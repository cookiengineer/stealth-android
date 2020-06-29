
# Stealth for Android

[Stealth](https://github.com/cookiengineer/stealth) is a Web Browser/Proxy/Scraper
that uses node.js in order to have full Peer-to-Peer network capabilities.

This means that a port to Android requires a custom compiled `libnode.so` that
can be included in an `Native C++` Android project.

This repository hosts everything you need to build Stealth for Android yourself.
The node.js build workflow, the dependencies (Android SDK and Android NDK) and
the API level plugins for the Android SDK.

Currently, Stealth is built for `Android 10` (`SDK version / API level 30`) in
order to make sure everything is as modern and as up-to-date as possible.


## Requirements

Currently, the `Android SDK` and Android NDK` have to be installed:

**Option 1: Install Packages on Arch Linux**

```bash
sudo pacman -S --needed android-ndk android-sdk-build-tools android-sdk-cmake android-tools;
sudo pacman -S --needed base-devel clang llvm;
```

**Option 2: Manual Installation**

- Download and install the [Android NDK r21](https://dl.google.com/android/repository/android-ndk-r21.d-linux-x86_64.zip).
- Download and install the Android SDK's [Build Tools r30](https://dl-ssl.google.com/android/repository/build-tools_r30-linux.zip).
- Download and install the Android SDK's [cmake 3.10.2](https://dl-ssl.google.com/android/repository/cmake-3.10.2-linux-x86_64.zip).
- Install clang and llvm, including the base development libraries and headers for your Host OS.


## Submodule

The idea of this repository is to use upstream [nodejs/node](https://github.com/nodejs/node)
as much as possible without having to patch hundreds of files manually. Most other projects
hardfork nodejs, then maintain it for a while, then abandon it.

This project aims to not abandon nodejs yet again, therefore everything will be pull requested
to upstream (if changes are necessary).


## Building

For now, the `build-node.sh` has to be modified to fit the local Android NDK and Android SDK paths.
Also, it's important to set the `ANDROID\_SDK\_VERSION` variable to the same API level that the App
uses, otherwise it will segfault after building.

