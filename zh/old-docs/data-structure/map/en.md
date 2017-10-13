#cocos2d::Map< K,V >

- Since: v3.0 beta
- Language: C++

Defined in header "[CCMap.h](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCMap.h)" located in the path "COCOS2DX_ROOT/cocos/base".

---

```cpp
template <class K, class V>
class CC_DLL Map;
```

---

`cocos2d::Map<K,V>` is template associative container which uses [std::unordered_map<K, V>](http://en.cppreference.com/w/cpp/container/unordered_map) as its internal infrastructure.

The std::unordered_map<K, V> is associative container that store elements formed by the combination of a key value and a mapped value, and which allows for fast retrieval of individual elements based on their keys.

In an unordered_map, the key value is generally used to uniquely identify the element, while the mapped value is an object with the content associated to this key.

Internally, the elements in the unordered_map are not sorted in any particular order with respect to either their key or mapped values, but organized into buckets depending on their hash values to allow for fast access to individual elements directly by their key values (with a constant average time complexity on average).

Before Cocos2d-x v3.0 beta, there is another sequence container named [cocos2d::CCDictionary](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCDictionary.h) which will be deprecated in the future.

Because we carefully design the `cocos2d::Map<K,V>` container as a replacement for `cocos2d::CCDictionary`, please use cocos2d::Map<T> instead of `cocos2d::CCDictionary`.
##Template parameters

**K** - The type of the key values.

- Each element in an unordered_map is uniquely identified by its key value.

**V** - The type of the mapped value.

- T must be the a pointer to [cocos2d::Object](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCObject.h) descendant object type. No other data type or primitives are allowed. Because we integrate the memory management model of Cocos2d-x into `cocos2d::Map<K,V>`. （since v3.0 beta）

##Memory Management
The `cocos2d::Map<K,V>` class contains only one data member:

```cpp
typedef std::unordered_map<K, V> RefMap;
RefMap _data;
```

The memory management of `_data` is handled automatically by the compiler. If you declare a `cocos2d::Map<K,V>` object on stack, you don't need to care about the memory deallocation.

If you call `new` operator to allocate a dynamic memory of `cocos2d::Map<K,V>`, you should call `delete` operator to deallocate the memory after usage. The same goes for `new[]` and `delete[]`.

**Note**: In modern c++, it prefer local storage object over heap storage object. So please don't call `new` operator to allocate a heap object of `cocos2d::Map<K,V>`, use stack object instead.

If you do want to dynamic allocate `cocos2d::Map<K,V>` on the heap due to some obligatory reasons. Please wrap the raw pointer with smart pointers like `shared_ptr`,`unique_ptr`.

**WARNING**: `cocos2d::Map<K,V>` doesn't use retain/release and refcount memory management like other Cocos2d-x classes!


##Basic Usage

**WARNING** The `cocos2d::Map<K,V>` doesn't overload `operator[]`, so you can't get an element from `cocos2d::Map<K,V>` using subscript operator like `map[i]`.

For more APIs usage, please refer to the source code and the tests distributed with Cocos2d-x 3.0 beta archive.

Here is a simple usage example:

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

output:

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


##Best practice

- When pass `cocos2d::Map<K, V>()` as an argument, declare it as a const reference like `const cocos2d::Map<K, V>()&`
- T must be the a pointer to `cocos2d::Object` descendant object type. No other data type or primitives are allowed.
