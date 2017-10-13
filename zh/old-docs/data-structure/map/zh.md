#cocos2d::Map<K,V>

- v3.0 beta加入

定义在"COCOS2DX_ROOT/cocos/base"的"CCMap.h"头文件中。

```cpp
template <class K, class V>
class CC_DLL Map;
```

`cocos2d::Map<K,V>`是使用`std::unordered_map`作为底层结构的关联式容器。
而`std::unordered_map`是一个存储键值对的关联式容器，它可以通过它们的键快速检索对应的值。
使用unordered_map，键通常是唯一的，而值则与这个键对应。

在unordered_map内部，元素是无序，它们是根据键的哈希值来存取的，存取的时间复杂度是常量，超级快。

在Cocos2d-x v3.0beta之前，使用的是另外一种顺序式容器`cocos2d::CCDictionary`,不过它将很快被废弃。

设计者们谨慎地设计了`cocos2d::Map<K,V>`用来替代`cocos2d::CCDictionary`，所以应该尽量使用`cocos2d::Map`而不是`cocos2d::CCDictionary`

##模版参数

- `cocos2d::Map<K,V>`类只包含一个数据成员：

```cpp
typedef std::unordered_map<K, V> RefMap;
RefMap _data;
```

`_data`的内存管理是由编译器处理的，当在栈中声明`cocos2d::Map<K,V>`对象时，无需费心释放它占用的内存。
但是如果你是使用`new`操作来动态分配`cocos2d::Map<K,V>`的内存的话，就得用`delete`来释放内存了，`new[]`操作也一样。

**注意**：使用现代的c++，本地存储对象比堆存储对象好。所以请不要用`new`操作来分配`cocos2d::Map<K,V>`的堆对象，请使用栈对象。

如果真心想动态分配堆`cocos2d::Map<K,V>`，请将原始指针用智能指针来覆盖。

**警告**：`cocos2d::Map<K,V>`并不是`cocos2d::Object`的子类，所以不要像使用其他cocos2d类一样来用retain/release和引用计数内存管理。

##基本用例

**警告**：`cocos2d::Map<K,V>`并没有重载[]操作，不要用下标[i]来取`cocos2d::Map<K,V>`对象中的元素。

- 为了解更多的用例，你得参考源码和压缩文件中附带的例子。
下面是一些简单操作的用例：

```cpp
//create Map<K, V> with default size and add a sprite into it
auto sp0 = Sprite::create();
sp0->setTag(0);
Map<std::string, Sprite*> map0;
std::string mapKey0 = "MAP_KEY_0";
map0.insert(mapKey0, sp0);
log("The size of map is %zd.",map0.size()); 
//create a Map<K, V> with capacity equals 5
Map<std::string, Sprite*> map1(map0);
std::string mapKey1 = "MAP_KEY_1";
if(!map1.empty()){
    auto spTemp = (Sprite*)map1.at(mapKey0);
    log("sprite tag = %d", spTemp->getTag());
    auto sp1 = Sprite::create();
    sp1->setTag(1);
    map1.insert(mapKey1, sp1);      
    //get all keys,stored in std::vector, that matches the object
    std::vector<std::string> mapKeyVec;
    mapKeyVec = map1.keys();
    for(auto key : mapKeyVec)
    {
        auto spTag = map1.at(key)->getTag();
        log("The Sprite tag = %d, MAP key = %s",spTag,key.c_str());
        log("Element with key %s is located in bucket %zd",key.c_str(),map1.bucket(key));
    }
    log("%zd buckets in the Map container",map1.bucketCount());
    log("%zd element in bucket 1",map1.bucketSize(1));  
    //get a random object if the map isn't empty, otherwise it returns nullptr
    log("The random object tag = %d",map1.getRandomObject()->getTag());  
    //find(const K& key) can be used to search the container for an element with 'key'
    //erase(const_iterator position) remove an element with an iterator
    log("Before remove sp0, size of map is %zd.",map1.size());
    map1.erase(map1.find(mapKey0));
    log("After remove sp0, size of map is %zd.",map1.size());
}  
//create a Map<K, V> with capacity equals 5
Map<std::string, Sprite*> map2(5);
map2.reserve(10);  //set capacity of the map
```

结果是：

```cpp
cocos2d: The size of map is 1.
cocos2d: sprite tag = 0
cocos2d: The Sprite tag = 1, MAP key = MAP_KEY_1
cocos2d: Element with key MAP_KEY_1 is located in bucket 1
cocos2d: The Sprite tag = 0, MAP key = MAP_KEY_0
cocos2d: Element with key MAP_KEY_0 is located in bucket 0
cocos2d: 2 buckets in the Map container
cocos2d: 1 element in bucket 1
cocos2d: The random object tag = 0
cocos2d: Before remove sp0, size of map is 2.
cocos2d: After remove sp0, size of map is 1.
```

最佳用法
- 将`cocos2d::Map<K,V>()`作为参数传递时，将它声明为常量引用`const cocos2d::Map<K,V>()&`
- V类型必须为`cocos2d::Object`的子类指针，不能用其他的类型包括基本类型。
