# 鼠标事件

就像前几节介绍的那样，Cocos2d-x 支持响应鼠标事件

创建鼠标事件监听器：

{% codetabs name="C++", type="cpp" -%}
_mouseListener = EventListenerMouse::create();
_mouseListener->onMouseMove = CC_CALLBACK_1(MouseTest::onMouseMove, this);
_mouseListener->onMouseUp = CC_CALLBACK_1(MouseTest::onMouseUp, this);
_mouseListener->onMouseDown = CC_CALLBACK_1(MouseTest::onMouseDown, this);
_mouseListener->onMouseScroll = CC_CALLBACK_1(MouseTest::onMouseScroll, this);

_eventDispatcher->addEventListenerWithSceneGraphPriority(_mouseListener, this);

void MouseTest::onMouseDown(Event *event)
{
    // to illustrate the event....
    EventMouse* e = (EventMouse*)event;
    string str = "Mouse Down detected, Key: ";
    str += tostr(e->getMouseButton());
}

void MouseTest::onMouseUp(Event *event)
{
    // to illustrate the event....
    EventMouse* e = (EventMouse*)event;
    string str = "Mouse Up detected, Key: ";
    str += tostr(e->getMouseButton());
}

void MouseTest::onMouseMove(Event *event)
{
    // to illustrate the event....
    EventMouse* e = (EventMouse*)event;
    string str = "MousePosition X:";
    str = str + tostr(e->getCursorX()) + " Y:" + tostr(e->getCursorY());
}

void MouseTest::onMouseScroll(Event *event)
{
    // to illustrate the event....
    EventMouse* e = (EventMouse*)event;
    string str = "Mouse Scroll detected, X: ";
    str = str + tostr(e->getScrollX()) + " Y: " + tostr(e->getScrollY());
}
{%- endcodetabs %}
