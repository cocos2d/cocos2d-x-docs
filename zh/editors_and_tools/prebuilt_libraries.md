# 预编译库

Cocos2d-x, like any large scale project, is made up of many hundreds of source files. You can examine the inner-workings or __peer under the hood__ of Cocos2d-x through these source files. You can modify these files as you wish. This freedom comes at a cost, however. No, not as in money, but something much more valuable! __Compiling time!!__. Every time a source file is changed, the __compiler__ must recompile all files that are part of the projects. __Compiling__ a project costs developers time. Compiling many, many times a day adds up even more time. Fortunately, there is an easily solution. Use __prebuilt__, also called __static__ libraries. This process wraps up all the source files in a project into a single __library__ that you can use to compile and link againt in your projects. Since the compiler knows that this library has not changed between compilers, there is no need to re-compile it. This is the same as saying: "I won't touch the engine, just build on top if it". Your compile times will go down from several minutes to perhaps less than one minute.

和任何大型项目一样，Cocos2d-x 引擎是由数千个源文件组成。通过这些源文件，你可以了解到引擎内部工作的原理，你可以根据需要修改这些文件。但是这种自由是有代价的！不是金钱，而是更有价值的东西，时间！编译时间！

每当项目的源文件发生更改时，编译器都会重新编译所有文件，包含引擎的源码，这样编译一个项目，都将花费相当长的时间，每天都可能会编译多次，加起来总编译时间非常可怕！

## 创建预编译库

Prebuilt libraries are available on *iOS*, *OS X*, *Android* and *Win32*

In-order to use the prebuilt libraries in your projects you need to compile them. This assumes that you already haave a working Cocos2d-x installation. If you do not, please refer to [../installation/]().

Some examples:
```cpp
# remove the 'prebuilt' folder
# without the -m flag, this builds for release mode
# generates libraries for every platform (ios, mac, android, win32)
cocos gen-libs -c

# remove the 'prebuilt' folder
# without the -m flag, this builds for release mode
# generates libraries for just ios
cocos gen-libs -c -p ios

# remove the 'prebuilt' folder
# without the -m flag, this builds for release mode
# generates libraries for just ios and android
cocos gen-libs -c -p ios -p android

# remove the 'prebuilt' folder
# with the -m flag, this builds for debug
# generates libraries for just ios and android
cocos gen-libs -c -p ios -m debug
```

The build process can take between several minutes and several hours, depending upon your hardware and software setup. Once complete the prebuilt libraries are located in: __prebuilt/__, inside your Cocos2d-x root directory. You can easily __symlink__ to these projects, thus allowing these libraries to be used amongst several projects at once, or you can copy them to individual projects or another location that better suits your needs.

You can run __cocos gen-libs --help__ to see all available options broken down by platform.

## 使用预编译库

Using the prebuilt libraries in your projects is easy. Simply add the libraries you need into your project and set your __header__ and __include__ search paths. Doing this depends upon the enviroment you are using. The paths you need to add are:

__Header Search Paths:__
```sh
# Project level
/path_to_cocos2d-x/cocos2d-x/
/path_to_cocos2d-x/cocos2d-x/cocos
/path_to_cocos2d-x/cocos2d-x/cocos/base /path_to_cocos2d-x/cocos2d-x/cocos/physics /path_to_cocos2d-x/cocos2d-x/cocos/math
/path_to_cocos2d-x/cocos2d-x/cocos/2d
/path_to_cocos2d-x/cocos2d-x/cocos/ui /path_to_cocos2d-x/cocos2d-x/cocos/network /path_to_cocos2d-x/cocos2d-x/cocos/audio/include /path_to_cocos2d-x/cocos2d-x/cocos/editor-support /path_to_cocos2d-x/cocos2d-x/extensions
/path_to_cocos2d-x/cocos2d-x/external /path_to_cocos2d-x/cocos2d-x/external/chipmunk/include/chipmunk

# Target level
/path_to_cocos2d-x/cocos2d-x/cocos/platform/ios /path_to_cocos2d-x/cocos2d-x/cocos/platform/ios/Simulation
```

__Include Search Paths:__
```sh
/path_to_cocos2d-x/cocos2d-x/prebuilt/ios
```
