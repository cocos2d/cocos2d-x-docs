# CMake 指南

CMake 是一个开源的跨平台构建工具，Cocos2d-x 是一个开源的跨平台游戏引擎，两者十分契合。

Cocos2d-x 决定自 3.17 版本开始，支持 CMake 的全平台构建。支持的平台包括 Android (NDK)、iOS、macOS、Linux、Windows（VC++ compiler），同时支持通过 CMake 将引擎部分进行预编译，并在新的构建过程中重用预编译的引擎库。

## 基本概念

在使用 CMake 构建工程之前，最好能对软件构建中一些基本的概念有初步的了解，比如什么是编译，链接，打包。了解这些对后续使用 CMake 有很大的帮助。

此处只解释一下：外部构建（Out-of-source Build），在从源码生成最终的二进制可执行文件的过程中，会生成大量的中间文件，中间文件和源码在同一个目录内时会使源码目录混乱不堪，使用外部构建，即将所有生成的中间文件都放在一个非源码目录中，这样无论构建多少次，源码目录始终干净如新。

## 常用构建选项

### CMake 通用

1. __-G__，通过 CMake 生成特定 IDE 的项目配置文件。这个操作依赖 IDE，即无法在一个没安装 Xcode 的 macOS 上通过 CMake 生成对应的工程文件。

    * `-GXcode` 生成 Xcode 工程文件
    * `-GVisual Studio 15 2017` 生成 Visual Studio 2017 工程文件

1. __CMAKE_BUILD_TYPE__, 指定构建模式，比如 Debug 还是 Release，默认值 Debug。

    * `-DCMAKE_BUILD_TYPE=Release` 指定以 Release 模式生成工程。

1. __-H -B__，`-H` 用来指定一个源码目录，指定的目录必须含有一个 CMakeLists.txt 文件，`-B` 用来指定 CMake 生成的中间文件的存放目录。

    * `-H..\cocos2d-x  -Bmsvc_build` 指定要构建工程的工程路径是上一级目录的 cocos2d-x 子目录，指定 CMake 生成的文件存放在 msvc_build 目录。

1. __--build <dir>__ 执行构建过程，同时指定曾使用 CMake 命令生成的构建文件所在目录。

    * `cmake --build ./msvc_build` 在执行这个构建过程时，CMake 会自动选择对应的构建工具。

<!--### Cocos2d-x 特有

以下 Cocos2d-x 特有的选项和使用预编译库有关。

1. __GEN_COCOS_PREBUILT__ 控制构建过程是否生成预编译库，默认行为是不生成，开启选项将会增加一个构建目标：prebuilt，执行这个构建目标时，将会编译引擎部分的代码，并将生成的库文件，拷贝至存放预编译库的目录，默认将库拷贝至引擎目录的 prebuilt 子目录。

    * `-DGEN_COCOS_PREBUILT=ON` 将会增加一个构建目录：prebuilt，用于执行库的生成，拷贝。

1. __USE_COCOS_PREBUILT__ 控制生成的构建工程是否使用预编译库，默认行为是不使用，开启选项将会自动查找使用预编译库，关闭库相关的构建目标，默认在引擎目录的 prebuilt 子目录查找预编译库。

    * `-DUSE_COCOS_PREBUILT=ON` 将会自动使用预编译库，关于库相关的 target。

1. __COCOS_PREBUILT_ROOT__ 指定预编译库存放的目录，是一个可选选项，对于在 Android 平台中使用预编译库是一个必选选项，因为正常情况下，Android Studio 在进行 CMake 构建过程时，无法获取到环境变量，导致找不到引擎根目录。

    * `-DCOCOS_PREBUILT_ROOT=/Users/laptop/cocos-prebuilt` 设置存放预编译库的目录
-->
## 各平台构建示例

### Linux

```sh
cd cocos2d-x
mkdir linux-build && cd linux-build
cmake ..
cmake --build .
``` 
在执行 `make -j 4` 命令之前，可以执行 `make help` 查看所有的构建目标，使用 `make <target>` 构建一个特定的目标。

### macOS

```sh
cd cocos2d-x
mkdir mac-build && cd mac-build
cmake .. -GXcode
open Cocos2d-x.xcodeproj
```
在 macOS 上使用 `cmake .. -GXcode` 将会默认生成 macOS 的工程。iOS 工程和 macOS 工程并不能同时生成到一个 XCode 工程中。

### iOS

```sh
cd cocos2d-x
mkdir ios-build && cd ios-build
cmake .. -GXcode -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake
open Cocos2d-x.xcodeproj
```

默认构建的是为运行在 iOS 设备的工程，如果想构建运行在模拟器的工程，请加参数 `-DIOS_PLATFORM=SIMULATOR` 或 `-DIOS_PLATFORM=SIMULATOR64`。

### Android

默认工程配置在 Android 上使用旧有的 ndk-build 构建 C++ 部分，开启 CMake 构建，请先更改 Gradle 配置中的 `PROP_NDK_MODE` 属性为 cmake，再同步 Gradle 配置，同步完成后，可以看到外部构建脚本从 Android.mk 变为了 CMakeLists.txt。

