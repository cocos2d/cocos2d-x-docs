## Registering events with the dispatcher
It is easy to register an event with the __Event Dispatcher__. Taking the sample
touch event listener from above:

```cpp
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);
```

It is important to note that a touch event can only be registered once per object.
If you need to use the same listener for multiple objects you should
use __clone()__.

```cpp
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);

// Add the same listener to multiple objects.
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite2);

_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite3);
```

## Removing events from the dispatcher
An added listener can be removed with following method:

```cpp
_eventDispatcher->removeEventListener(listener);
```

Although they may seem special, built-in `Node` objects use the __event dispatcher__
in the same way we have talked out. Makes sense, right? Take `Menu` for an example.
When you have a `Menu` with `MenuItems` when you click them you are dispatching a
event. You can also __removeEventListener()__ on built-in `Node` objects.
