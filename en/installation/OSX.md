# macOS Installation and Setup

## Prerequisites
A supported environment. See **[Installation Prerequisites](prerequisites.md)**

## Setting up Cocos2d-x
You can get started with __Cocos2d-x__ by either downloading a self-contained
__.zip__ from the [website](https://cocos2d-x.org/download) or by cloning our
[GitHub Repo](https://github.com/cocos2d/cocos2d-x). Pick what works for you.
__There is no need to do both.__

### By downloading a .zip archive
* Download Cocos2d-x and unzip it. (maybe: __~/__ or __~/Projects__ )

    ![](iOS-img/unzip.png "")

    ![](iOS-img/unzipping.png "")

### Cloning from GitHub
Use the following commands to clone our GitHub repo and get your environment setup. If you are not familar with GitHub's workflow, [learn it](https://guides.github.com/activities/hello-world/) or download
using the step above, __By downloading a .zip archive__.

```sh
cd <to where you want to clone this repo>

git clone git@github.com:cocos2d/cocos2d-x.git

git submodule update --init

git submodule update

./download-deps.py
```

## Build and Run
__Use cmake__
```bash
cd COCOS2DX/tests/cpp-tests
mkdir mac-build
cd mac-build
cmake ..
make
```

__Use Xcode__

First use CMake to generate Xcode project,
```bash
cd COCOS2DX/tests/cpp-tests
mkdir mac-build
cd mac-build
cmake .. -GXcode
```
then open `cpp-tests.xcodeproj` and select `cpp-tests` to run.

__Use cocos command line tools__
```bash
cd COCOS2DX/tests/cpp-tests
cocos run -p mac
```

## Starting a new project
Once everything above works, you can start a new project! To do this, read our
document on the **[Cocos Command-line tool](../editors_and_tools/cocosCLTool.md)**.

## Troubleshooting
Please see this [F.A.Q](../faq/macos.md) for troubleshooting help.