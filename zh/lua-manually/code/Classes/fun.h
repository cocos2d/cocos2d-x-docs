//
//  fun.h
//  Language_Lua
//
//  Created by 郭 一鸣 on 14-1-20.
//
//

#ifndef Language_Lua_fun_h
#define Language_Lua_fun_h

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

int l_Foo_constructor(lua_State * l);

Foo * l_CheckFoo(lua_State * l, int n);

int l_Foo_add(lua_State * l);

int l_Foo_destructor(lua_State * l);

void RegisterFoo(lua_State * l);



#endif
