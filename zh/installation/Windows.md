# 搭建开发环境 - Windows 平台

## 工具准备

1. Visual Studio 2017，我们已在 `Visual Studio 2017` 上做了版本功能的完整验证，建议用户使用此IDE，以防止由于版本不同引发编译或运行错误。下载参见：[官网页面](https://www.visualstudio.com/zh-hans/downloads/)。
1. cocos2d-x v4，下载后解压，下载参见：[Cocos官网页面](//www.cocos.com/download)

## 编译并运行

__使用 cmake__
```bash
cd COCOS2DX/tests/cpp-tests
mkdir win32-build
cd win32-build
cmake ..
make
```

__使用 Visual Studio__

先用 use CMake 生成 Visual Studio 工程,
```bash
cd COCOS2DX/tests/cpp-tests
mkdir win32-build
cd win32-build
cmake .. -G"Visual Studio 15 2017" -Tv141
```
然后打开 `cpp-tests.vsproj` 选择 `cpp-tests` 作为启动项目并运行.

__Use cocos command line tools__
```bash
cd COCOS2DX/tests/cpp-tests
cocos run -p win32
```

## 如何调试(Debug)

1. 点击代码行左侧的空白，设置断点

    ![](./Windows-img/cpp-tests-win32-debug-breakpoint.png "")

1. 以 debug 模式运行 cpp-tests
1. 操作 App 触发断点，IDE 将卡在断点处，`Debug` 视图会自动跳出，可以查看运行堆栈和变量的值

    ![](./Windows-img/cpp-tests-win32-debug-trace.png "")

## FAQ

### 通过 CMake 使用模板工程需要了解的一点

通过 `cocos new` 新建 cpp，lua 工程，使用 CMake 生成 Visual Studio 的工程，cpp 的工程可以正常编译运行，但是 lua 的工程编译成功却运行失败？

lua 工程使用了 simulator 的库，导致在 Visual Studio 内运行时，不能正确找到工作目录。需要手动修改工程配置，将项目属性中调试内的工作目录改为 CMake 生成目录下的 `bin\TemplateLua\Debug`。

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