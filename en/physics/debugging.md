## Debugging Physics Body and Shapes
If you ever wish to have red boxes drawn around your __physics bodies__ to aid
in debugging, simple add these 2 lines to your core, where it makes sense to you.
Perhaps `AppDelegate` is a good place.

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->getRunningScene()->getPhysics3DWorld()->setDebugDrawEnable(true);
Director::getInstance()->getRunningScene()->setPhysics3DDebugCamera(cameraObjecct);
{%- endcodetabs %}

## Disabling Physics
Using the built-in __physics engine__ is a good idea. It is solid and advanced.
However, if you wish to use an alternative __physics engine__ you can. All you need
to do is disabling __CC_USE_PHYSICS__ in __base/ccConfig.h__.
