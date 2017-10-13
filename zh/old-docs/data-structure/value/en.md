#cocos2d::Value

- Since: v3.0 beta
- Language: C++

Defined in the head "[CCValue.h](https://github.com/andyque/cocos2d-x/blob/develop/cocos/base/CCValue.h)" located in "COCOS2DX_ROOT/cocos/base"

---

```cpp
class Value;
```

---

`cocos2d::Value` is a wrapper class for many primitives(`int`,`float`,`double`,`bool`,`unsigned char`,`char*` and `std::string`) plus `std::vector<Value>`, `std::unordered_map<std::string,Value>` and `std::unordered_map<int,Value>`.

You can put all the primitives mentioned above into a `cocos2d::Value` object and convert it to the corresponding primitive. The opposite is vice verse.

Internally, `cocos2d::Value` uses a union variable to hold all kinds of primitives which saves a lot of memory space.

Before Cocos2d-x v3.0 beta, there are `CCBool`, `CCFloat`, `CCDouble`, `CCinteger` primitive wrapper. These classes will be deprecated in the future.

*Note*:When you deal with primitives and container, please use `cocos2d::Vector<T>`,`cocos2d::Map<K,V>` and `cocos2d::Value`.


##Memory Management
The memory of `cocos2d::Value` is handled automatically by it's own destructor. So please stick to the best practice of c++ memory management rules when handling the memory of `cocos2d::Value`.

The `cocos2d::Value` class contains the following data members:

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

From the code snippets, `_baseData`, `_strData` and `_type` data members' memory are handled automatically by the compiler and their own destructors. The destructor of `cocos2d::Value` is responsible for deallocating all the resources of pointer member variables(`_vectorData`,`_mapData` and `_intKeyMapData`).

WARNING: `cocos2d::Value` doesn't use retain/release and refcount memory management like other Cocos2d-x classes!

##Basic Usage
The usage of `cocos2d::Value` is very straightforward.

Here is a simple usage example:

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

output:

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

##Best Practice
- Prefer `cocos2d::Value` and new template container(`cocos2d::Vector<T>` and `cocos2d::Map<K,V>`) over `cocos2d::CCBool`, `cocos2d::CCFloat`,`cocos2d::CCDouble`,`cocos2d::CCString`,`cocos2d::CCInteger` and old Objective-c style container(`cocos2d::CCArray` and `cocos2d::CCDictionary`).
- When you want to deal with primitives aggregate, wrap the primitives with `cocos2d::Value` and combine them with the new template container `cocos2d::Vector<T>` and `cocos2d::Map<K,V>`.
