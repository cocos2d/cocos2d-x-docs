# 预编译库

和任何大型项目一样，Cocos2d-x 引擎是由数千个源文件组成。通过这些源文件，你可以了解到引擎内部工作的原理，你可以根据需要修改这些文件。但是这种自由是有代价的！不是金钱，而是更有价值的东西，时间！编译时间！

每当项目的源文件发生更改时，编译器都会重新编译所有文件，包含引擎的源码，这样编译一个项目，都将花费相当长的时间，每天都可能会编译多次，加起来总编译时间非常可怕！幸运的是有一个简单的解决方案，使用预构建，也称为静态库。将引擎源码编译为静态库，在这个过程中引擎的所有源码会被编译成一个单独的静态库文件，然后你可以将这个库链接到项目中。这样在编译项目的时候，引擎源码不会被编译，编译时间就会大大缩短。

## 创建静态库

静态库可以在 *iOS*, *macOS*, *Android* 和 *Win32* 这些平台上使用。

在项目中使用静态库之前，你需要先将静态库创建出来。假设你已经配置好 cocos [命令行工具](./cocosCLTool.md) 了，请这样操作：

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

构建静态库的过程由于不同的硬件和软件配置，可能需要几分钟到几个小时。构建完成后，静态库会放在引擎根目录下 _prebuilt_ 子目录。在 Cocos2d-x 的项目中，你可以配置静态库链接到这个位置，这样这个目录内的静态库就可以在多个项目中使用。你也可以将静态库文件复制到单个项目中，或其它你觉得合适的位置。

运行 `cocos gen-libs --help` 来查看更多关于构建静态库的帮助信息。

## 使用静态库

在项目中使用构建的静态库是很简单的，只需要将库简单的添加到项目中，并设置头文件和包含文件的搜索路径。具体的绝对路径取决于你的环境，你需要添加的一系列路径是：

__头文件搜索路径:__

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

__包含文件搜索路径:__

```sh
/path_to_cocos2d-x/cocos2d-x/prebuilt/ios
```

_/path_to_cocos2d-x 指引擎根目录的路径_