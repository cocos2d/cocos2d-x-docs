# Windows Installation and Setup

## Prerequisites
A supported environment. See **[Installation Prerequisites](prerequisites.md)**

## Setting up Cocos2d-x
You can get started with __Cocos2d-x__ by either downloading a self-contained
__.zip__ from the [website](https://cocos2d-x.org/download) or by cloning our
[GitHub Repo](https://github.com/cocos2d/cocos2d-x). Pick what works for you.
__There is no need to do both.__ Make sure you have a working environment. This means
a working __Python__, having run __<cocos2d-x root>/setup.py>__ and updated your
__$PATH__.

### By downloading a .zip archive
* Download Cocos2d-x and unzip it. (maybe: c:\Users\your_user_id)

    ![](Windows-img/1.png "")

### Cloning from GitHub
Use the following commands to clone our GitHub repo and get your environment setup. If you are not familar with GitHub's workflow, [learn it](https://guides.github.com/activities/hello-world/) or download
using the step above, __By downloading a .zip archive__.

```sh
c:\<to where you want to clone this repo>

git clone git@github.com:cocos2d/cocos2d-x.git

git submodule update --init

git submodule update

./download-deps.py
```

## Compile and run the `cpp-tests` project
* Open __cocos2d-win32.vc2012.sln__ in the __build__ folder

    ![](Windows-img/2.png "")

* Right click the __TestCpp__ project, and select __Set as StartUp Project__.

    ![](Windows-img/3.png "")

* Compile and run the __TestCpp__ project.

## Starting a new project
Once everything above works, you can start a new project! To do this, read our
document on the **[Cocos Command-line tool](../editors_and_tools/cocosCLTool.md)**.

### Distributing a Cocos2d-x app on Windows

> __Note:__ this falls outside of the realm of Cocos2d-x. Please consult Microsoft resources for assistance.

If you try to run a game created with Cocos2d-x on a non-development machine, it may be required for this machine to have the __Visual Studio runtime__ installed. The easiest way is to create an installer for your game, but it is possible to do it without by installing all required pieces manually.

* Use [Dependency Walker](http://www.dependencywalker.com/) to check what DLLs your game requires.

* Install the required Visual Studio runtime.  Microsoft has now merged VS2015, 2017 and 2019 runtimes into one, which you can find [here](https://support.microsoft.com/ms-my/help/2977003/the-latest-supported-visual-c-downloads).

For the installer, check these posts:

* [InnoSetup](https://discuss.cocos2d-x.org/t/please-give-me-some-pointers-advice-before-pc-release/43935/3) (also shows you a sample for how to install the VS C++ runtime using it).

* Sample InnoSetup script for Cocos2d-x [here](https://discuss.cocos2d-x.org/t/exe-file-sharing/45569/6).

## Troubleshooting
Please see this [F.A.Q](../faq/windows.md) for troubleshooting help.