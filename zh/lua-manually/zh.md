#手动绑定C++类到Lua

Cocos2d-x 3.0开始, Lua Binding使用tolua++方式自动绑定底层C++类到Lua层，使用户能够用Lua方式调用引擎各种接口。但是用户还是希望手动绑定某些自定义类，所以接下来的内容将一步一步讲解如何手动将自定义C++类绑定到Lua。

###创建自定义类

首先，定义一个类Foo，这个类就是接下来要绑定到Lua的类。

`注意：`所有C++类文件必须放在`Classes`文件夹里，所有Lua文件必须放在`Resources`文件夹里。

在`fun.h`头文件中添加如下代码：

```cpp
#include <iostream>
#include <sstream>
class Foo
{
public:
    Foo(const std::string & name) : name(name)
    {
        std::cout << "Foo is born" << std::endl;
    }
    
    std::string Add(int a, int b)
    {
        std::stringstream ss;
        ss << name << ": " << a << " + " << b << " = " << (a+b);
        return ss.str();
    }
    
    ~Foo()
    {
        std::cout << "Foo is gone" << std::endl;
    }
    
private:
    std::string name;
};
```

这个类有三个函数，构造函数,Add函数和析构函数。作用是输出不同字符串，以判断各函数是否被调用。

###绑定自定义类到Lua

开始前，先了解下绑定C++类的一些基本原理。

首先创建一个userdata来存放C++类对象指针，然后给userdata添加元表，用index元方法映射C++类中的对象方法。

####userdata

Lua中userdata为自定义类型，即用户自定义C++类类型，非Lua基本类型。绑定过程中用来存放C++类对象指针，从而将C++类映射到Lua中。

####元表(metatable)

带有索引的集合的表，绑定过程中用来存放和映射C++类中的对象和对象方法。

####__index

元表索引，指向用来存放userdata的元表。用来索引已创建的元表栈中的C++类名以及类方法名。

接下来完成实现部分，在`fun.cpp`中添加如下代码：

```cpp
#include "fun.h"

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

// 1.
int l_Foo_constructor(lua_State * l)
{
    const char * name = luaL_checkstring(l, 1);
 
    Foo ** udata = (Foo **)lua_newuserdata(l, sizeof(Foo *));
    
    *udata = new Foo(name);
    
    return 1;
}

// 2.
Foo * l_CheckFoo(lua_State * l, int n)
{
    return *(Foo **)luaL_checkudata(l, n, "luaL_Foo");
}

// 3.
int l_Foo_add(lua_State * l)
{
    Foo * foo = l_CheckFoo(l, 1);
    
    int a = luaL_checknumber(l, 2);
    int b = luaL_checknumber(l, 3);
    
    std::string s = foo->Add(a, b);
    lua_pushstring(l, s.c_str());
    
    return 1;
}

// 4.
int l_Foo_destructor(lua_State * l)
{
    Foo * foo = l_CheckFoo(l, 1);
    
    delete foo;
    
    return 0;
}

// 5.
void RegisterFoo(lua_State * l)
{
    luaL_Reg sFooRegs[] =
    {
        { "new", l_Foo_constructor },
        { "add", l_Foo_add },
        { "__gc", l_Foo_destructor },
        { NULL, NULL }
    };
    
    luaL_newmetatable(l, "luaL_Foo");
    
    luaL_register(l, NULL, sFooRegs);
   
    lua_setfield(l, -1, "__index");
    
    lua_setglobal(l, "Foo");
}
```

`代码详解:`

1) C++绑定到Lua的构造函数，`luaL_checkstring`用来检查构造函数的形参是否为`string`类型并返回这个`string`。利用`lua_newuserdata`创建一个userdata来存放`Foo`类对象指针。`luaL_getmetatable`将与名为`luaL_Foo`相关联的元表推入栈中。此时，Lua栈中的内容如下：

```
3| metatable "luaL_foo"   |-1
2| userdata               |-2
1| string parameter       |-3
```

`lua_setmetatable`将位于Lua栈中-2位置的`userdata`添加到元表`luaL_foo`中。最后，返回值1使得Lua可以得到userdata，之后栈将会被清空。

2) `luaL_checkudata`用来检测形参是否为`luaL_Foo`元表中的userdata，并返回这个userdata。

3) 此函数是将C++类中的Add()函数映射到Lua中，`lua_pushstring`将字符串压入栈中，返回值1使得字符串返回给Lua调用函数。

4) 此函数是将C++类中的析构函数映射到Lua中。

5) 此函数是注册C++类到Lua和注册所有已绑定的C++函数到Lua。`sFooRegs`给每个已绑定的C++函数一个能被Lua访问的名字。`luaL_newmetatable`创建一个名为luaL_Foo的元表并压入栈定，`luaL_register`将 `sFooRegs`添加到luaL_Foo中。`lua_pushvalue`将luaL_Foo元表中元素的拷贝压入栈中。`lua_setfield`将luaL_Foo元表的index域设为`__index`。`lua_setglobal`将元表luaL_Foo重命名为Foo并将它设为Lua的全局变量，这样Lua可以通过识别Foo来访问元表luaL_Foo，并使Lua脚本能够覆盖元表Foo，即覆盖C++函数。如此一来，用户可以用Lua代码自定功能，覆盖掉C++类中函数的功能，极大地提高了代码灵活性。

现在添加绑定函数的函数声明至`fun.h`中：

```cpp
int l_Foo_constructor(lua_State * l);

Foo * l_CheckFoo(lua_State * l, int n);

int l_Foo_add(lua_State * l);

int l_Foo_destructor(lua_State * l);

void RegisterFoo(lua_State * l);
```

#### Lua测试代码

添加如下代码到`fun.lua`：

```lua
function Foo:speak()
    print("Hello, I am a Foo")
end
 
local foo = Foo.new("fred")
local m = foo:add(3, 4)
 
print(m)
 
foo:speak()
 
Foo.add_ = Foo.add
// 1.
function Foo:add(a, b)
    return "here comes the magic: " .. self:add_(a, b)
end
 
m = foo:add(9, 8)
 
print(m)
```
1. 同名函数覆盖绑定的C++函数，提高扩展性。

####绑定检测

将`#include "fun.h"`添加至`AppDelegate.cpp`中，并在`AppDelegate.cpp`中的`applicationDidFinishLaunching`函数中添加如下代码：

```cpp
    // register lua engine
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    // Adding code here...
    // register lua binding
    
    RegisterFoo(engine->getLuaStack()->getLuaState());
    
    std::string path = FileUtils::getInstance()->fullPathForFilename("fun.lua");
    engine->executeScriptFile(path.c_str());
```

`注意:`因为Cocos2d-x Lua Binding目前不支持多个状态，所以在注册已绑定的C++类时，只能使用当前运行的状态。

运行程序，如果得到下面的输出结果证明已经绑定成功:

```
Foo is born
cocos2d: [LUA-print] fred: 3 + 4 = 7
cocos2d: [LUA-print] Hello, I am a Foo
cocos2d: [LUA-print] here comes the magic: fred: 9 + 8 = 17
```

`Android环境测试:`

如果希望在Android环境下调试，在执行`proj.android/build_native`脚本前，需要在`proj.android/jni/Android.mk`文件中添加`fun.cpp`文件包含：

```
LOCAL_SRC_FILES := hellolua/main.cpp \
                   ../../Classes/AppDelegate.cpp \
                   ../../Classes/fun.cpp
```
