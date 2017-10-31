# 加速度传感器事件 events

现在一些移动设备配备有加速度传感器, 我们可以通过监听它的事件获取各方向的加速度.

可以设想要完成一个游戏情景: 通过来回移动手机, 平衡小球在手机中的位置. 这种场景的完成, 就需要监听加速度传感器事件.

使用加速度传感器, 需要先启用

{% codetabs name="C++", type="cpp" -%}
Device::setAccelerometerEnabled(true);
{%- endcodetabs %}

创建加速度传感器监听器:

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
