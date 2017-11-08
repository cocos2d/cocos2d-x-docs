# Cocos2d-x 文档

## 新手入门

- [了解引擎](about/index.md)
    - [关于](about/index.md)
    - [引擎优势](about/why.md)
    - [学习资源](about/learn.md)
    - [获取帮助](about/help.md)
    - [参与开发](about/how.md)

- [基本概念](basic_concepts/index.md)
    - [简介](basic_concepts/index.md)
    - [导演(Director)](basic_concepts/director.md)
    - [场景(Scene)](basic_concepts/scene.md)
    - [精灵(Sprite)](basic_concepts/sprites.md)
    - [动作(Action)](basic_concepts/actions.md)
    - [序列(Sequence)](basic_concepts/sequences.md)
    - [节点关系](basic_concepts/parent_child.md)
    - [日志输出](basic_concepts/logging.md)

## 引擎组件

- [精灵(Sprite)](sprites/index.md)
    - [简介](sprites/index.md)
    - [精灵创建](sprites/creating.md)
        - [使用图集](sprites/spritesheets.md)
        - [使用精灵缓存](sprites/spriteframe_cache.md)
    - [精灵控制](sprites/manipulation.md)
    - [多边形精灵](sprites/polygon.md)

- [动作(Action)](actions/index.md)
    - [简介](actions/index.md)
    - [基本动作](actions/basic.md)
    - [动作序列](actions/sequences.md)
    - [克隆与倒转](actions/sequence_internals.md)

- [场景(Scene)](scenes/index.md)
    - [简介](scenes/index.md)
    - [场景创建](scenes/creating.md)
    - [场景切换](scenes/transitioning.md)

- [UI 组件](ui_components/index.md)
    - [简介](ui_components/index.md)
    - [标签(Label)](ui_components/labels.md)
    - [菜单(Menu)](ui_components/menus.md)
    - [按钮(Button)](ui_components/buttons.md)
    - [选框(CheckBox)](ui_components/checkboxes.md)
    - [进度条(LoadingBar)](ui_components/loading_bar.md)
    - [滑动条(Slider)](ui_components/sliders.md)
    - [文本框(TextField)](ui_components/textfields.md)

- [高级节点对象](other_node_types/index.md)
    - [简介](other_node_types/index.md)
    - [瓦片地图](other_node_types/tilemap.md)
    - [粒子系统](other_node_types/particles.md)
    - [视差滚动](other_node_types/parallax.md)

## 引擎功能

- [事件分发机制](event_dispatcher/index.md)
    - [简介](event_dispatcher/index.md)
    - [监听器](event_dispatcher/types.md)
    - [优先级](event_dispatcher/priority.md)
    - [触摸事件](event_dispatcher/touch.md)
    - [键盘事件](event_dispatcher/keyboard.md)
    - [加速度传感器事件](event_dispatcher/accelerometer.md)
    - [鼠标事件](event_dispatcher/mouse.md)
    - [自定义事件](event_dispatcher/custom.md)
    - [进阶话题](event_dispatcher/registering.md)

- [3D 支持](3d/index.md)
    - [术语](3d/index.md)
    - [3D 精灵](3d/sprite3d.md)
    - [3D 动画](3d/animation.md)
    - [相机(Camera)](3d/camera.md)
    - [立方体纹理(TextureCube)](3d/cubemap.md)
    - [天空盒(Skybox)](3d/skybox.md)
    - [光照(Light)](3d/lighting.md)
    - [地形(Terrain)](3d/terrain.md)
    - [常用工具](3d/tools.md)
    - [进阶话题](3d/advanced.md)

- [使用脚本](scripting/index.md)
    - [脚本组件](scripting/index.md)

- [物理引擎](physics/index.md)
    - [简介](physics/index.md)
    - [概念](physics/concepts.md)
    - [碰撞](physics/collisions.md)
    - [查询](physics/queries.md)
    - [调试](physics/debugging.md)

- [声音和音效 TODO](audio/index.md)
    - [简介](audio/index.md)
    - [背景音乐](audio/playing.md)
    - [声音控制](audio/operations.md)
    - [高级功能](audio/advanced.md)
    - [功能提升](audio/engines.md)

- [高级话题 TODO](advanced_topics/index.md)
    - [文件接入](advanced_topics/index.md)
    - [网络操作](advanced_topics/networking.md)
    - [材质与纹理](advanced_topics/shaders.md)
    - [图形性能优化](advanced_topics/optimizing.md)
    - [SQLite 集成](advanced_topics/sqlite.md)

## 开发环境

- [环境搭建](installation/index.md)
    - [安装要求](installation/index.md)
    - [Android 平台](./installation/Android-Studio.md)
    - [iOS](installation/iOS.md)
    - [macOS](installation/OSX.md)
    - [Linux 平台](installation/Linux.md)
    - [Windows 平台](installation/Windows.md)

- [工具 TODO](editors_and_tools/cocosCLTool.md)
    - [Cocos命令行工具](editors_and_tools/cocosCLTool.md)
    - [Cocos图形界面工具](editors_and_tools/cocos.md)
    - [插件 Creator to Cocos2d-x](editors_and_tools/creator_to_cocos2dx.md)
    - [预编译库](editors_and_tools/prebuilt_libraries.md)