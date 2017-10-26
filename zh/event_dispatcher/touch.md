# 触摸事件

触摸事件是手机游戏中最重要的事件, 它易于创建, 还能提供多种多样的功能.

让我们先了解一下什么是触摸事件, 当你触摸移动设备的屏幕时, 设备感受到被触摸, 了解到被触摸的位置, 同时取得触摸到的内容, 然后你的触摸被回答. 这就是触摸事件.

_如果你希望通过触摸控制屏幕下层的对象, 那可以通过 [优先级](priority.md), 达成这种需求, 优先级高的对象能先处理事件._

创建触摸事件监听器:

{% codetabs name="C++", type="cpp" -%}
//  Create a "one by one" touch event listener
// (processes one touch at a time)
auto listener1 = EventListenerTouchOneByOne::create();

// trigger when you push down
listener1->onTouchBegan = [](Touch* touch, Event* event){
    // your code
    return true; // if you are consuming it
};

// trigger when moving touch
listener1->onTouchMoved = [](Touch* touch, Event* event){
    // your code
};

// trigger when you let up
listener1->onTouchEnded = [=](Touch* touch, Event* event){
    // your code
};

// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1, this);
{%- endcodetabs %}

可以看到, 在使用触摸事件监听器时, 可以监听三种不同的事件, 每一个事件都有自己触发的时机.

三种事件及其触发时机:

* __`onTouchBegan`__    开始触摸屏幕时
* __`onTouchMoved`__    触摸屏幕, 同时在屏幕上移动时
* __`onTouchEnded`__    结束触摸屏幕时