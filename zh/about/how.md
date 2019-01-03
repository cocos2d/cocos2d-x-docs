# 参与开发

## 参与文档开发

期待您也能和我们一起参与到文档的完善中，参与方法：

* Fork 文档仓库 [cocos2d-x-docs](https://github.com/cocos2d/cocos2d-x-docs)
* **en/** 目录对应英文文档, **zh/** 目录对应中文文档。
* 代码块要以一种特殊的方式包裹，例如 C++ 代码块:

  * 包裹方法：

    ![](res/codeblock.png)

  * 最终效果：

    ```cpp
    auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
    ```

* 使用 `gitbook serve` 命令测试改动在 GitBook 中的效果
* 提交 pull request 到 cocos2d/cocos2d-x-docs 仓库
* 我们会 review 这个 pull request 并 merge

## 参与引擎开发

使用 Cocos2d-x 的过程中，对于一般的问题，欢迎通过 [论坛](//forum.cocos.com/c/cocos2d-x) 向我们反馈。对于明确是 BUG 的，请参照下述方法反馈。

### 反馈 BUG

在 Cocos2d-x 的使用过程中，遇到 BUG 可以通过下面的方式在 GitHub 上向我们反馈。

1.  新建 Cocos2d-x 的 Issues，[传送门](https://github.com/cocos2d/cocos2d-x/issues/new)

1.  增加一些必要的信息，帮助开发者定位修复 BUG
    * BUG 出现的环境,
      * Cocos2d-x 的版本，如 3.16
      * 使用的 IDE，如 Xcode 8.3.3
      * 测试设备，如 iPhone 7
    * BUG 的重现步骤
    * 如果有和 BUG 相关的其它信息，也可以一并提交，如 资源链接

### 贡献代码

Cocos2d-x 在 GitHub 开源，你可以通过下面的方式贡献自己的代码，成为 Cocos2d-x 的贡献者。

* 从 GitHub 克隆最新的开发分支到本地

```bash
git clone git://github.com/cocos2d/cocos2d-x.git
cd cocos2d-x
git checkout v3
./download-deps.py
git submodule update --init
```

* 把代码改动添加到最新的开发分支
* 将改动提交到自己的代码仓库中
* 为本次代码提交创建一个新分支 如：`$ git checkout -b my_fix_branch`
* `push` 新分支到自己的 GitHub 公共仓库
* 创建一个 `Pull request` 给 `cocos2d/cocos2d-x`
* 改动一定要完善，并且符合发布规则，参考下面：

### 补丁要求

* C++ 代码遵循 [代码风格](https://github.com/cocos2d/cocos2d-x/blob/v3/docs/CODING_STYLE.md)
* Python 代码遵循 [代码风格](https://www.python.org/dev/peps/pep-0008/)
* 描述补丁的功能
* 包括测试用例（如果适用）
* 包括单元测试（如果适用）
* 必须在所有支持的平台上进行测试 [*]
* 不得降低性能
* 不得破坏现有测试用例
* 不得破坏持续集成的构建
* 不能破坏向后的兼容性
* 编译必须无错误,无告警
* 新的 API 必须易于使用
* 代码必须易于扩展和维护
* C ++ API 需要按照 Doxygen 注释规范注释
* 必须有一个描述如何使用该工具的 README.md 文件(补丁是工具)
* 必须高效（快/低内存需求）
* 不能重复现有的代码
* 重构关键组件的补丁只能在下一个主要版本中合并

[*]：如果您无法在所有支持的平台中测试代码，请告知我们。

## 宣传 Cocos2d-x

当您使用 Cocos2d-x 开发了游戏，希望您能将 Cocos2d-x 的 Logo 放到游戏中，或者把 Cocos2d-x 加到致谢中。让我们一起提高 Cocos2d-x 的知名度，让更多的人参与到 Cocos 开源社区的建设中。

[Cocos2d-x Logo 资源](https://cocos2d-x.org/images/logo.png)
