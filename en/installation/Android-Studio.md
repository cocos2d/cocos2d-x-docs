# Android Studio Installation and Setup

## Prerequisites
* A supported environment. See **[Installation Prerequisites](A/index.html)**

* Android Studio 2.3.3 or Studio 3.0 [https://developer.android.com/studio/index.html](https://developer.android.com/studio/index.html)

## Setup
* unzip the __Android Studio Bundle__

* launch __Android Studio__. This may take quite some time as additional downloads and setup steps are completed. These steps are necessary for Studio to run properly.

* after the previous step is complete, it is necessary install the SDK and build tools. __SDK Manager__ is located in the __Tools__ menu, __Android__, then select __SDK Manager__. The Window looks like this:

    ![](Android-Studio-img/sdkmanager.png "")

  Make sure to install the platforms and tools that your project requires.

    ![](Android-Studio-img/sdkmanager_1.png "")

    ![](Android-Studio-img/sdkmanager_2.png "")

## Compiling `cpp-tests`
* import the `cpp-tests` project from __cocos2d-x root/tests/cpp-tests/proj.android-studio__
in __Android Studio__. __Android Studio__ will do everything required. You can run `cpp-tests` by clicking on the __play__ button.

    ![](Android-Studio-img/build_cpp_tests.png "")

## Debugging `cpp-tests`
Since cocos2d-x __v3.15__, you can use __Android Studio 2.3+__ to debug c++ code:

* set breakpoint by __step 1__
* run in debug mode by __step 2__
* you will see stack trace by __step 3__

    ![](Android-Studio-img/debug_cpp_tests.png "")

## Build for release mode
There are a few required steps to build in release mode:

* change __Build Variant__ to __release__
* set sign information in __gradle.properties__
* for __lua projects__, if you want to encrypt lua codes, you should set encrypt information in __gradle.properties__ too

    ![](Android-Studio-img/change_release_lua_tests.png "")

    ![](Android-Studio-img/sign_and_encrypt.png "")

## Installing new SDK versions and build tools
* use the built in __SDK Manager__ to install the __SDK versions__ and __build tools__ that you are targetting.

    ![](Android-Studio-img/toolbar_sdkmanager_1.png "")

    ![](Android-Studio-img/sdkmanager_1.png "")

    ![](Android-Studio-img/sdkmanager_2.png "")

  Note: It is important to note that __Android Studio__ uses a location to install __SDK versions__ and __build tools__ that is not the same as if you were doing command-line development. Double check that you have everything you need installed from inside __Android Studio__.

## Starting a new project
Starting a new project requires a few steps:
* first, use `cocos new ...` to create your project. See the **[Cocos Command-line tool](../editors_and_tools/cocosCLTool/)** for additional help.
* next, launch __Android Studio__.
