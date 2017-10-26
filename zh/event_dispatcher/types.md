<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## There are 5 types of event listeners.

`EventListenerTouch` - responds to touch events

`EventListenerKeyboard` - responds to keyboard events

`EventListenerAcceleration` - responds to accelerometer events

`EventListenMouse` - responds to mouse events

`EventListenerCustom` - responds to custom events

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
