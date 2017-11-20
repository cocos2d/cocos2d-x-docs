# creator_to_cocos2dx 插件

Cocos Creator 可以很高效的编辑场景和 UI，同时内置支持 JavaScript，这对 JavaScript 开发者十分友好。可是对于 C++/Lua 开发者，无法直接利用 Creator 高效的界面编辑功能，可能是有一些遗憾。

为了去除这种遗憾，我们提供了 __creator_to_cocos2dx__ 插件，它允许开发者导出 Creator 编辑的场景到 Cocos2d-x 的 C++/Lua 工程中。插件逻辑上分为两部分，第一部分是 Creator 的插件，负责把 Creator 制作的场景导出为 _.ccreator_ 文件；第二部分是负责解析 _.ccreator_ 文件的 reader，负责在 C++/Lua 工程中解析导出的场景文件。

## 特性

使用插件要求 Cocos2d-x 版本 v3.14+，Creator 版本 v1.4+。

Creator 使用基于组件的模型创建对象，而 Cocos2d-x 对每个对象有自己的结构，因此插件只能支持部分 Creator 特性。下面是目前支持的一些 `Node` 类型：

Node | Node | Node | Node | Node
--- | --- | --- | --- | ---
Scene | Sprite | Canvas | ScrollView | Label
EditBox | ParticleSystem | TiledMap | Button | ProgressBar
RichText | SpineSkeleton | Widget | Animations | VideoPlayer
WebView | Slider | Toggle | ToggleGroup | PageView
Mask | Collider | Prefab | DragonBones

如果在使用过程中，发现某些 `Node` 不支持，升级 Cocos2d-x 和 Creator 可能是一个解决办法。

## 安装配置

在 Cocos Creator 中添加 creator_to_cocos2dx 插件：

* 克隆 GitHub 仓库 [Creator To Cocos2d-x](https://github.com/cocos2d/creator_to_cocos2dx).
* 将插件仓库目录 _creator_project/packages/creator_luacpp_support_ 拷贝到 Creator 项目的 _packages_ 目录

    ![](../../en/editors_and_tools/creator_to_cocos2dx-img/folder_structure.png "directory structure")

* 使用 Creator 打开刚才添加插件的项目，在菜单栏的项目(Project)下，即可看到 `LuaCpp Support` 菜单项。

    ![](../../en/editors_and_tools/creator_to_cocos2dx-img/project_menu.png "project menu")

## Creator 场景导出

使用插件进行场景导出：

* 在菜单栏中点击 __项目(Project)__ -> __LuaCPP Support__ -> __Setup Target Project__，出现的对话框中 __Project Path__ 选择目标 Cocos2d-x 工程的路径。

    ![](../../en/editors_and_tools/creator_to_cocos2dx-img/dialog_options.png "dialog options")

* 点击 __Build__，构建过程将很快完成

* 在你编译运行 Cocos2d-x 项目前，记得重新 Build。完成 Build 后，导出的 reader 源码和 Creator 资源将位于如下位置：

  * C++ 项目：
    源码： __NATIVE_PROJECT_ROOT/Classes/reader__
    资源： __NATIVE_PROJECT_ROOT/Resources/creator__

  * LUA 项目：
    源码：__NATIVE_PROJECT_ROOT/frameworks/runtime-src/Classes/reader__
    资源：__NATIVE_PROJECT_ROOT/frameworks/runtime-src/Resources/Creator__

  _NATIVE_PROJECT_ROOT 是 Build 时，选择的 Project Path_

## 场景导入 Cocos2d-x 项目

After using the __Build__ function the source code and resources are exported to the filesystem. From here, you can use these items in an external build system.

### 增加头文件搜索路径

It is still necessary to set some __header__ and __include__ __search paths__.

  For C++:
    ```sh
    reader
    ```
  For Lua:
    ```sh
    reader
    reader/collider
    reader/animation
    reader/dragonbones/cocos2dx
    reader/dragonbones/armature
    reader/dragonbones/animation
    reader/dragonbones/events
    reader/dragonbones/factories
    reader/dragonbones/core
    reader/dragonbones/geom
    ```

#### Android 项目的特殊处理

When developing for Android the __Android.mk__ needs to be modified. There are a few simple lines to add,

  For C++:
    ```sh
    LOCAL_STATIC_LIBRARIES += creator_reader

    # _COCOS_LIB_ANDROID_BEGIN
    # _COCOS_LIB_ANDROID_END

    $(call import-module, ./../../Classes/reader)  # import module path
    ```

  For Lua:
    ```sh
    # for lua
    include $(CLEAR_VARS)
    LOCAL_MODULE := creator_reader_lua
    LOCAL_MODULE_FILENAME := libcreatorreaderlua
    LOCAL_ARM_MODE := arm
    LOCAL_SRC_FILES := $(cpp_src) \
    lua-bindings/creator_reader_bindings.cpp \
    lua-bindings/reader/lua_creator_reader_auto.cpp \
    lua-bindings/reader/lua_creator_reader_manual.cpp \
    lua-bindings/dragonbones/lua_dragonbones_manual.cpp \
    lua-bindings/dragonbones/lua_dragonbones_auto.cpp

    LOCAL_STATIC_LIBRARIES += creator_reader_lua

    # _COCOS_LIB_ANDROID_BEGIN
    # _COCOS_LIB_ANDROID_END

    $(call import-module, ./../../Classes/reader)
    ```

## 导入场景的使用

Once everything is done, you can add code to tie everything together. It's elegant and simple:

For C++ projects, just 1 step:
```cpp
// mygame.cpp
#include "reader/CreatorReader.h"

void some_function()
{
    creator::CreatorReader* reader = creator::CreatorReader::createWithFilename("creator/CreatorSprites.ccreator");

    // will create the needed spritesheets + design resolution
    reader->setup();

    // get the scene graph
    Scene* scene = reader->getSceneGraph();

    // ...and use it
    Director::getInstance()->replaceScene(scene);
}
```

For Lua projects, require 2 steps:

  * register the creator reader bindings
    ```cpp
    #include "reader/lua-bindings/creator_reader_bindings.hpp"

    ...

    register_creator_reader_manual(L);
    ```

  * add code to access the exported files.
    ```lua
    local creatorReader = cc.CreatorReader:createWithFilename('creator/CreatorSprites.ccreator')
    creatorReader:setup()
    local scene = creatorReader:getSceneGraph()
    cc.Director:getInstance():replaceScene(scene)
    ```

### 监控碰撞

`ColliderManager` is used to manage collisions. Every `Scene` has an instance of `ColliderManager`. You can use it to listen for collision events:

```c++
creator::CreatorReader* reader = creator::CreatorReader::createWithFilename("creator/CreatorSprites.ccreator");

// will create the needed spritesheets + design resolution
reader->setup();

// get the scene graph
Scene* scene = reader->getSceneGraph();

auto colliderManager = scene->getColliderManager();

colliderManager->registerCollitionCallback([=](creator::Contract::CollisionType type, creator::Collider* collider1, creator::Collider* collider2) {
        if (type == creator::Contract::CollisionType::ENTER)
            colliderManager->enableDebugDraw(true);

        if (type == creator::Contract::CollisionType::EXIT)
            colliderManager->enableDebugDraw(false);

}, "");
```
To read about additional features of `ColliderManager`, refer to [the header file](https://github.com/cocos2d/creator_to_cocos2dx/tree/master/creator_project/packages/creator-luacpp-support/reader/collider/ColliderManager.h).