```sh
# android native code build type
# none, native code will never be compiled.
# cmake, native code will be compiled by CMakeLists.txt
# ndk-build, native code will be compiled by Android.mk
PROP_BUILD_TYPE=ndk-build
```

如果需要在 Android Studio 中使用预编译库，需特别设置预编译库存放的目录，请参考关于预编译库的介绍，以及 `build.gradle` 中的注释。

### Windows

```sh
cd cocos2d-x
mkdir win32-build && cd win32-build
cmake .. -G"Visual Studio 15 2017"
cmake --build . 
```
以上命令使用 CMake 生成 Cocos2d-x 测试项目的 Visual Studio 2017 工程。生成后，在文件浏览器中找到 cocos2d-x/win32-build 目录，双击打开 __Cocos2d-x.sln__。设置 cpp-tests 为启动项目，即可正常编译运行。

另一种方式，由于 Visual Studio 2017 已经直接支持 CMake 工程，可以直接使用。详细请参考 [CMake 支持](https://docs.microsoft.com/zh-cn/cpp/ide/cmake-tools-for-visual-cpp)。

<!--## 预编译库示例

使用引擎的预编译库，可以避免再次编译引擎代码，将引擎部分的代码编译时间缩减为零！从而有效的降低项目的构建时间。以下示例为使用一个 C++ 工程生成预编译库，并在其它 C++ 工程中使用。

1. 开启 `GEN_COCOS_PREBUILT` 选项，生成预编译库

    ```sh
    cocos new -l cpp -p my.pack.app1 test_app1
    mkdir app1_build && cd app1_build
    cmake ../test_app1 -DGEN_COCOS_PREBUILT=ON
    make prebuilt
    ```

1. 关闭 `GEN_COCOS_PREBUILT` 选项，开启 `USE_COCOS_PREBUILT` 选项，在本项目中使用预编译库

    ```sh
    cmake ../test_app1 -DGEN_COCOS_PREBUILT=OFF -DUSE_COCOS_PREBUILT=ON
    make TemplateCpp
    open bin/TemplateCpp.app
    ```

1. 直接开启 `USE_COCOS_PREBUILT` 选项，在一个新的项目中使用生成的预编译库

    ```sh
    cocos new -l cpp -p my.pack.app2 test_app2
    mkdir app2_build && cd app2_build
    cmake ../test_app2 -DUSE_COCOS_PREBUILT=ON
    make TemplateCpp
    open bin/TemplateCpp.app
    ```
-->
## 常见问题



### 如何添加 `C++` 源码?

一般我们会把游戏相关的源码要放在 `Classes/` 目录下. 如果只做这一步是, 我们可能会遇到类似的编译错误.

```
__/**.cpp:__: undefined reference to `******'
```

我们还需要在 `CMakeLists.txt` 中添加我们的源码路径

```diff
@@ -52,10 +52,12 @@ endif()
 list(APPEND GAME_SOURCE
      Classes/AppDelegate.cpp
      Classes/HelloWorldScene.cpp
+     Classes/**/*.cpp
      )
 list(APPEND GAME_HEADER
      Classes/AppDelegate.h
      Classes/HelloWorldScene.h
+     Classes/**/*.h
      )
 
```

然后重新更新 *本地工程文件* 

```bash
~/Projects/MyCppGame/build$ cmake ..
```

### 如何添加 资源(图片,`shader`,字体等) 文件到项目?


在不同的平台上, IDE 管理资源的方式会有差异. 好在 CMake 已经帮我们做了大部分工作. 我们需要做的就是把准备好的资源放到 `Resources/` 目录下.

但是, 在 Mac, Windows 和 Linux 上您可能还是会经常遇到类似于
```log
Error while loading: 'HelloWorld2.png'
```
的报错. 

我们已经更新了资源, 报错还是出现了, 这很让人困惑. 

如在工程目录中执行下面命令

```bash
~/Projects/MyCppGame$ find . -name Resources
```
会发现 有两个 `Resources/` 目录
```
./Resources
./build/bin/MyCppGame/Resources
```

其中 第二个 目录是前者的一个副本, 如果变更不一致的情形就会存在同步问题. 新增资源找不到也是一种同步问题.

在 iOS,Android 平台, 生成的*目标对象*是一个程序包. 除了可执行文件,还包括了所需要的资源文件. 资源文件会和可执行程序一起发布, 所以不再依赖原本的资源文件(`Resources/`目录中的内容). 但是 在Windows和Linux上, 生成的*目标对象* 只有一个*可执行文件*, 并不包含资源文件. 比如在Windows上就只有一个`MyCppGame.exe`文件. 为了让*可执行文件*能够找到资源, 我们需要把整个 `Resources/` 拷贝到 和它同一个目录中.

当前我们并没有提供给开发者 拷贝资源文件的 接口, 而是通过
`CMake` 把这个过程作为一个钩子交给了 本地构建工具. 

Cocos2d-x 提供了类似与下面代码片段的过程

```cmake
add_custom_command(TARGET MyCppGame POST_BUILD
                COMMAND cmake -E copy_directory ./Resources ./build/bin/MyCppGame/Resources
            )
```
这里的重点在 `POST_BUILD`. 只有触发了`Build` 才会执行 `POST_BUILD`. 如果源文件发生了变化, 在编译完成后就会触发 拷贝资源的动作. 这里有一个问题, 如果资源文件发生了变化,但是源码没有变化, 拷贝动作会被触发吗? 答案是:不会. 这就是运行时找不到新增资源的原因. 

了解了导致错误的原因, 解决这个问题就不会很难. 一个简单的解决办法就是修改 `Classes/` 中的任意源码(比如添加空行,然后删除,保存), 从而触发 `Build` 和 `POST_BUILD`. 或者通过其他命名手动同步两个文件夹. 

在 Mac 平台也会有相似的问题, 导致问题的原因差异不大.  Mac 项目不需要额外的拷贝, 只需要把 `Resources/` 中的文件标记为 "资源文件". 但这一步是在生成 `cmake ../ -GXcode` 时执行的. 后续 资源文件的更新不会同步到 `Xcode` 工程文件. 解决这个问题的方法也很简单, 重新执行 `cmake` 更新 `Xcode` 工程文件. 

```bash
~/Projects/MyCppGame/build$ cmake ..
```

#### 添加字体资源

添加字体资源和添加图片资源的操作是类似的. 和处理图片的过程相似, 就是把 字体 添加到 `Resources/fonts` 目录. 

**如果要在 iOS 上添加字体, 则需要一个额外的步骤.**

在 `proj.ios_mac/ios/Info.plist` 中添加 `UIAppFonts`.
```diff
@@ -29,7 +29,9 @@
     <key>LSRequiresIPhoneOS</key>
     <true/>
     <key>UIAppFonts</key>
-    <array/>
+    <array>
+           <string>fonts/Scissor Cuts.ttf</string>
+    </array>
     <key>UILaunchStoryboardName</key>
```
更新工程文件
```bash
~/Projects/MyCppGame/build$ cmake ..
```

### 如何添加 `Lua` 源码?

可以参考 图片资源的更新方法.

### 如何使用第三方代码库?

有的时候我们需要复用已有的代码库 或者更新 第三方代码库. 我们可以使用 CMake 提供的指令 [`add_subdirectory`](https://cmake.org/cmake/help/v3.0/command/add_subdirectory.html) 导入其他的 CMake 工程. 

> 如果这个代码库不包含可用的`CMakeLists.txt`, 我们需要先把这个工程改造为一个 CMake 工程. 

以`nanomsg`为例, 在下载好源码之后, 执行

```bash
mkdir deps
cp -r ~/Downloads/nanomsg-1.1.5 deps/
```

在 CMakeLists.txt 中添加下面的内容

```diff
@@ -129,6 +131,16 @@ target_include_directories(${APP_NAME}
         PRIVATE ${COCOS2DX_ROOT_PATH}/cocos/audio/include/
 )
 
+set(NN_STATIC_LIB ON)
+set(NN_ENABLE_DOC OFF)
+set(NN_TESTS OFF)
+set(NN_TOOLS OFF)

+add_subdirectory(deps/nanomsg-1.1.5)

+target_link_libraries(${APP_NAME} nanomsg)
+
+target_include_directories(${APP_NAME} PRIVATE deps/nanomsg-1.1.5/src)
+
+
 # mark app resources
 setup_cocos_app_config(${APP_NAME})

```
这里的前4行的`set`的作用是设置`nanomsg`的编译选项.

> 更详细的介绍可以参考 [`target_include_directories`](https://cmake.org/cmake/help/v3.0/command/target_include_directories.html) 和 [`target_link_libraries`](https://cmake.org/cmake/help/v3.0/command/target_link_libraries.html).

之后我们就可以在代码中使用这个库了 

```diff
@@ -24,6 +24,10 @@
#include "HelloWorldScene.h"
+#include "nn.h"
```

### 如何编辑 iOS 工程的 `Info.plist`?

和修改字体的过程一样, 我们需要修改 `proj.ios_mac/ios/Info.plist`. 需要注意的是, 这个文件并没有被 XCode 所直接使用, 它是项目中 `CMakeFiles/MyCppTest.dir/Info.plist` 的模板文件. 我们需要更新目标来更新`Info.plist`,

在修改模板后, 需要执行 `cmake ..` 使之生效. 

### 添加宏和include路径 

如果有遇到头文件找不到的情况, 可以参考
[target_include_directories](https://cmake.org/cmake/help/v3.0/command/target_include_directories.html).

通过 [target_compile_definitions](https://cmake.org/cmake/help/v3.0/command/target_compile_definitions.html) 可以添加宏. 

## CMake 帮助

* CMake 官网: [cmake.org](https://cmake.org/)

* CMake 文档: [cmake.org/documentation](https://cmake.org/documentation/)

* CMake FAQ: [Wiki/CMake_FAQ](https://cmake.org/Wiki/CMake_FAQ)
