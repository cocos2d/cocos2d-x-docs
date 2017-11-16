# 使用脚本

## 脚本组件

脚本组件是用来扩展 C++ 节点对象的一种方式，你可以将脚本组件绑定到节点对象上，然后脚本组件就能收到 `onEnter`，`onExit` 和 `update` 事件。

脚本组件支持两种脚本语言 JavaScript 和 Lua，使用的脚本组件应该和绑定脚本的语言类型对应，比如 `ComponentJS` 用来绑定 JavaScript 脚本，`ComponentLua` 用来绑定 Lua 脚本。有了脚本组件，你就可以在 Cocos2d-x 的项目中，很方便的使用脚本进行一些控制。需要注意的是，在一个项目中不能混用脚本组件，也就是说一个项目要么只使用 JavaScript 脚本，要么只使用 Lua 脚本。

使用 Lua 脚本：

{% codetabs name="C++", type="cpp" -%}
// create a Sprite and add a LUA component
auto player = Sprite::create("player.png");

auto luaComponent = ComponentLua::create("player.lua");
player->addComponent(luaComponent);
{%- endcodetabs %}

{% codetabs name="Lua", type="lua" -%}
-- player.lua

local player = {
    onEnter = function(self)
        -- do some things in onEnter
    end,

    onExit = function(self)
        -- do some things in onExit
    end,

    update = function(self)
        -- do some things every frame
    end
}

-- it is needed to return player to let c++ nodes know it
return player
{%- endcodetabs %}

使用 JavaScript 脚本:

{% codetabs name="C++", type="cpp" -%}
// create a Sprite and add a LUA component
auto player = Sprite::create("player.png");

auto jsComponent = ComponentJS::create("player.js");
player->addComponent(jsComponent);
{%- endcodetabs %}

{% codetabs name="JavaScript", type="js" -%}
// player.js
Player = cc.ComponentJS.extend({
    generateProjectile: function (x, y) {
        var projectile = new cc.Sprite("components/Projectile.png", cc.rect(0, 0, 20, 20));
        var scriptComponent = new cc.ComponentJS("src/ComponentTest/projectile.js");
        projectile.addComponent(scriptComponent);
        this.getOwner().getParent().addChild(projectile);

        // set position
        var winSize = cc.director.getVisibleSize();
        var visibleOrigin = cc.director.getVisibleOrigin();
        projectile.setPosition(cc.p(visibleOrigin.x + 20, visibleOrigin.y + winSize.height/2));

        // run action
        var posX = projectile.getPositionX();
        var posY = projectile.getPositionY();
        var offX = x - posX;
        var offY = y - posY;

        if (offX <= 0) {
            return;
        }

        var contentSize = projectile.getContentSize();
        var realX = visibleOrigin.x + winSize.width + contentSize.width/2;
        var ratio = offY / offX;
        var realY = (realX * ratio) + posY;
        var realDest = cc.p(realX, realY);

        var offRealX = realX - posX;
        var offRealY = realY - posY;
        var length = Math.sqrt((offRealX * offRealX) + (offRealY * offRealY));
        var velocity = 960;
        var realMoveDuration = length / velocity;

        projectile.runAction(cc.moveTo(realMoveDuration, realDest));
    },

    onEnter: function() {
        var owner = this.getOwner();
        owner.playerComponent = this;
        cc.eventManager.addListener({
            event: cc.EventListener.TOUCH_ALL_AT_ONCE,
            onTouchesEnded: function (touches, event) {
                var target = event.getCurrentTarget();
                if (target.playerComponent) {
                    var location = touches[0].getLocation();
                    target.playerComponent.generateProjectile(location.x, location.y);
                    jsb.AudioEngine.play2d("pew-pew-lei.wav");
                }
            }
        }, owner);
    }
});
{%- endcodetabs %}

注意，两种组件的使用上，有一个重要的区别。使用 Lua 组件，Lua 脚本最后需要返回 Lua 对象，使用 JavaScript 组件，JavaScript 脚本需要扩展 `cc.ComponentJS`。

更详细用法，请参考 Cocos2d-x 引擎的测试项目：`tests/lua-tests/src/ComponentTest` and `tests/js-tests/src/ComponentTest`。


<!--# Chapter 10: Lua

