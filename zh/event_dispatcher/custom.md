# 自定义事件

上述提到的事件都是系统内置的, 如触摸事件, 键盘事件等. 此外, 你可以制作自定义事件, 这些事件不是由系统控制触发的, 而是通过代码手动触发.

创建自定义事件监听器:

{% codetabs name="C++", type="cpp" -%}
_listener = EventListenerCustom::create("game_custom_event1", [=](EventCustom* event){
    std::string str("Custom event 1 received, ");
    char* buf = static_cast<char*>(event->getUserData());
    str += buf;
    str += " times";
    statusLabel->setString(str.c_str());
});

_eventDispatcher->addEventListenerWithFixedPriority(_listener, 1);
{%- endcodetabs %}

上面制作了一个自定义事件监听器, 并预设了响应方法. 下面创建自定义事件, 并手动分发:

{% codetabs name="C++", type="cpp" -%}
static int count = 0;
++count;

char* buf[10];
sprintf(buf, "%d", count);

EventCustom event("game_custom_event1");
event.setUserData(buf);

_eventDispatcher->dispatchEvent(&event);
{%- endcodetabs %}

示例创建了一个自定义事件( _EventCustom_ )对象, 并设置了 `UserData`, 然后调用 `_eventDispatcher->dispatchEvent(&event)` 进行手动事件分发. 当预先定义的事件监听器, 收到此事件, 将会触发对应的响应函数. 响应函数中可以获取到事件分发时设置的 `UserData` 完成数据处理.

_注意: `EventCustom` 与 `EventListenerCustom` 的第一个参数事件名都是字符串 `game_custom_event1`_
