## Accelerometer events
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
