//
//  fun.cpp
//  Language_Lua
//
//  Created by 郭 一鸣 on 14-1-18.
//
//

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include <iostream>
#include <sstream>
#include "fun.h"

// The general pattern to binding C++ class to Lua is to write a Lua
// thunk for every method for the class, so here we go:

int l_Foo_constructor(lua_State * l)
{
    const char * name = luaL_checkstring(l, 1);
    
    // We could actually allocate Foo itself as a user data but
    // since user data can be GC'ed and we gain unity by using CRT's heap
    // all along.
    Foo ** udata = (Foo **)lua_newuserdata(l, sizeof(Foo *));
    *udata = new Foo(name);
    
    // Usually, we'll just use "Foo" as the second parameter, but I
    // say luaL_Foo here to distinguish the difference:
    //
    // This 2nd parameter here is an _internal label_ for luaL, it is
    // _not_ exposed to Lua by default.
    //
    // Effectively, this metatable is not accessible by Lua by default.
    luaL_getmetatable(l, "luaL_Foo");
    
    // The Lua stack at this point looks like this:
    //
    //     3| metatable "luaL_foo"   |-1
    //     2| userdata               |-2
    //     1| string parameter       |-3
    //
    // So the following line sets the metatable for the user data to the luaL_Foo
    // metatable
    //
    // We must set the metatable here because Lua prohibits setting
    // the metatable of a userdata in Lua. The only way to set a metatable
    // of a userdata is to do it in C.
    lua_setmetatable(l, -2);
    
    // The Lua stack at this point looks like this:
    //
    //     2| userdata               |-1
    //     1| string parameter       |-2
    //
    // We return 1 so Lua callsite will get the user data and
    // Lua will clean the stack after that.
    
    return 1;
}

Foo * l_CheckFoo(lua_State * l, int n)
{
    // This checks that the argument is a userdata
    // with the metatable "luaL_Foo"
    return *(Foo **)luaL_checkudata(l, n, "luaL_Foo");
}

int l_Foo_add(lua_State * l)
{
    Foo * foo = l_CheckFoo(l, 1);
    int a = luaL_checknumber(l, 2);
    int b = luaL_checknumber(l, 3);
    
    std::string s = foo->Add(a, b);
    lua_pushstring(l, s.c_str());
    
    // The Lua stack at this point looks like this:
    //
    //     4| result string          |-1
    //     3| metatable "luaL_foo"   |-2
    //     2| userdata               |-3
    //     1| string parameter       |-4
    //
    // Return 1 to return the result string to Lua callsite.
    
    return 1;
}

int l_Foo_destructor(lua_State * l)
{
    Foo * foo = l_CheckFoo(l, 1);
    delete foo;
    
    return 0;
}

void RegisterFoo(lua_State * l)
{
    luaL_Reg sFooRegs[] =
    {
        { "new", l_Foo_constructor },
        { "add", l_Foo_add },
        { "__gc", l_Foo_destructor },
        { NULL, NULL }
    };
    
    // Create a luaL metatable. This metatable is not
    // exposed to Lua. The "luaL_Foo" label is used by luaL
    // internally to identity things.
    luaL_newmetatable(l, "luaL_Foo");
    
    // Register the C functions _into_ the metatable we just created.
    luaL_register(l, NULL, sFooRegs);
    
    // The Lua stack at this point looks like this:
    //
    //     1| metatable "luaL_Foo"   |-1
    lua_pushvalue(l, -1);
    
    // The Lua stack at this point looks like this:
    //
    //     2| metatable "luaL_Foo"   |-1
    //     1| metatable "luaL_Foo"   |-2
    
    // Set the "__index" field of the metatable to point to itself
    // This pops the stack
    lua_setfield(l, -1, "__index");
    
    // The Lua stack at this point looks like this:
    //
    //     1| metatable "luaL_Foo"   |-1
    
    // The luaL_Foo metatable now has the following fields
    //     - __gc
    //     - __index
    //     - add
    //     - new
    
    // Now we use setglobal to officially expose the luaL_Foo metatable
    // to Lua. And we use the name "Foo".
    //
    // This allows Lua scripts to _override_ the metatable of Foo.
    // For high security code this may not be called for but
    // we'll do this to get greater flexibility.
    lua_setglobal(l, "Foo");
}