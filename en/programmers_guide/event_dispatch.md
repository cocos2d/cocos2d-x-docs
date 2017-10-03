# Event Dispatcher

## What is the EventDispatch mechanism?
__EventDispatch__ is a mechanism for responding to user events.

The basics:

* Event listeners encapsulate your event processing code.
* Event dispatcher notifies listeners of user events.
* Event objects contain information about the event.

<a name="types"></a>

## 5 types of event listeners.

`EventListenerTouch` - responds to touch events

`EventListenerKeyboard` - responds to keyboard events

`EventListenerAcceleration` - responds to accelerometer events

`EventListenMouse` - responds to mouse events

`EventListenerCustom` - responds to custom events

<a name="priority"></a>

## FixedPriority vs SceneGraphPriority

The __EventDispatcher__ uses priorities to decide which listeners get delivered an
event first.

__Fixed Priority__ is an integer value. Event listeners with lower Priority values
get to process events before event listeners with higher Priority values.

__Scene Graph Priority__ is a pointer to a `Node`. Event listeners whose _Nodes_ have
higher __z-order__ values (that is, are drawn on top) receive events before event
listeners whose _Nodes_ have lower __z-order__ values (that is, are drawn below).
This ensures that touch events, for example, get delivered front-to-back, as you
would expect.

Remember Chapter 2? Where we talked about the __scene graph__ and we talked about
this diagram?

![](basic_concepts-img/in-order-walk.png "in-order walk")

Well, when use __Scene Graph Priority__ you are actually walking this above tree
backwards... __I__, __H__, __G__, __F__, __E__, __D__, __C__, __B__, __A__. If
an event is triggered, __H__ would take a look and either __swallow__ it (more
  on this below) or let is pass through to _I__. Same thing, __I__ will either
  __consume__ it or let is pass through to __G__ and so on until the event either
  __swallowed__ it or does not get answered.

<a name="touch"></a>

## Touch Events
__Touch events__ are the most important event in mobile gaming. They are easy to
create and provide versatile functionality. Let's make sure we know what a touch
event is. When you touch the screen of your mobile device, it accepts the touch,
looks at where you touched and decides what you touched. Your touch is then answered.
It is possible that what you touched might not be the responding object but perhaps
something underneath it. Touch events are usually assigned a priority and the
event with the highest priority is the one that answers. Here is how you create
a basic touch event listener:

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

As you can see there are 3 distinct events that you can act upon when using a
touch event listener. They each have a distinct time in which they are called.

__onTouchBegan__ is triggered when you press down.

__onTouchMoved__ is triggered if you move the object around while still pressing
down.

__onTouchEnded__ is triggered when you let up on the touch.

## Swallowing Events
When you have a listener and you want an object to accept the event it was given
you must __swallow__ it. To say it another way, you __consume__ it so that it
doesn't get passed to other objects in highest to lowest priority. This is easy
to do.

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

<a name="keyboard"></a>

## Creating a keyboard event
For desktop games, you might want find using keyboard mechanics useful.
Cocos2d-x supports keyboard events. Just like with touch events above,
keyboard events are easy to create.

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

<a name="accelerometer"></a>

## Creating an Accelerometer event
Some mobile devices come equipped with an accelerometer. An accelerometer is a
sensor that measures g-force as well as changes in direction. A use case would
be needing to move your phone back and forth, perhaps to simulate a balancing act.
Cocos2d-x also supports these events and creating them is simple.
Before using accelerometer events, you need to enable them on the device:

{% codetabs name="C++", type="cpp" -%}
Device::setAccelerometerEnabled(true);
{%- endcodetabs %}

{% codetabs name="C++", type="cpp" -%}
// creating an accelerometer event
auto listener = EventListenerAcceleration::create(CC_CALLBACK_2(
AccelerometerTest::onAcceleration, this));

_eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);

// Implementation of the accelerometer callback function prototype
void AccelerometerTest::onAcceleration(Acceleration* acc, Event* event)
{
    //  Processing logic here
}
{%- endcodetabs %}

<a name="mouse"></a>

## Creating a mouse event
As it always has, Cocos2d-x supports mouse events.

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

<a name="custom></a>

## Creating a Custom Event
The event types above are defined by the system, and the events (such as touch
screen, keyboard response etc) are triggered by the system automatically. In
addition, you can make your own custom events which are not triggered by the system,
but by your code, as follows:

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

A custom event listener has been defined above, with a response method, and added
to the event dispatcher. So how is the event handler triggered? Check it out:

{% codetabs name="C++", type="cpp" -%}
static int count = 0;
++count;

char* buf[10];
sprintf(buf, "%d", count);

EventCustom event("game_custom_event1");
event.setUserData(buf);

_eventDispatcher->dispatchEvent(&event);
{%- endcodetabs %}

The above example creates an EventCustom object and sets its UserData. It is then
dispatched manually with `_eventDispatcher->dispatchEvent(&event)`. This triggers
the event handler defined previously. The handler is called immediately so a local
stack variable can be used as the UserData.

<a name="registering"></a>

## Registering event with the dispatcher
It is easy to register an event with the __Event Dispatcher__. Taking the sample
touch event listener from above:

{% codetabs name="C++", type="cpp" -%}
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);
{%- endcodetabs %}

It is important to note that a touch event can only be registered once per object.
If you need to use the same listener for multiple objects you should
use __clone()__.

{% codetabs name="C++", type="cpp" -%}
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);

// Add the same listener to multiple objects.
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite2);

_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite3);
{%- endcodetabs %}

## Removing events from the dispatcher
An added listener can be removed with following method:

{% codetabs name="C++", type="cpp" -%}
_eventDispatcher->removeEventListener(listener);
{%- endcodetabs %}

Although they may seem special, built-in `Node` objects use the __event dispatcher__
in the same way we have talked out. Makes sense, right? Take `Menu` for an example.
When you have a `Menu` with `MenuItems` when you click them you are dispatching a
event. You can also __removeEventListener()__ on built-in `Node` objects.
