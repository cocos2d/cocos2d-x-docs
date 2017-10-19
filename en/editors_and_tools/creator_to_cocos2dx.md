<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Using Cocos Creator With C++ and Lua Projects
__Cocos Creator__ supports JavaScript, built in. Edit your `Scenes` and source code all from within. However, If you are a C++ or Lua developer, __Creator__ allows exporting of `Scenes` to sour code for further development. Why isn't C++ built in, you ask? There is no need to re-invent the wheel. There are many really good development environments out there. Writing a text editor is no trivial task. For this reason, it is best to allow developers to edit source code in the editor of their choice.

### What Is Supported?
__Cocos2d-x v3.14__ and __Cocos Creator v1.4__ and above are required. If you find some `Nodes` are not supported, upgrading __Cocos2d-x__ and __Cocos Creator__ may add support for them.

The following `Nodes` are supported.
Node | Node | Node | Node | Node
--- | --- | --- | --- | ---
Scene | Sprite | Canvas | ScrollView | Label
EditBox | ParticleSystem | TiledMap | Button | ProgressBar
RichText | SpineSkeleton | Widget | Animations | VideoPlayer
WebView | Slider | Toggle | ToggleGroup | PageView
Mask | Collider | Prefab | DragonBones

### Installing The Plugin
Adding C++ and Lua language support to __Cocos Creator__ is easy:

* clone the [Creator To Cocos2d-x repo](https://github.com/cocos2d/creator_to_cocos2dx).
* copy `creator_project/packages/creator_luacpp_support` into `Cocos Creator project/packages`.

In the __Project__ menu inside __Creator__ a new menu option will appear
__LuaCPP Support__.

![](creator_to_cocos2dx-img/project_menu.png "project menu")

### Plugin Setup
To run the plugin:

* select __LuaCPP Support__ -> __Setup Target Project__.

  ![](creator_to_cocos2dx-img/dialog_options.png "dialog options")

  It is required to tell __Cocos Creator__ where to build all the necessary files.

* select __Build__. 

![](creator_to_cocos2dx-img/dialog_options.png "dialog options")



### Exporting A Scene To Source Code


###
