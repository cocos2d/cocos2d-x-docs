# 搭建开发环境 - iOS

## 工具准备

1. Cocos2d-x v3.17，下载后解压，下载参见：[Cocos官网页面](//www.cocos.com/download)
1. Xcode 9 下载后安装，下载参见：[Apple官网页面](https://developer.apple.com/download/more/)

## 配置步骤：

1. 打开 `cocos2d-x-3.17/build/cocos2d_tests.xcodeproj`
1. 在 Xcode 顶部工具栏选择 `cpp-tests iOS`，`iPhone 7 Plus`，点击运行，项目将自动编译运行，效果如图：

    ![](iOS-img/ios-install-run.png)

## 如何调试(Debug)

1. 点击代码行左侧的空白，设置断点
1. 运行 cpp-tests
1. 操作 App 触发断点，IDE 将卡在断点处，视图会自动变化，左侧导航栏可以查看运行堆栈，底部窗口可以查看变量的值：

    ![](iOS-img/macOS-debug.png)
