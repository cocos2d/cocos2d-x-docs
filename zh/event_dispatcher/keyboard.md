# 键盘事件

对于桌面游戏，一般需要通过键盘做一些游戏内的控制，这时你就需要监听键盘事件。Cocos2d-x 支持键盘事件，就像上节介绍的触摸事件一样。

创建键盘事件监听器：

{% codetabs name="C++", type="cpp" -%}
// creating a keyboard event listener
auto listener = EventListenerKeyboard::create();
listener->onKeyPressed = CC_CALLBACK_2(KeyboardTest::onKeyPressed, this);
listener->onKeyReleased = CC_CALLBACK_2(KeyboardTest::onKeyReleased, this);

_eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);

// Implementation of the keyboard event callback function prototype
void KeyboardTest::onKeyPressed(EventKeyboard::KeyCode keyCode, Event* event)
{
        log("Key with keycode %d pressed", keyCode);
}

void KeyboardTest::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
        log("Key with keycode %d released", keyCode);
}
{%- endcodetabs %}

可以看到，在使用键盘事件监听器时，可以监听两种不同的事件，每一个事件都有自己的触发时机。

两种事件及触发时机：

* __`onKeyPressed`__    按键被按下时
* __`onKeyReleased`__   按下状态的按键被放开时
