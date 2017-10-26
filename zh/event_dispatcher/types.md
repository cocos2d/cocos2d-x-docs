# 事件监听器

## 五种监听器

* `EventListenerTouch` - 响应触摸事件

* `EventListenerKeyboard` - 响应键盘事件

* `EventListenerAcceleration` - 响应加速度事件

* `EventListenMouse` - 响应鼠标事件

* `EventListenerCustom` - 响应自定义事件

## 事件的吞没

当你有一个监听器, 已经接收到了期望的事件, 这时事件应该被吞没. 事件被吞没, 意味着在事件的传递过程中, 你消耗了此事件, 事件不再向下传递. 避免了下游的其它监听器获取到此事件.

设置吞没:

{% codetabs name="C++", type="cpp" -%}
// When "swallow touches" is true, then returning 'true' from the
// onTouchBegan method will "swallow" the touch event, preventing
// other listeners from using it.
listener1->setSwallowTouches(true);

// you should also return true in onTouchBegan()

listener1->onTouchBegan = [](Touch* touch, Event* event){
    // your code

    return true;
};
{%- endcodetabs %}
