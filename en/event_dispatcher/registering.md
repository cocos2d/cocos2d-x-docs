## Registering events with the dispatcher
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
