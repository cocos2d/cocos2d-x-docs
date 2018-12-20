# Cocos2d-x 用户手册

v2018.5.21

欢迎使用 Cocos2d-x 用户手册，本手册包含引擎的介绍，功能组件的使用方法以及引擎在多个平台的环境搭建。能够帮助您快速上手 Cocos2d-x！

## 特别推荐

- Cocos2d-x 3.17 已发布，请参阅 [版本发布说明](//www.cocos.com/1462)。
- 3.17 支持全平台的 CMake 构建，请参阅 [CMake 指南](installation/CMake-Guide.md)

## 快速上手

手册通过四个部分向您介绍 Cocos2d-x：新手入门部分，可以了解到 Cocos2d-x 引擎是什么、如何学习引擎、如何参与引擎开发，以及引擎中一些基本的概念；基本功能部分，着重介绍引擎中一些基础同时核心的组件如何使用，包括精灵、动作、场景。

进阶内容部分，是对引擎更近一步的阐述，包含如何进行一些高级控制、显示一些特殊效果；环境与工具部分，包含详细的开发环境搭建教程，以及一些引擎可利用的工具，比如使用 `cocos` 命令行。以下是手册的章节索引，可以帮助您快速定位。

- 新手入门：[了解引擎](about/index.md) / [基本概念](basic_concepts/index.md)
- 基本功能：[精灵](sprites/index.md) / [动作](actions/index.md) / [场景](scenes/index.md)
 / [UI 组件](ui_components/index.md)
- 进阶内容：[特殊节点对象](other_node_types/index.md) / [事件分发机制](event_dispatcher/index.md) / [3D 支持](3d/index.md) / [使用脚本](scripting/index.md) / [物理引擎](physics/index.md) / [音乐和音效](audio/index.md) / [高级话题](advanced_topics/index.md)
- 环境与工具：[环境搭建](installation/index.md) / [引擎工具](editors_and_tools/cocosCLTool.md)

在手册的使用过程中，您大可不必按照目录的顺序，一章一章的阅读，完全可以跳跃，比如阅读完新手入门部分后，直接进入环境搭建章节，按照教程在自己 PC 上搭建好开发环境，完成后，一边看源码一边看手册，或许这样能有更好的学习效果。您也可以把本文档当做一个查询手册，将你想查询的直接输入到左上角的全局搜索框，回车一下，结果将立刻显现在页面中。

---

## 致谢

感谢 Cocos2d-x 的所有开发者，是你们让这个文档有了存在的意义！

本文档主要翻译自英文文档，同时参考了旧有的 Cocos2d-x 中文文档。由于引擎内容较多，逻辑较复杂，文档可能会存在一些不完善之处。在您阅读的过程中，如果发现了错误的地方，欢迎通过 [中文社区](//forum.cocos.com/c/cocos2d-x)，或右下角 __Have Feedback__ 向我们反馈。

> 本文档示例代码在 [GitHub](https://github.com/chukong/programmers-guide-samples) 下载
