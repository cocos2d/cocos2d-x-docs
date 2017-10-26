<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

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