This chapter and its content are currently undecided. If you wish to contribute,
please provide a [Pull Request](https://github.com/chukong/programmers-guide)

## Call custom c++ from Lua
Cocos2d-x lua binds c++ classes, class functions, enums and some global functions
to lua by using the bindings-generator (tools/bindings-generator) and by manual
bindings. This allows you to call custom c++ from lua conveniently.

### Call the class member function

Open `lua-empty-test/src/hello.lua` and you will see many function calls
like `cc.***`. They are actually calling the class member functions. This is the
`initGLView` function:
```cpp
local function initGLView()
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if nil == glView then
        glView = cc.GLViewImpl:create("Lua Empty Test")
        director:setOpenGLView(glView)
    end

    director:setOpenGLView(glView)

    glView:setDesignResolutionSize(480, 320, cc.ResolutionPolicy.NO_BORDER)

    director:setDisplayStats(true)

    director:setAnimationInterval(1.0 / 60)
end
```

The relationship between lua function call and the c++ function call as follow:
```cpp
|          lua                            |        c++                          |
|  cc.Director:getInstance()              |    cocos2d::Director::getInstance() |
|  director:getOpenGLView()               |    director->getOpenGLView          |
|  cc.GLViewImpl:create("Lua Empty Test") | cocos2d::GLViewImpl::create("Lua Empty Test") |
|  glView:setDesignResolutionSize(480, 320, cc.ResolutionPolicy.NO_BORDER) | glview->glView:setDesignResolutionSize(480, 320, ResolutionPolicy::NO_BORDER)|
```

From this table, we can see that the functions called in lua are very similar
with the functions called in c++. These are some key points that we need to pay
attention to:

- `cc` is a module name like namespace name in c++,it is Cocos2d-x 3.0 new
features. The relation between lua modules and c++ namespaces is as follow:
```cpp
|   Lua module name   |   c++ namespace |
|        cc           | cocos2d, cocos2d::extension, CocosDenshion, cocosbuilder |
|       ccui          |  cocos2d::ui    |
|        ccs          |  cocostudio, cocostudio::timeline |
|        sp           |     spine       |
|       ccexp         | cocos2d::experimental, cocos2d::experimental::ui |
```

- static and non-static c++ functions are called in lua using `:`
- `cc.ResolutionPolicy.NO_BORDER` corresponds to `ResolutionPolicy::NO_BORDER`
which is enum value in the c++. `enum` values are bound to lua by manual.
Different modules use different lua files to keep the bindings value:
```cpp
    |  moudle name |  const value files |
    |    cc        |  Cocos2dConstants.lua, ExtensionConstants.lua, NetworkConstants.lua|
    |   ccui       |  GuiConstants.lua |
    |    ccs       |  StudioConstants.lua|
    |   ccexp      |  experimentalUIConstants.lua|
```
- For some functions, their parameters include cocos2d::Vec2, cocos2d::Vec3
we should do a conversion to call c++ function.For example:

```cpp
    void Node::setPosition(const Vec2& position)
```

In c++, we should call this function like this:

```cpp
	nodeObj->setPosition(Vec2(0.0f, 0.0f))
```

In lua, we should call the function like this:

```cpp
nodeObj:setPosition(cc.p(0.0, 0.0))
```

`cc.p(0.0, 0.0)` is to construct an anonymous table like this {x = 0, y =0}

The other parametric types that should be converted are:

```
	|  parametric types    |   lua conversional format    |
	|   cocos2d::Point     |   {x = numValue, y = numValue} |
	|   cocos2d::Vec3      |   {x = numValue, y = numValue, z = numValue} |
	|   cocos2d::Vec4      |   {x = numValue, y = numValue, z = numValue, w = numValue} |
	|   cocos2d::Rect      |   {x = numValue, y = numValue, width = numValue, height = numValue} |
	|   cocos2d::Size      |   {width = numValue, height = numValue} |
	|   cocos2d::Color4B   |   {r = numValue, g = numValue, b = numValue, a = numValue} |
	|   cocos2d::Color4F   |   	{r = numValue, g = numValue, b = numValue, a = numValue} |
	|   cocos2d::Color3B   |   	{r = numValue, g = numValue, b = numValue} |
	|   cocos2d::PhysicsMaterial | {density = numValue, restitution = numValue, friction = numValue} |
	|   cocos2d::AffineTransform | {a = numValue, b = numValue, c = numValue, d = numValue, tx = numValue, ty = numValue} |
	|   cocos2d::FontDefinition | {fontName = stringValue, fontSize = numValue, fontAlignmentH = numValue, fontAlignmentV = numValue, fontFillColor = {r = numValue, g = numValue, b = numValue}, fontDimensions = {width = numValue, height = numValue}, shadowEnabled = boolValue[,shadowOffset = {width = numValue, height = numValue}, shadowBlur = numValue, shadowOpacity = numValue], strokeEnabled = boolValue[,strokeColor  = 	{r = numValue, g = numValue, b = numValue}, strokeSize = numValue]} |
	|  cocos2d::Vector | {objValue1,objValue2,...,objValuen,...}|
	|  cocos2d::Map<std::string, T>| {key1 = objValue1, key2 = objValue2,..., keyn = objValuen,...} |
	|  cocos2d::Value | {objValue1,objValue2,...,objValuen,...} or key1 = objValue1, key2 = objValue2,..., keyn = objValuen,...} or stringValue or boolValue or numValue |
	|  cocos2d::ValueMap | {key1 = Value1, key2 = Value2,..., keyn = Valuen,...} |
	|  cocos2d::ValueMapIntKey | {numKey1 = Value1, intKey2 = Value2, ...,intKeyn = Valuen,...} |
	|  cocos2d::ValueVector    | {Value1, Value2, ..., Valuen, ...} |
	|  std::vector<string> |   {stringValue1, stringValue2, ..., stringValuen, ...}   |
	|  std::vector<int>    |   {numValue1, numValue2, ..., numValuen, ...}   |
	|  std::vector<float>  |   {numValue1, numValue2, ..., numValuen, ...}   |
	|  std::vector<unsigned short> | {numValue1, numValue2, ..., numValuen, ...} |
	|  cocos2d::Mat4  | {numValue1,numValue2,..., numValue16} |
	|  cocos2d::TTFConfig |{fontFilePath = stringValue, fontSize = numValue, glyphs = numValue, customGlyphs = stringValue, distanceFieldEnabled = boolValue, outlineSize = numValue}
	| cocos2d::MeshVertexAttrib| {size = numValue, type = numValue, vertexAttrib = numValue, vertexAttrib =numValue} |
	| cocos2d::BlendFunc | { src = numValue, dst = numValue} |
```

### Call global functions
Cocos2d-x v3 also binds some global functions to lua manually, such as
`kmGLPushMatrix`, `kmGLTranslatef` and `kmGLLoadMatrix`. We can call these global
functions in lua as follows:
```cpp
	kmGLPopMatrix()
```

### Call OpenGL functions
Cocos2d-x v3 binds some OpenGL functions to lua. All the OpenGL functions are in
the `gl` module and can be called as follows:
```cpp
	local glNode  = gl.glNodeCreate()
	glNode:setContentSize(cc.size(256, 256))
    glNode:setAnchorPoint(cc.p(0.5, 0.5))
    uniformCenter = gl.getUniformLocation(program,"center")
    uniformResolution  = gl.getUniformLocation( program, "resolution")
```

You can refer to `lua-tests/DrawPrimitiveTest` and `lua-tests/OpenGLTest` for
more information.


## Bind a c++ class to lua by bindings-generator automatically
Since Cocos2d-x v3.0, there is a tools called [bindings-generator](https://github.com/cocos2d/bindings-generator) to bind c++ class to lua automatically.

The _bindings-generator_ is based on _tolua++_. There is an _ini_ file in the
`tools/tolua` directory and then run the _genbindings.py_ script to generate the
binding code.

### Create a custom class
Consider this code:
```cpp
// CustomClass.h

#ifndef __CUSTOM__CLASS

#define __CUSTOM__CLASS

#include "cocos2d.h"

namespace cocos2d {
class CustomClass : public cocos2d::Ref
{
public:

    CustomClass();

    ~CustomClass();

    static cocos2d::CustomClass* create();

    bool init();

    CREATE_FUNC(CustomClass);
};
} //namespace cocos2d

#endif // __CUSTOM__CLASS
```

Note:
- the cpp file was omitted  because the bindings-generator only scan the
header files
- The custom class should be inherited from the `Ref` class, this is mainly
due to the destructor of `Ref` calling `removeScriptObjectByObject` to
reduce the reference count of _userdata_ which gets created in the c++
automatically to avoid memory leak.

### Add a new cocos2dx_custom.ini file

In _tools/lua_ folder create a new file named _cocos2dx_custom.ini_ as:

```cpp
[cocos2dx_custom]

# the prefix to be added to the generated functions. You might or might
not use this in your own

# templates

prefix = cocos2dx_custom

# create a target namespace (in javascript, this would create some code
like the equiv. to `ns = ns

# all classes will be embedded in that namespace

target_namespace = cc

android_headers =  -I%(androidndkdir)s/platforms/android-14/arch-arm/usr/include -I%(androidndkdir)s/sources/cxx-stl/gnu-libstdc++/4.7/libs/armeabi-v7a/include -I%(androidndkdir)s/sources/cxx-stl/gnu-libstdc++/4.7/include -I%(androidndkdir)s/sources/cxx-stl/gnu-libstdc++/4.8/libs/armeabi-v7a/include -I%(androidndkdir)s/sources/cxx-stl/gnu-libstdc++/4.8/include

android_flags = -D_SIZE_T_DEFINED_

clang_headers = -I%(clangllvmdir)s/lib/clang/3.3/include

clang_flags = -nostdinc -x c++ -std=c++11 -U __SSE__

cocos_headers = -I%(cocosdir)s/cocos -I%(cocosdir)s/my -I%(cocosdir)s/cocos/2d -I%(cocosdir)s/cocos/base -I%(cocosdir)s/cocos/ui -I%(cocosdir)s/cocos/physics -I%(cocosdir)s/cocos/2d/platform -I%(cocosdir)s/cocos/2d/platform/android -I%(cocosdir)s/cocos/math/kazmath -I%(cocosdir)s/extensions -I%(cocosdir)s/external -I%(cocosdir)s/cocos/editor-support -I%(cocosdir)s

cocos_flags = -DANDROID -DCOCOS2D_JAVASCRIPT

cxxgenerator_headers =

# extra arguments for clang

extra_arguments =  %(android_headers)s %(clang_headers)s %(cxxgenerator_headers)s %(cocos_headers)s %(android_flags)s %(clang_flags)s %(cocos_flags)s %(extra_flags)s

# what headers to parse

headers = %(cocosdir)s/cocos/my/CustomClass.h

# what classes to produce code for. You can use regular expressions here.
# When testing the regular expression, it will be enclosed in "^$", like
# this: "^Menu*$".

classes = CustomClass.*

# what should we skip? in the format ClassName::[function function]
# ClassName is a regular expression, but will be used like this:
# "^ClassName$" functions are also regular expressions, they will not be
# surrounded by "^$". If you want to skip a whole class, just add a single
# "*" as functions. See bellow for several examples. A special class name
# is "*", which will apply to all class names. This is a convenience
# wildcard to be able to skip similar named functions from all classes.

skip =

rename_functions =

rename_classes =

# for all class names, should we remove something when registering in the
# target VM?

remove_prefix =

# classes for which there will be no "parent" lookup

classes_have_no_parents =

# base classes which will be skipped when their sub-classes found them.

base_classes_to_skip =

# classes that create no constructor

# Set is special and we will use a hand-written constructor

abstract_classes =

# Determining whether to use script object(js object) to control the
# lifecycle of native(cpp) object or the other way around. Supported
# values are 'yes' or 'no'.

script_control_cpp = no
```

All of the config files under _tools/tolua_ use the same format. Here is a list
which you should consult when writing your own ini file:

- [title]: To config the title which will by used by the *tools/tolua/gengindings.py*
scripts. Generally, the title could be the file name.
- prefix: To config the prefix of a function name, generally, we also use the
file name as the prefix.
- target_namespace: To config the module name in lua. Here we use the `cc`
as the module name, when you want to use `CustomClass` in lua, you must put
a prefix named `cc` in front of the name. For example, the `CustomClass` could be
reference as `cc.CustomClass`.
- headers: To config all the header files needed for parsing and the %(cocosdir)s
is the engine root path of Cocos2d-x.
- classes: To config all the classes needed to bind. Here it supports regular
expression. So we could set MyCustomClass.* here. For looking more specified usage,
you could ref to `tools/tolua/cocos2dx.ini`.
- skip: To config the functions needed to be omit. Now the bindings-generator can't
parse `void*` type and also the delegate type, so these types needed to be bind
manually. And at this circumstance, you should omit all these types first and
then to bind them manually. You could ref to the config files under path
`cocos/scripting/lua-bindings/auto` .

- rename_functions: To config the functions need to be renamed in the scripting
layer. Due to some reasons, developers want more scripting friendly API, so the
config option is for this purpose.

- rename_classes: Not used any more.

- remove_prefix: Not used any more.

- classes_have_no_parents: To config  the parent class needed to be filter. This
option is seldom modified.

- abstract_classes: To config the classes whose public constructor don't need to
be exported.

- script_control_cpp:yes.  To config whether the scripting layer manage the object
life time or not. If no, then the c++ layer cares about their life time.
Now, it is imperfect to control native object's life time in scripting layer. So
you could simply leave it to *no*.

## Subclassing
Sometimes we want to add some new functions to extend the bindings, think
inheritance in c++. Through `class(classname, super)` function in the `cocos/scripting/lua-bindings/script/cocos2d/extern.lua`, we can realize this
requirement easily. The details function are as follow:

```cpp
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end
```

Through this function, we can see inheritance easily. Example, if we want to
derive from `cc.Node`:

1. Define a subclass by `class` function

```cpp
local SubNode = class("SubNode",function()
       return cc.Node:create()
   end)

--This function like the construtor of c++ class
function SubNode:ctor()
	-- do initialized
end

function SubNode:addSprite(filePath)
    local sprite = cc.Sprite:create(filePath)
    sprite:setPosition(cc.p(0, 0))
    self:addChild(sprite)
end
```

2. Create an object of subclass and use it:
```cpp
local node = SubNode.new()
node:addSprite("xxx.jpg")
```

Note: `new` is implemented by default in the `class` function. Since the type of the
second parameter is `function`, when we call `new`, this is what happens:
```cpp
function SubNode.new(...)
	local instance = cc.Node:create()
	-- copy fields from SubNode to native object
	for k,v in pairs(SubNode) do instance[k] = v end
	instance.class = SubNode
	instance:ctor(...)
	return instance
end
```

The object created by `new` have all the properties and behaviors of the
`cc.Node` object. It also has the properties of the `SubNode` as it is derived
from `cc.Node`:
```cpp
function SubNode:setPostion(x,y)
	print(string.format("x = %0.2f, y = %0.2f"), x, y)
end
```

If we still need to call the function of the same name of super class:

```cpp
getmetatable(SubNode):setPosition(x, y)
```
- The override functions of inherited class in lua can't be called in the c++.


## Memory Management

Cocos2d-x v3.x uses the memory management and garbage collection of lua itself
except the release of `userdata`. If the corresponding classes are derived from
`Ref` the release of `userdata` is managed in c++ by the register table named
`toluafix_refid_ptr_mapping` and `tolua_value_root`.

### Simple Test Case
1. Create a `Sprite` in the head of `createDog` function
```cpp
	local testSprite = cc.Sprite:create("res/land.png")
```

2. Then call the `Sprite` in the `tick` function as follow:
```cpp
	testSprite:getPosition()
```

3. After a period of time, we will see the error message as follows:
```cpp
cocos2d: [LUA-print] stack traceback:
	[string "src/hello.lua"]:13: in function <[string "src/hello.lua"]:10>
	[C]: in function 'getPosition'
	[string "src/hello.lua"]:98: in function <[string "src/hello.lua"]:88>
cocos2d: [LUA-print] ----------------------------------------
cocos2d: [LUA-print] ----------------------------------------
cocos2d: [LUA-print] LUA ERROR: [string "src/hello.lua"]:98: invalid 'self' in function 'tolua_cocos2d_Node_getPosition'
```
This error is triggered because the _testsprite_ didn't add any other node
as a child after creation. The corresponding c++ object was released at the end
of the frame.

### Memory Management for Class Object

#### The Class Members of Ref Class for Memory Management

In `CCRef.h` we see the usage of `CC_ENABLE_SCRIPT_BINDING`:
```cpp
#if CC_ENABLE_SCRIPT_BINDING
public:
    /// object id, ScriptSupport need public _ID
    unsigned int        _ID;
    /// Lua reference id
    int                 _luaID;
    /// scriptObject, support for swift
    void* _scriptObject;
#endif
```
Notice `_ID` and `_luaID`, are very important when you push a `Ref` object to lua
by calling `toluafix_pushusertype_ccobject` to store a key-value table named
`toluafix_refid_ptr_mapping` in the registry. The `_ID` is key and the related
c++ object pointer is value. The related code fragment in the
`toluafix_pushusertype_ccobject` is:
```cpp
		//Extract from `toluafix_pushusertype_ccobject` in the tolua_fix.cpp
        lua_pushstring(L, TOLUA_REFID_PTR_MAPPING);
        lua_rawget(L, LUA_REGISTRYINDEX);                           /* stack: refid_ptr */
        lua_pushinteger(L, refid);                                  /* stack: refid_ptr refid */
        lua_pushlightuserdata(L, vPtr);                              /* stack: refid_ptr refid ptr */

        lua_rawset(L, -3);                  /* refid_ptr[refid] = ptr, stack: refid_ptr */
        lua_pop(L, 1);                                              /* stack: - */
```
Notes:
- `TOLUA_REFID_PTR_MAPPING` is macro definition represent for "toluafix_refid_ptr_mapping"
- `LUA_REGISTRYINDEX` is definition of `Pseudo-Index` for registry of Lua
- `refid` is value of `_ID`
- `vPtr` is value of related c++ object pointer

#### Create a Ref object from Lua
- Call the `cocos2d::Sprite::create("res/land.png")` by lua bindings to
create a Sprite object and push it into lua stack:
```cpp
		//Extract from `lua_cocos2dx_Sprite_create` in lua_cocos2dx_auto.cpp
		std::string arg0;
       	ok &= luaval_to_std_string(tolua_S, 2,&arg0, "cc.Sprite:create");
        if (!ok) { break; }
        cocos2d::Sprite* ret = cocos2d::Sprite::create(arg0);
        object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite",(cocos2d::Sprite*)ret);
        return 1;
```

- Call `toluafix_pushusertype_ccobject` when push created object to lua stack

```cpp
		//Extract from `object_to_luaval` in luaBasicConversions.h
       	if (std::is_base_of<cocos2d::Ref, T>::value)
        {
            // use c style cast, T may not polymorphic
            cocos2d::Ref* dynObject = (cocos2d::Ref*)(ret);
            int ID = (int)(dynObject->_ID) ;
            int* luaID = &(dynObject->_luaID);
            toluafix_pushusertype_ccobject(L,ID, luaID, (void*)ret,type);
        }
```

In the `toluafix_pushusertype_ccobject` , we will use two tables named
"toluafix_refid_ptr_mapping" and "toluafix_refid_type_mapping" in lua's
registry to store the two key-value pairs about `_ID`-`object pointer` and
`_ID`-`object type name`.The details are as follow:

```cpp
	//Extract from `toluafix_pushusertype_ccobject` in the tolua_fix.cpp
    if (*p_refid == 0)
    {
        *p_refid = refid;

        lua_pushstring(L, TOLUA_REFID_PTR_MAPPING);
        lua_rawget(L, LUA_REGISTRYINDEX); /* stack: refid_ptr */
        lua_pushinteger(L, refid); /* stack: refid_ptr refid */
        lua_pushlightuserdata(L, vPtr); /* stack: refid_ptr refid ptr */

        lua_rawset(L, -3); /* refid_ptr[refid] = ptr, stack: refid_ptr */
        lua_pop(L, 1); /* stack: - */

        lua_pushstring(L, TOLUA_REFID_TYPE_MAPPING);
        lua_rawget(L, LUA_REGISTRYINDEX);  /* stack: refid_type */
        lua_pushinteger(L, refid); /* stack: refid_type refid */
        lua_pushstring(L, vType); /* stack: refid_type refid type */
        lua_rawset(L, -3); /* refid_type[refid] = type, stack: refid_type */
        lua_pop(L, 1); /* stack: - */

        //printf("[LUA] push CCObject OK - refid: %d, ptr: %x, type: %s\n",
        //*p_refid, (int)ptr, type);
    }
```

- Call `tolua_pushusertype_internal` to determine whether to create a new
userdata, or just update the userdata.

```cpp
void tolua_pushusertype_internal (lua_State* L, void* value, const char* type,
  int addToRoot)
{
    if (value == NULL)
        lua_pushnil(L);
    else
    {
        luaL_getmetatable(L, type); /* stack: mt */
        if (lua_isnil(L, -1)) { /* NOT FOUND metatable */
            lua_pop(L, 1);
            return;
        }
        lua_pushstring(L,"tolua_ubox");
        lua_rawget(L,-2); /* stack: mt ubox */
        if (lua_isnil(L, -1)) {
            lua_pop(L, 1);
            lua_pushstring(L, "tolua_ubox");
            lua_rawget(L, LUA_REGISTRYINDEX);
        };

        lua_pushlightuserdata(L,value); /* stack: mt ubox key<value> */
        lua_rawget(L,-2); /* stack: mt ubox ubox[value] */

        if (lua_isnil(L,-1))
        {
            lua_pop(L,1); /* stack: mt ubox */
            lua_pushlightuserdata(L,value);
            *(void**)lua_newuserdata(L,sizeof(void *)) = value; /* stack: mt ubox value newud */
            lua_pushvalue(L,-1); /* stack: mt ubox value newud newud */
            lua_insert(L,-4); /* stack: mt newud ubox value newud */
            lua_rawset(L,-3); /* ubox[value] = newud, stack: mt newud ubox */
            lua_pop(L,1); /* stack: mt newud */
            /*luaL_getmetatable(L,type);*/
            lua_pushvalue(L, -2); /* stack: mt newud mt */
            lua_setmetatable(L,-2); /* update mt, stack: mt newud */

# ifdef LUA_VERSION_NUM
            lua_pushvalue(L, TOLUA_NOPEER); /* stack: mt newud peer */
            lua_setfenv(L, -2); /* stack: mt newud */
#endif
        }
        else
        {
            /* check the need of updating the metatable to a more specialized class */
            lua_insert(L,-2); /* stack: mt ubox[u] ubox */
            lua_pop(L,1); /* stack: mt ubox[u] */
            lua_pushstring(L,"tolua_super");
            lua_rawget(L,LUA_REGISTRYINDEX); /* stack: mt ubox[u] super */
            lua_getmetatable(L,-2); /* stack: mt ubox[u] super mt */
            lua_rawget(L,-2); /* stack: mt ubox[u] super super[mt] */
            if (lua_istable(L,-1))
            {
                lua_pushstring(L,type); /* stack: mt ubox[u] super super[mt] type */
                lua_rawget(L,-2); /* stack: mt ubox[u] super super[mt] flag */
                if (lua_toboolean(L,-1) == 1) /* if true */
                {
                    lua_pop(L,3); /* mt ubox[u]*/
                    lua_remove(L, -2);
                    return;
                }
            }
            /* type represents a more specilized type */
            /*luaL_getmetatable(L,type);// stack: mt ubox[u] super super[mt] flag mt */
            lua_pushvalue(L, -5); /* stack: mt ubox[u] super super[mt] flag mt */
            lua_setmetatable(L,-5); /* stack: mt ubox[u] super super[mt] flag */
            lua_pop(L,3); /* stack: mt ubox[u] */
        }
        lua_remove(L, -2);    /* stack: ubox[u]*/

        if (0 != addToRoot)
        {
            lua_pushvalue(L, -1);
            tolua_add_value_to_root(L, value);
        }
    }
}
```
We use a table named `ubox` to store key-value pairs about `userdata` and
`object pointer`. This table would be used in the destruction of the object.

- Call `tolua_add_value_to_root` to add a reference count for `userdata` in lua
by the `tolua_value_root` table in lua registry. The mechanism will make the
object in lua wouldn't collected by lua gc. Example:
```cpp
   local node = cc.Node:create()
   node.extendValue = 10000
   nodeParent:addChild(node, 0 , 9999)
```
This code creates a `node` object and extends the attributes of the node object
dynamically by lua's feature. When we want to get this node and its extended
attribute somewhere, we can do as follows:
```cpp
local child = lnodeParent:getChildByTag(9999)
print(child.extendValue)
```

If we don't call the `tolua_add_value_to_root`, the result of
`print(child.extendValue)` would be uncertain. Sometimes the result would be
10000 and sometimes it would be `nil`. This is because we wouldn't control lua's
automatic gc effectively. When lua gc thinks there are no other
references for this userdata it will collect this userdata. When we call
`getChildByTag` to get a node object, it would create a new userdata and the
extended attributes would disapper. We add a reference count for the userdata
`tolua_value_root` table in lua registry in the c++ to avoid generating this error.

#### The Release of the Userdata

When calling the desturctor of `Ref`, it will trigger the release of the userdata.

In the destructor of Ref, we can see:
```cpp
#if CC_ENABLE_SCRIPT_BINDING
    // if the object is referenced by Lua engine, remove it
    if (_luaID)
    {
        ScriptEngineManager::getInstance()->getScriptEngine()->removeScriptObjectByObject(this);
    }
    ...
#endif
```
After we push a c++ object to lua, the related _luaID would be not 0. We now can
call `removeScriptObjectByObject`

The `removeScriptObjectByObject` called would trigger the call of
`toluafix_remove_ccobject_by_refid`, and this function would call some lua c
APIs to operate the table like `toluafix_refid_ptr_mapping`,
`toluafix_refid_type_mapping` and `tolua_value_root` table in the registry.

The specific implementation of `toluafix_remove_ccobject_by_refid` is as follows:
```cpp
TOLUA_API int toluafix_remove_ccobject_by_refid(lua_State* L, int refid)
{
	void* ptr = NULL;
    const char* type = NULL;
    void** ud = NULL;
    if (refid == 0) return -1;

    // get ptr from tolua_refid_ptr_mapping
    lua_pushstring(L, TOLUA_REFID_PTR_MAPPING);
    lua_rawget(L, LUA_REGISTRYINDEX); /* stack: refid_ptr */
    lua_pushinteger(L, refid); /* stack: refid_ptr refid */
    lua_rawget(L, -2); /* stack: refid_ptr ptr */
    ptr = lua_touserdata(L, -1);
    lua_pop(L, 1); /* stack: refid_ptr */
    if (ptr == NULL)
    {
        lua_pop(L, 1);
        // Lua stack has closed, C++ object not in Lua.
        // printf("[LUA ERROR] remove CCObject with NULL ptr, refid: %d\n", refid);
        return -2;
    }

    // remove ptr from tolua_refid_ptr_mapping
    lua_pushinteger(L, refid); /* stack: refid_ptr refid */
    lua_pushnil(L); /* stack: refid_ptr refid nil */
    lua_rawset(L, -3); /* delete refid_ptr[refid], stack: refid_ptr */
    lua_pop(L, 1); /* stack: - */


    // get type from tolua_refid_type_mapping
    lua_pushstring(L, TOLUA_REFID_TYPE_MAPPING);
    lua_rawget(L, LUA_REGISTRYINDEX); /* stack: refid_type */
    lua_pushinteger(L, refid); /* stack: refid_type refid */
    lua_rawget(L, -2); /* stack: refid_type type */
    if (lua_isnil(L, -1))
    {
        lua_pop(L, 2);
        printf("[LUA ERROR] remove CCObject with NULL type, refid: %d, ptr: %p\n", refid, ptr);
        return -1;
    }

    type = lua_tostring(L, -1);
    lua_pop(L, 1); /* stack: refid_type */

    // remove type from tolua_refid_type_mapping
    lua_pushinteger(L, refid); /* stack: refid_type refid */
    lua_pushnil(L); /* stack: refid_type refid nil */
    lua_rawset(L, -3); /* delete refid_type[refid], stack: refid_type */
    lua_pop(L, 1); /* stack: - */

    // get ubox
    luaL_getmetatable(L, type); /* stack: mt */
    lua_pushstring(L, "tolua_ubox"); /* stack: mt key */
    lua_rawget(L, -2); /* stack: mt ubox */
    if (lua_isnil(L, -1))
    {
        // use global ubox
        lua_pop(L, 1); /* stack: mt */
        lua_pushstring(L, "tolua_ubox"); /* stack: mt key */
        lua_rawget(L, LUA_REGISTRYINDEX); /* stack: mt ubox */
    };


    // cleanup root
    tolua_remove_value_from_root(L, ptr);

    lua_pushlightuserdata(L, ptr); /* stack: mt ubox ptr */
    lua_rawget(L,-2); /* stack: mt ubox ud */
    if (lua_isnil(L, -1))
    {
        // Lua object has released (GC), C++ object not in ubox.
        //printf("[LUA ERROR] remove CCObject with NULL ubox, refid: %d, ptr: %x, type: %s\n", refid, (int)ptr, type);
        lua_pop(L, 3);
        return -3;
    }

    // cleanup peertable
    lua_pushvalue(L, LUA_REGISTRYINDEX);
    lua_setfenv(L, -2);

    ud = (void**)lua_touserdata(L, -1);
    lua_pop(L, 1); /* stack: mt ubox */
    if (ud == NULL)
    {
        printf("[LUA ERROR] remove CCObject with NULL userdata, refid: %d, ptr: %p, type: %s\n", refid, ptr, type);
        lua_pop(L, 2);
        return -1;
    }

    // clean userdata
    *ud = NULL;

    lua_pushlightuserdata(L, ptr); /* stack: mt ubox ptr */
    lua_pushnil(L); /* stack: mt ubox ptr nil */
    lua_rawset(L, -3); /* ubox[ptr] = nil, stack: mt ubox */

    lua_pop(L, 2);
    //printf("[LUA] remove CCObject, refid: %d, ptr: %x, type: %s\n", refid, (int)ptr, type);
    return 0;
}
```

The steps are as follows:

- Get related object pointer stored in the `toluafix_refid_ptr_mapping` table by
the value of `_luaID`. Store it.

- Remove reference relationship of the object pointer from
`toluafix_refid_ptr_mapping` table by `_luID`

- Get related type name stored in the `tolua_refid_type_mapping` table by the
value of `_luaID`,then store it

- Remove reference relationship of type name from `tolua_refid_type_mapping`
table by `_luID`

- Get the related metatable by the type name

- Get the `ubox` table

- Remove reference relationship of userdata from `tolua_value_root` table by
the object pointer got in the upper step

- Clean userdata and remove reference relationship of userdata from `ubox` by
the object pointer got in the upper step.Note:To destroy an object cited by lua,
we only called '*ud = NULL;'

Through the above steps,the refernce relationships in the
`toluafix_refid_ptr_mapping`,`tolua_refid_type_mapping` and
`tolua_refid_type_mapping` table in the registry would be removed, release the
`userdata` which is created when push c++ object to lua stack, and when lua gc
trigger, the related object would be collected if there is no other place refer
to it.

### Memory Management for Lua Callback Function

Cocos2dx have been used `toluafix_refid_function_mapping` table in the registry
to manage the gc of lua callback function

#### Add a reference for Lua Callback Function
When we define a lua function which would be called throuch c++ codes, we whould
store the pointer of this function in the `toluafix_refid_function_mapping` table
by calling `toluafix_ref_function` function in the `tolua_fix.cpp`.Cocos2d-x bound
a series of functions like `registerScriptHandler` and `addEventListener` to
finish this work.

Let's use `registerScriptHandler` of `Node` as a sample,we could use it as follows
in lua:

```
local function onNodeEvent(event)
	if "enter" == event then
		--do something
	end
end

nodeObject:registerScriptHandler(onNodeEvent)
```

The related bindings function is named `tolua_cocos2d_Node_registerScriptHandler`
in the `lua_cocos2dx_manual.cpp`,the most important sections are as follows:

```
        LUA_FUNCTION handler = toluafix_ref_function(tolua_S,2,0);
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, ScriptHandlerMgr::HandlerType::NODE);
```

- `toluafix_ref_function` is implemented to store the related function pointer
into `toluafix_refid_function_mapping` table in the registry with a static
variable named `s_function_ref_id`.This operation makes lua function avoid being
collected by lua gc because that `toluafix_refid_function_mapping` table have a
reference of this function. The details are as follow:

```
TOLUA_API int toluafix_ref_function(lua_State* L, int lo, int def)
{
    // function at lo
    if (!lua_isfunction(L, lo)) return 0;

    s_function_ref_id++;

    lua_pushstring(L, TOLUA_REFID_FUNCTION_MAPPING);
    lua_rawget(L, LUA_REGISTRYINDEX); /* stack: fun ... refid_fun */
    lua_pushinteger(L, s_function_ref_id); /* stack: fun ... refid_fun refid */
    lua_pushvalue(L, lo); /* stack: fun ... refid_fun refid fun */

    lua_rawset(L, -3); /* refid_fun[refid] = fun, stack: fun ... refid_ptr */
    lua_pop(L, 1); /* stack: fun ... */

    return s_function_ref_id;
}
```

- `addObjectHandler` is used to stored the map of object pointer and pair of
`s_function_ref_id` and handler type.

#### Remove a reference for Lua Callback Function
If lua callback function become useless, we should remove the reference in the
`toluafix_refid_function_mapping` table in the registry. Cocos2d-x provided the
`toluafix_remove_function_by_refid` function to realize it. This function could
be called by `removeScriptHandler` of `LuaStack`,`removeScriptHandler` of
`LuaEngine` or directly. The details are as follows:

```
TOLUA_API void toluafix_remove_function_by_refid(lua_State* L, int refid)
{
    lua_pushstring(L, TOLUA_REFID_FUNCTION_MAPPING);
    lua_rawget(L, LUA_REGISTRYINDEX); /* stack: ... refid_fun */
    lua_pushinteger(L, refid); /* stack: ... refid_fun refid */
    lua_pushnil(L); /* stack: ... refid_fun refid nil */
    lua_rawset(L, -3); /* refid_fun[refid] = nil, stack: ... refid_fun */
    lua_pop(L, 1); /* stack: ... */

}
```

Note:
- `refid` is the corresponding value of `s_function_ref_id`.
-  For Ref object,we would call
`ScriptHandlerMgr::getInstance()->removeObjectAllHandlers` to remove all the
reference function relationship which added by the
`ScriptHandlerMgr::getInstance()->addObjectHandler` automatically
-  Because Cocos2d-x v3.x support the features of c++ 11, we can call the related
remove function through the lambda function. For example:

```
//Extract from `lua_cocos2dx_TextureCache_addImageAsync` in lua_cocos2dx_manual.cpp
LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S, 3, 0));


