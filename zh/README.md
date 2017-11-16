# Cocos2d-x 中文文档

## 环境准备

进行文档开发，需要先准备 GitBook 环境：

1. [Node.js](https://nodejs.org/en/)
1. [npm](https://www.npmjs.com/) 一般会和 Node.js 一起安装
1. 安装 gitbook 命令行工具，运行命令 `npm install gitbook-cli -g`
1. 安装 gitbook，运行命令 `gitbook install`

## 开发工作流程

进行正式开发前最好能先熟悉一下 GitBook，流程如下：

- Fork 文档仓库 [cocos2d-x-docs](https://github.com/cocos2d/cocos2d-x-docs)
- clone 仓库到本地，进行改动
- 使用 `gitbook serve` 命令测试改动在 GitBook 中的效果
- 提交 pull request 到 cocos2d/cocos2d-x-docs 仓库
- 我们会 review 这个 PR，并将内容合并到主仓库

## 注意事项

- 改动中文文档，请将改动限制在 __zh/__ 目录
- 避免使用过大的图片，过大的图片会造成加载缓慢，甚至加载失败
- 文档书写规范请参考：[中文文档格式规范](https://github.com/anjuke/coding-style/blob/master/text/chinese.md)
- 代码块要以一种特殊的方式包裹，可以模仿已有代码块的包裹方式.
  - 例如 C++ 代码块:
      ```html
      {% codetabs name="C++", type="cpp" -%}
      auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
      {%- endcodetabs %}

文档的开发，Cocos2d-x 开源社区的建设，期待你的加入！