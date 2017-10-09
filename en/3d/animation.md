<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

##Animation
`Sprite3D` objects are essential to our game! We have learned how to manipulate them.
However, we might want a more rich experience. Enter animation! To run a 3d
animation, you can use the `Animation3D` and `Animate3D` objects. You then create
an `Animate3D` action using the `Animation3D` object. Example:

{% codetabs name="C++", type="cpp" -%}
// the animation is contained in the .c3b file
auto animation = Animation3D::create("orc.c3b");

// creates the Action with Animation object
auto animate = Animate3D::create(animation);

// runs the animation
sprite->runAction(RepeatForever::create(animate));
{%- endcodetabs %}

Run the example __Programmer Guide Sample__ code to see this in action! Please
keep in mind that 3D animations are exactly the same concepts as 2D. Please refer
to Chapter 4 in this guide.

###Multiple animations
What do you do when you want to run multiple __animations__ at the same time?
Using both the __animation start time__ and __animation length__ parameters you
can create multiple animations. The unit for both parameters is seconds. Example:

{% codetabs name="C++", type="cpp" -%}
auto animation = Animation3D::create(fileName);

auto runAnimate = Animate3D::create(animation, 0, 2);
sprite->runAction(runAnimate);

auto attackAnimate = Animate3D::create(animation, 3, 5);
sprite->runAction(attackAnimate);
{%- endcodetabs %}

In the above example there are two animations that get run. The first starts
immediately and lasts for *2 seconds*. The second starts after *3 seconds* and lasts
for *5 seconds*.

###Animation speed
The __speed__ of the animation is a positive integer for forward while
a negative speed would be reverse. In this case the speed is set to *10*.
This means that this animation can be considered to be *10* seconds in length.

###Animation blending
When using multiple animations, __blending__ is automatically applied between each
animation. The purpose of __blending__ is to create a smooth transition between
effects. Given two animations, A and B, the last few frames of animation A and
the first few frames of animation B overlap to make the change in animation look
natural.

The default transition time is 0.1 seconds. You can set the transition time by
using __Animate3D::setTransitionTime__.

Cocos2d-x only supports __linear interpolation__ between keyframes. This fills in
__gaps__ in the curve to ensure a smooth path. If you use other interpolation
methods in the model production, our built-in tool, __fbx-conv__ will
generate additional keyframes to compensate. This compensation is completed in
accordance with the target frame. For more information on __fbx-conv__ please refer
to the section discussing it at the end of this chapter.