self->addImageAsync(configFilePath, [=](Texture2D* tex){
    int ID = (tex) ? (int)tex->_ID : -1;
    int* luaID = (tex) ? &tex->_luaID : nullptr;
    toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)tex, "cc.Texture2D");
    LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(handler,1);
    LuaEngine::getInstance()->removeScriptHandler(handler);
});
```

By the mechanism of the lambda, we could get the value of handler which represents
the corresponding value of `s_function_ref_id`. When we finish calling lua callback
function,we could call `LuaEngine::getInstance()->removeScriptHandler(handler)`
directly to remove the reference of lua callback function.


## Use Cocos Code IDE to Debug a Lua Game
Cocos Code IDE is tool that can debug a lua script,it has windows and mac version.
You can debug Windows and Android lua games through the windows version and you
can debug Mac, iOS and android lua games through the Mac version.
Now we will demonstrate how to use Cocos Code IDE to debug a lua game based on
the mac version. The process of the windows version is almost the same.

## Prerequisite
If you have been not installed the Cocos Code IDE,you can refer to
[Cocos Code IDE Installation](http://www.Cocos2d-x.org/wiki/Cocos_Code_IDE).

## Cocos Code IDE Configuration

### Basic Settings
Click `Cocos Code IDE/Preferences` to open the configuration dialog,then select
the `Cocos/Lua` to set the directory of Cocos2d-x v3.x in the `Lua Frameworks`:

![](10-img/lua_cocos_preferences.png)

### Additional Settings
You should set directory of some compliling tools about android if you need to
replace the Android runtime which Cocos Code IDE provided. Click
`Cocos Code IDE/Preferences` then pitch on `Cocos` to configurate the directory
of related tools:

![](10-img/cocos_preferences.png)

## Debug a Lua Game
1. Create a new Cocos Lua Project by the right click menu in the
`Lua Projects Explorer`

![](10-img/lua_create_project.png)

2. Select `src/GameScene.lua` and open it,then toggle breakpoint by right click
menu or double click

![](10-img/lua_toggle_breakpoint.png)

3.Click debug button on toolbar

![](10-img/lua_debug_button.png)

4.Trigger the breakpoint,select "Yes" to open `Debug Perspective`,and you will
find many useful debug views like `Call stacks`, `Variables` and `Breakpoints`,etc.

![](10-img/lua_confirm_perspective.png)
![](10-img/lua_debug_dialog.png)

5.Use `Step over`, `Step into`, `Step out` in the tool bar to debug

![](10-img/lua_step_debug.png)

## Code Hot Updating when Debugging
We could realize the hot updating of lua code when debugging by the Cocos Code IDE.

If you want to change the moving path of dog int the src/GameScene.lua, you can
modify the "tick()" function to control the dog's position

```
    local function tick()
        if spriteDog.isPaused then return end
        local x, y = spriteDog:getPosition()
        if x > self.origin.x + self.visibleSize.width then
            x = self.origin.x
        else
            x = x + 1
        end

        spriteDog:setPositionX(x)
    end
