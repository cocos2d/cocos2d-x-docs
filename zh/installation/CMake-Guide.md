# CMake 使用指南

CMake 是一个开源的跨平台构建工具，Cocos2d-x 是一个开源的跨平台游戏引擎，两者十分契合。另外 CMake 被各平台的接受程度也越来越高，Cocos2d-x 决定自 3.17 版本开始，支持 CMake 的全平台构建。

支持的平台包括 Android (NDK)、iOS、macOS、Linux、Windows（VC++ compiler），同时支持通过 CMake 将引擎部分进行预编译，并在新的构建过程中重用预编译的引擎库。通过这种方式，可以极大的缩短工程构建时间。

## 基本概念

在使用 CMake 构建工程之前，最好能对软件构建中一些基本的概念有初步的了解，比如什么是编译，链接，打包。了解这些对后续使用 CMake 有很大的帮助。此处只解释一个 CMake 特有的概念：外部构建（Out-of-source Build），在从源码生成最终的二进制可执行文件的过程中，会生成大量的中间文件，中间文件和源码在同一个目录内称为内部构建（In-source Build）,当内部构建时中间文件会使源码目录脏乱不堪，为了解决这个问题，CMake 提供了外部构建，即将所有生成的中间文件都放在一个非源码目录中，这样无论构建多少次，源码目录始终干净如新。

## 常用构建选项

### CMake 通用

1. `-G`，通过 CMake 生成特定 IDE 的项目配置文件。这个操作依赖 IDE，即无法在一个没安装 Xcode 的 macOS 上通过 CMake 生成对应的工程文件。

    * `-GXcode` 生成 Xcode 工程文件
    * `-GVisual Studio 15 2017` 生成 Visual Studio 2017 工程文件

1. `CMAKE_BUILD_TYPE`, 指定构建模式，比如 Debug 还是 Release，默认值 Debug。

    * `-DCMAKE_BUILD_TYPE=Release` 指定以 Release 模式生成工程。

1. `-H -B`，`-H` 用来指定一个源码目录，指定的目录必须含有一个 CMakeLists.txt 文件，`-B` 用来指定 CMake 生成的中间文件的存放目录。

    * `-H..\cocos2d-x  -Bmsvc_build` 指定要构建工程的工程路径是上一级目录的 cocos2d-x 子目录，指定 CMake 生成的文件存放在 msvc_build 目录。

1. `--build <dir>` 执行构建过程，同时指定曾使用 CMake 命令生成的构建文件所在目录。

    * `cmake --build ./msvc_build` 在执行这个构建过程时，CMake 会自动选择对应的构建工具。

### Cocos2d-x 特有

以下 Cocos2d-x 特有的选项和通过 CMake 使用预编译库有关。

1. `GEN_COCOS_PREBUILT` 控制构建过程是否生成预编译库，默认行为是不生成，开启选项将会增加一个构建目标：prebuilt，执行这个构建目标时，将会编译引擎部分的代码，并将生成的库文件，拷贝至存放预编译库的目录，默认将库拷贝至引擎目录的 prebuilt 子目录。

    * `-DGEN_COCOS_PREBUILT=ON` 将会增加一个构建目录：prebuilt，用于执行库的生成，拷贝。

1. `USE_COCOS_PREBUILT` 控制生成的构建工程是否使用预编译库，默认行为是不使用，开启选项将会自动查找使用预编译库，关闭库相关的构建目标，默认在引擎目录的 prebuilt 子目录查找预编译库。

    * `-DUSE_COCOS_PREBUILT=ON` 将会自动使用预编译库，关于库相关的 target。

1. `COCOS_PREBUILT_ROOT` 指定预编译库存放的目录，是一个可选选项，对于在 Android 平台中使用预编译库是一个必选选项，因为正常情况下，Android Studio 在进行 CMake 构建过程时，无法获取到环境变量，导致找不到引擎根目录。

    * `-DCOCOS_PREBUILT_ROOT=/Users/laptop/cocos-prebuilt` 设置存放/查找预编译库的目录


## 各平台构建示例

### Linux

```sh
cd cocos2d-x
mkdir linux-build && cd linux-build
cmake ..
make -j 4
``` 
在执行 `make -j 4` 命令之前，可以执行 `make help` 查看所有的构建目标，使用 `make <target>` 构建一个特定的目标。

### Windows

```sh
cd cocos2d-x
mkdir win32-build && cd win32-build
cmake .. -G"Visual Studio 15 2017"
```
以上命令使用 CMake 生成 Cocos2d-x 测试项目的 Visual Studio 2017 工程。生成后，在文件浏览器中找到 `cocos2d-x/win32-build` 目录，双击打开 __Cocos2d-x.sln__。设置 cpp-tests 为启动项目，即可正常编译运行。

另一种方式，由于 Visual Studio 2017 已经直接支持 CMake 工程，可以直接使用。详细请参考 [Visual Studio 2017 文档 CMake 支持](https://docs.microsoft.com/zh-cn/cpp/ide/cmake-tools-for-visual-cpp)。

### macOS

```sh
cd cocos2d-x
mkdir mac-build && cd mac-build
cmake .. -GXcode
open Cocos2d-x.xcodeproj
```

### iOS

```sh
cd cocos2d-x
mkdir ios-build && cd ios-build
cmake .. -GXcode -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake
open Cocos2d-x.xcodeproj
```

默认构建的是为运行在 iOS 设备的工程，如果想构建运行在模拟器的工程，请加参数 `-DIOS_PLATFORM=SIMULATOR` 或 `-DIOS_PLATFORM=SIMULATOR64`。

### Android

默认工程配置在 Android 上使用旧有的 ndk-build 构建 C++ 部分，开启 CMake 构建，请先更改 Gradle 配置中的 `PROP_NDK_MODE` 属性为 cmake，再同步 Gradle 配置，同步完成后，可以看到外部构建脚本从 `Android.mk` 变为了 `CMakeLists.txt`。

```sh
# android native code build type
# none, native code will never be compiled.
# cmake, native code will be compiled by CMakeLists.txt
# ndk-build, native code will be compiled by Android.mk
PROP_BUILD_TYPE=ndk-build
```

如果需要在 Android Studio 中使用预编译库，需特别设置预编译库存放的目录，请参考关于预编译库的介绍，以及 `build.gradle` 中的注释。

## CMake 帮助

* CMake 官网: [cmake.org](https://cmake.org/)

* CMake 文档: [cmake.org/documentation](https://cmake.org/documentation/)

* CMake FAQ: [Wiki/CMake_FAQ](https://cmake.org/Wiki/CMake_FAQ)