#cocos2d::Value

- 于v3.0beta加入

定义在"COCOS2DX_ROOT/cocos/base"的头文件"CCValue.h"中

```cpp
class Value;
```

`cocos2d::Value`是许多基本类型(`int`,`float`,`double`,`bool`,`unsigned char,char*`和`std::string`)还有`std::vector<Value>`, `std::unordered_map<std::string,Value>`和`std::unordered_map<int,Value>`这些类的包装类型。

你可以将上面提及的基本类放进`cocos2d::Value`对象将它们转换成对应的类型，反之亦然。

`cocos2d::Value`底层用一个统一的变量来保存任意基本类型值，它将更加节省内存。在`Cocos2d-x v3.0beta`之前使用的是`CCBool`, `CCFloat`, `CCDouble`和`CCInteger`这样基本类型包装类，不过它们将被废弃掉。

**注意**：当处理基本类型和和容器时，请使用`cocos2d::Vector<T>`, `cocos2d::Map<K,V>`和`cocos2d::Value`。

##内存管理

`cocos2d::Value`的内存由它的析构函数来释放，所以使用`cocos2d::Value`时请尽量用推荐的最佳做法。

`cocos2d::Value`包含下面的数据成员：

```cpp
union
{
    unsigned char byteVal;
    int intVal;
    float floatVal;
    double doubleVal;
    bool boolVal;
}_baseData;

std::string _strData;
ValueVector* _vectorData;
ValueMap* _mapData;
ValueMapIntKey* _intKeyMapData;

Type _type;
```

代码段中，`_baseData`, `_strData`和`_type`是由编译器和它们的析构函数负责释放内存的，而`cocos2d::Value`的析构函数则负责释放指针成员（`_vectorData`, `_mapData`和`intKeyMapData`）。

**注意**：`cocos2d::Value`不能像其它cocos2d类型一样使用retain/release和refcount内存管理

##基本用法

`ocos2d::Value`的用法非常简单直接。
下面就是使用的例子：
```cpp
Value val;   // call the default constructor
if (val.isNull()) {
    log("val is null");
}else{
    std::string str =val.getDescription();
    log("The description of val0:%s",str.c_str());
}
//----------------------------------------------------
Value val1(65);   // initialize with an integer
//Value val1(3.4f);   // initialize with a float value
//Value val1(3.5);   // initialize with a double value
log("The description of the integer value:%s",val1.getDescription().c_str());
log("val1.asByte() = %c",val1.asByte());
//----------------------------------------------------
std::string strV = "string";
Value val2(strV);   // initialize with string
log("The description of the string value:%s",val2.getDescription().c_str());
//----------------------------------------------------
auto sp0 = Sprite::create();
Vector<Object*>* vecV = new Vector<Object*>();
vecV->pushBack(sp0);
Value val3(vecV);   // initialize with Vector
log("The description of the Vector value:%s",val3.getDescription().c_str());
delete vecV;
//----------------------------------------------------
Map<std::string, Object*>* mapV = new Map<std::string, Object*>();
mapV->insert(strV,sp0);
Value val4(mapV);   // initialize with Map
log("The description of the Map value:%s",val4.getDescription().c_str());
delete mapV;
//----------------------------------------------------
Value val6(&val4);   // initialize with Map
log("The description of the Value-type value:%s",val6.getDescription().c_str());
//----------------------------------------------------
val2 = val1;   // assigning between 2 Value-type
log("operator-> The description of val2:%s",val2.getDescription().c_str());
val2 = 4;   //assigning directly
log("operator-> The description of val4:%s",val2.getDescription().c_str());
```

结果是：

```cpp
cocos2d: val is null
cocos2d: The description of the integer value:
65

cocos2d: val1.asByte() = A
cocos2d: The description of the string value:
string

cocos2d: The description of the Vector value:
true

cocos2d: The description of the Map value:
true

cocos2d: The description of the Value-type value:
true

cocos2d: operator-> The description of val2:
65

cocos2d: operator-> The description of val4:
4
```

##最佳用法

- 考虑使用cocos2d::Value和新的模版容器(cocos2d::Vector<T>和cocos2d::Map<K,V>)优于使用cocos2d::CCBool, cocos2d::CCFloat,cocos2d::CCDouble,cocos2d::CCString,cocos2d::CCInteger和旧的objective-c风格的容器(cocos2d::CCArray和cocos2d::CCDictionary)。
- 当要使用基本类型的聚合时，将基本类型包装成cocos2d::Value，然后将它们和模版容器cocos2d::Vector<T>和cocos2d::Map<K,V>联合使用。