```

Modify the implementation of function, for example, change the value 1 to 10 and
save your change. Then you will find that you have improved the speed of
SpriteDog without restarting the app!

## How to Debug on the Other Target Platforms
The above example is executed on the Mac platform because of the default
configuration of Cocos Code IDE.If you debug on the other target platforms you
should modify `Debug Configurations`.

1. Click `Debug Configurations` button on the toolbar to open
`Debug Configurations` dialog

![](10-img/lua_config_button.png)

2. Select the `CocosLuaGame` item,then to configure
![](10-img/lua_debug_configure_dialog.png)

### Debug on the iOS Simulator
1. Check iOS Simulator radio button

2. Choose a runtime app

3. Click the Debug button,IDE will auto-install chosen runtime app and start
runtime to debug

![](10-img/lua_configure_iOS_simulator.png)

### Debug on an iOS Device

1.You need a runtime IPA, you can build a custom runtime IPA by Cocos Code IDE,
then [install runtime IPA](http://www.solutionanalysts.com/blog/how-install-ipa-file-iphone-ipod-ipad-using-itunes-mac-windows)
to iOS device.

  - Click `Build Runtime` on the toolbars

  ![](10-img/lua_configure_build_runtime.png)

  - Click `Yes` button on the pop-up `Cocos` dialog

  ![](10-img/lua_configure_build_runtime_first.png)

  - Click `Generate` button to Generate `Create Native Source Wizard`

  ![](10-img/lua_configure_creat_native_source_wizard.png)

  - Click `Close` button to finish `Create Native Source Wizard`

  ![](10-img/lua_configure_finish_create_native_source_wizard.png)

  - Click `Build Runtime` on the toolbars to open `Runtime Builder Wizard` dialog

  ![](10-img/lua_configure_runtime_builder_wizard.png)

  - Check `Build iOS Device Runtime` and click `Generate` button to generate

  ![](10-img/lua_configure_runtime_select_iOS_device.png)

  - Click `Close` button when Finished dialog pop up

  ![](10-img/lua_configure_finish_iOS_device.png)

2. Click `Debug Configuration`,then check `Remote Debug` radio button on the
`Debug Configuration` dialog
3. Select `iOS` platform
4. Fill IP address of your device into the `Target IP` and Fill the IP address
that your PC used on the `Host IP`(Make sure that the `Target IP` and `Host IP`
can access each other)
5. Click 'Debug' button to begin to debug

  ![](10-img/lua_iOS_device_remote_setting.png)

### Debug on Android Device by ADB Mode
1. Prebuild Runtimelua.apk by `Build Runtime` like first of `Debug on the iOS Device`
2. Check `Android ADB Mode` radio button
3. Choose a runtime apk
4. Click the `Debug` button
5. IDE will auto-install the chosen runtime apk and start to debug

![](10-img/lua_debug_android_adb_mode.png)


### Debug on Android Device by WLAN

1. Install runtime apk to your device manually. It is placed in CocosLuaGame/runtime/android.
2. Start runtime on device manually
3. Click `Debug Configuration`,then check `Remote Debug` radio button on the
`Debug Configuration` dialog
4. Fill IP address of your device into the `Target IP` and Fill the IP address
that your PC used on the `Host IP`(Make sure that the `Target IP` and `Host IP`
can access each other)
5. Click 'Debug' button to begin to debug

![](10-img/lua_anroid_device_remote_setting.png)
-->
