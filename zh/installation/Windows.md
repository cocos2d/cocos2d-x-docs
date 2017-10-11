# cocos2d-x 在 Visual Studio 的环境搭建

## 工具准备

1. Visual Studio，下载参见：[官网页面](https://www.visualstudio.com/zh-hans/downloads/)，[Visual Studio 2015 发布页面](https://www.visualstudio.com/zh-cn/news/releasenotes/vs2015-update3-vs)。此次环境搭建使用的是**Visual Studio 2015**。
1. python2.7，安装并配置环境变量，在cmd打开命令行界面，使用 `python --version` 可以获取到python的版本号，表示python安装成功。下载参见：[python官网页面](https://www.python.org/downloads/release/python-2714/)
1. cocos2d-x v3.16，下载后解压，下载参见：[cocos官网页面](http://www.cocos.com/download)

## 配置步骤

1. 运行 `cocos2d-x-3.16/setup.py`，脚本会自动做一些环境变量的设置，脚本执行过程中遇到的几个需要手动输入的变量，`win32` 的程序不需要，可以选择直接回车跳过。
1. 双击 `cocos2d-x-3.16\build\cocos2d-win32.sln`， Visual Studio 将打开此解决方案，解决方案打开后，可以看到这样的项目列表：

    ![](Windows-img/cpp-tests-win32-solution.png "")

1. 默认情况下项目列表中 `cpp-tests` 加粗显示，表示是启动项目，此时点击菜单栏中`本地 Windows 调试器`进行项目的编译和运行。编译过程视机器性能不同，会花费10-30分钟的时间，编译完成后，将自动运行，运行成功将看到测试程序：

    ![](Windows-img/cpp-tests-win32-run.png "")

## 如何调试(Debug)

## FAQ