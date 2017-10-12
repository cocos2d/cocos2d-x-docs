# cocos2d-x IOS平台的环境搭建

## 工具准备

1. cocos2d-x v3.16，下载后解压，下载参见：[cocos官网页面](http://www.cocos.com/download)
1. Xcode 8.3.3 下载后安装，下载参见：[Apple官网页面](https://developer.apple.com/download/more/)

## 配置步骤：

1. 打开 `cocos2d-x-3.16/build/cocos2d_tests.xcodeproj` 
1. 在 Xcode 顶部工具栏选择 `cpp-tests IOS`，`iPhone 7 Plus`，点击运行，项目将自动编译运行，效果如图：

    <a href="IOS-img/ios-install-run.png" target="_blank"><img src="IOS-img/ios-install-run.png" alt="macOS-setup-img"></a>


## 如何调试(Debug)

1. 点击代码行左侧的空白，设置断点
1. 运行 cpp-tests
3. 操作 App 触发断点，IDE 将卡在断点处，视图会自动变化，左侧导航栏可以查看运行堆栈，底部窗口可以查看变量的值

    <a href="IOS-img/macOS-debug.png" target="_blank"><img src="IOS-img/macOS-debug.png" alt="macOS-debug-img"></a>

## FAQ

