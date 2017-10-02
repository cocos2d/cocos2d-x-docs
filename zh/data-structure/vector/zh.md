#cocos2d::Vector<T>

- v3.0 beta加入

定义在"COCOS2DX_ROOT/cocos/base"的"CCVector.h"头文件中。

---

```cpp
template<class T>class CC_DLL Vector;
```

---

`cocos2d::Vector<T>`是一个封装好的能动态增长顺序访问的容器。
`cocos2d::Vector<T>`中的元素是按序存取的，它的低层实现数据结构是标准模版库中的标准顺序容器`std::vector`。
在Cocos2d-x v3.0 beta之前，使用的是另外一个顺序访问容器`cocos2d::CCArray`，不过它将会被废弃。
设计者们将`cocos2d::Vector<T>`设计为`cocos2d::CCArray`的替代品，所以建议优先考虑使用`cocos2d::Vector<T>`。
`cocos2d::Vector<T>`的一些操作的时间复杂度如下：

- 随机访问，O(1)
- 将元素插入到尾部或者删除尾部的元素，O(1)
- 随机插入或删除, O(n)

##模版参数

**T** - 元素类型
- T的类型必须是继承自`cocos2d::Object`类型的指针。因为已经将Cocos2d-x的内存管理模型集成到了`cocos2d::Vector<T>`中，所以类型参数不能是其他的类型包括基本类型。

##内存管理

`cocos2d::Vector<T>`类只包含一个成员数据：

```cpp
std::vector<T> _data;
```

`_data`的内存管理是由编译器自动处理的，如果声明了一个`cocos2d::Vector<T>`类型，就不必费心去释放内存。
**注意**：使用现代的c++，本地存储对象比堆存储对象好。所以请不要用new操作来申请`cocos2d::Vector<T>`的堆对象，请使用栈对象。
如果真心想动态分配堆`cocos2d::Vector<T>`，请将原始指针用智能指针来覆盖。
**警告**：`cocos2d::Vector<T>`并不是`cocos2d::Object`的子类，所以不要像使用其他cocos2d类一样来用retain/release和引用计数内存管理。

##基本用法

作者们用`std::vector<T>`的基本操作加上Cocos2d-x的内存管理规则来覆盖该模版原先的普通操作。
所以pushBack()操作将会保留传递过来的参数，而popBack()则会释放掉容器中最后的一个元素。
当你使用这些操作的时候，你需要特别注意这些受托管的对象，对于新手来说，这往往是陷阱。
警告：`cocos2d::Vector<T>`并没有重载[]操作，所以不能直接用下标[i]来获取第i位元素。
`cocos2d::Vector<T>`提供了不同类型的迭代器，所以我们可以受益于c++的标准函数库，我们可以使用大量标准泛型算法和for_each循环。
除了std::vector<T>容器的操作之外，开发者们还加入许多标准算法诸如：`std::find`, `std::reverse`和`std::swap`，这些算法可以简化很多通用的操作。
要了解更多的api用例，可以参考Cocos2d-x 3.0beta的源码和压缩包里附带的例子。
下面是一些简单的例子：

```cpp
//create Vector<Sprite*> with default size and add a sprite into it
auto sp0 = Sprite::create();
sp0->setTag(0);
//here we use shared_ptr just as a demo. in your code, please use stack object instead
std::shared_ptr<Vector<Sprite*>>  vec0 = std::make_shared<Vector<Sprite*>>();  //default constructor
vec0->pushBack(sp0);

//create a Vector<Object*> with a capacity of 5 and add a sprite into it
auto sp1 = Sprite::create();
sp1->setTag(1);

//initialize a vector with a capacity
Vector<Sprite*>  vec1(5);
//insert a certain object at a certain index
vec1.insert(0, sp1);

//we can also add a whole vector
vec1.pushBack(*vec0);

for(auto sp : vec1)
{
    log("sprite tag = %d", sp->getTag());
}

Vector<Sprite*> vec2(*vec0);
if (vec0->equals(vec2)) { //returns true if the two vectors are equal
    log("pVec0 is equal to pVec2");
}
if (!vec1.empty()) {  //whether the Vector is empty
    //get the capacity and size of the Vector, noted that the capacity is not necessarily equal to the vector size.
    if (vec1.capacity() == vec1.size()) {
        log("pVec1->capacity()==pVec1->size()");
    }else{
        vec1.shrinkToFit();   //shrinks the vector so the memory footprint corresponds with the number of items
        log("pVec1->capacity()==%zd; pVec1->size()==%zd",vec1.capacity(),vec1.size());
    }
    //pVec1->swap(0, 1);  //swap two elements in Vector by their index
    vec1.swap(vec1.front(), vec1.back());  //swap two elements in Vector by their value
    if (vec2.contains(sp0)) {  //returns a Boolean value that indicates whether object is present in vector
        log("The index of sp0 in pVec2 is %zd",vec2.getIndex(sp0));
    }
    //remove the element from the Vector
    vec1.erase(vec1.find(sp0));
    //pVec1->erase(1);
    //pVec1->eraseObject(sp0,true);
    //pVec1->popBack();

    vec1.clear(); //remove all elements
    log("The size of pVec1 is %zd",vec1.size());
}
```

输出：

```cpp
Cocos2d: sprite tag = 1
Cocos2d: sprite tag = 0
Cocos2d: pVec0 is equal to pVec2
Cocos2d: pVec1->capacity()==2; pVec1->size()==2
Cocos2d: The index of sp0 in pVec2 is 0
Cocos2d: The size of pVec1 is 0
```

##最佳做法

- 考虑基于栈的`cocos2d::Vector<T>`优先用于基于堆的
- 当将`cocos2d::Vector<T>`作为参数传递时，将它声明成常量引用：`const cocos2d::Vector<T>&`
- 返回值是`cocos2d::Vector<T>`时，直接返回值，这种情况下编译器会优化成移动操作。
- 不要用任何没有继承cocos2d::Object的类型作为`cocos2d::Vector<T>`的数据类型。
