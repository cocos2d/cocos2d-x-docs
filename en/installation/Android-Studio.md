<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

# Android Studio Installation and Setup

## Prerequisites
* A supported environment. See **[Installation Prerequisites](A/index.html)**

* Completed the **[Android Command-Line Instructions](Android-terminal/index.html)**

* Android Studio 2.3 [https://developer.android.com/studio/index.html](https://developer.android.com/studio/index.html)

## Setup
* unzip the __Android Studio Bundle__

* launch __Android Studio__

## Compiling `cpp-tests`
* import the `cpp-tests` project from __cocos2d-x root/tests/cpp-tests/proj.android-studio__
in __Android Studio__. __Android Studio__ will do everything required. You can run
`cpp-tests` by clicking on the __play__ button.

    ![](Android-Studio-img/build_cpp_tests.png "")

## Debugging `cpp-tests`

Since cocos2d-x __v3.15__, you can use __Android Studio 2.3+__ to debug c++ codes:

* set breakpoint by __step 1__
* run in debug mode by __step 2__
* you will see stack trace by __step 3__

    ![](Android-Studio-img/debug_cpp_tests.png "")

## Build for release mode

You have to do a few steps to build release mode:

* change __Build Variant__ to __release__
* set sign information in __gradle.properties__
* for __lua projects__, if you want to encrypt lua codes, you should set encrypt information in __gradle.properties__ too

    ![](Android-Studio-img/change_release_lua_tests.png "")

    ![](Android-Studio-img/sign_and_encrypt.png "")

## Installing new SDK versions and build tools
* use the built in __SDK Manager__ to install the __SDK versions__ and __build tools__
that you are targetting.

    ![](Android-Studio-img/toolbar_sdkmanager_1.png "")

    ![](Android-Studio-img/sdkmanager_1.png "")

    ![](Android-Studio-img/sdkmanager_2.png "")

  Note: It is important to note that __Android Studio__ uses a location to install
  __SDK versions__ and __build tools__ that is not the same as if you were doing
	command-line development. Double check that you have everything you need installed
	from inside __Android Studio__.

## Starting a new project
Once everything above works, you can start a new project! To do this, read our
document on the **[Cocos Command-line tool](../editors_and_tools/cocosCLTool/)**.
