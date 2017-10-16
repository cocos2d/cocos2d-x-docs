## 支持 Cocos2d-x

### 上报 BUG

在 Cocos2d-x 的使用过程中, 遇到 BUG 可以通过下面的方式在 GitHub 上向我们报告.

1. 新建 Cocos2d-x 的 Issues, [传送门](https://github.com/cocos2d/cocos2d-x/issues/new)

1. 增加一些必要的信息, 帮助开发者定位修复 BUG
    - BUG 出现的环境, 
        - Cocos2d-x 的版本, 如 3.16
        - 使用的 IDE , 如 XCode 8.3.3
        - 测试设备, 如 iPhone 8
    - BUG 的重现步骤
    - 如果有和 BUG 相关的其它信息, 也可以一并提交, 如 资源链接

### 贡献代码

Cocos2d-x 在 GitHub 开源, 你可以通过下面的方式贡献自己的代码, 成为 Cocos2d-x 的贡献者.

- 学会使用 Git 和 GitHub
- 从 GitHub 下载最新的开发分支到本地

 ```
$ git clone git://github.com/cocos2d/cocos2d-x.git
$ cd cocos2d-x
$ git checkout v3
$ ./download-deps.py
$ git submodule update --init
```
- 把代码改动添加到最新的开发分支
- 将改动提交到自己的代码仓库中
- 为本次代码提交创建一个新分支 如:`$ git checkout -b my_fix_branch`
- `push` 新分支到自己的 GitHub 公共仓库
- 创建一个 `Pull request` 给 `cocos2d/cocos2d-x`
- 改动一定要是很完善的, 并且符合发布规则, 参考下面的介绍:

### 待合并的代码需要符合的要求