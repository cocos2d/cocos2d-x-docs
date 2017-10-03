<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

# Building and Transitioning Scenes

## What is a Scene?
A `Scene` is a container that holds `Sprites`, `Labels`, `Nodes` and other
objects that your game needs. A `Scene` is responsible for running game logic and
rendering the content on a per-frame basis. You need at least one `Scene` to start
your game. You can think of this like a movie. The `Scene` is what is running and
users see what is happening in real-time. You can have any number of `Scene` objects
in your game and transition through them easily. Cocos2d-x provides __scene transitions__
and you can even have __scene transitions__ with cool effects.

## Creating a Scene
It is very easy to create a `Scene`

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();
{%- endcodetabs %}

## Remember the Scene Graph?
In __Chapter 2__  of this guide we learned about a __scene graph__ and how it affects
the drawing of our game. The important thing to remember is that this defines
the drawing order of the GUI elements. Also remember __z-order__!

## A Simple Scene
Lets's build a simple `Scene`. Remember that Cocos2d-x uses a __right handed
coordinate system__. This means that our _0,0_ coordinate is at the bottom left
corner of the screen/display. When you start positioning your game elements this
is where you should start your calculations from. Let's create a simple `Scene`
and add a few elements to it:

{% codetabs name="C++", type="cpp" -%}
auto dirs = Director::getInstance();
Size visibleSize = dirs->getVisibleSize();

auto myScene = Scene::create();

auto label1 = Label::createWithTTF("My Game", "Marker Felt.ttf", 36);
label1->setPosition(Vec2(visibleSize.width / 2, visibleSize.height / 2));

myScene->addChild(label1);

auto sprite1 = Sprite::create("mysprite.png");
sprite1->setPosition(Vec2(100, 100));

myScene->addChild(sprite1);
{%- endcodetabs %}

When we run this code we shall see a simple `Scene` that contains a `Label` and
a `Sprite`. It doesn't do much but it's a start.

## Transitioning between Scenes
You might need to move between `Scene` objects in your game. Perhaps starting a
new game, changing levels or even ending your game. Cocos2d-x provides a number
of ways to do __scene transitions__.

### Ways to transition between Scenes
There are many ways to transition through your __scenes__. Each has specific
functionality. Let's go through them. Given:

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();
{%- endcodetabs %}

__runWithScene()__ - use this for the first scene only. This is the way to start
your games first `Scene`.

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->runWithScene(myScene);
{%- endcodetabs %}

__replaceScene()__ - replace a scene outright.

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->replaceScene(myScene);
{%- endcodetabs %}

__pushScene()__ - suspends the execution of the running scene, pushing it on the
stack of suspended scenes. Only call this if there is a running scene.

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->pushScene(myScene);
{%- endcodetabs %}

__popScene()__ - This scene will replace the running one. The running scene will
be deleted. Only call this if there is a running scene.

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->popScene(myScene);
{%- endcodetabs %}

### Transition Scenes with effects
You can add visual effects to your `Scene` transitions

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();

// Transition Fade
Director::getInstance()->replaceScene(TransitionFade::create(0.5, myScene, Color3B(0,255,255)));

// FlipX
Director::getInstance()->replaceScene(TransitionFlipX::create(2, myScene));

// Transition Slide In
Director::getInstance()->replaceScene(TransitionSlideInT::create(1, myScene) );
{%- endcodetabs %}

<!---### Converting between coordinate systems

#### convertToNodeSpace

`convertToNodeSpace` will be used in, for example, tile-based games, where you
have a big map. `convertToNodeSpace` will convert your openGL touch coordinates
to the coordinates of the .tmx map or anything similar. Example:

The following picture shows that we have _node1_ with anchor point (0,0) and _node2_
with anchor point (1,1).

We invoke

```cpp
Vec2 point = node1->convertToNodeSpace(node2->getPosition());
```

 convert node2’s SCREEN coordinates to node1’s local.As the result, node2 with the position of (-25，-60).

![](scenes-img/5_10.jpg)

#### convertToWorldSpace

`convertToWorldSpace` converts on-node coordinates to SCREEN coordinates. `convertToWorldSpace` will always return SCREEN position of our sprite, might be very useful if you want to capture taps on your sprite but need to move/scale your layer.
Generally, the parent node call this method with the child node position, return the world’s postion of child’s as a result. It seems make no sense calling this method if the caller isn’t the parent.

Example:

```cpp
Point point = node1->convertToWorldSpace(node2->getPosition());
```

The above code will convert the node2‘s coordinates to the coordinates on the
screen. For example if the anchor position of node1 is which will be the bottom
left corner of the node1, but not necessarily on the screen. This will convert
the position of the node2 which is to the screen coordinate of the point relative
to node1 ). The result shows in the following picture:

![](scenes-img/5_11.jpg)

#### convertToWorldSpaceAR

`convertToWorldSpaceAR` will return the position relative to anchor point: so if
our scene - root layer has anchor point of Vec2(0.5f, 0.5f) - default,
`convertToWorldSpaceAR` should return position relative to screen center.

`convertToNodeSpaceAR` - the same logic as for `convertToWorldSpaceAR`

### Sample code：

```cpp

Sprite *sprite1 = Sprite::create("CloseNormal.png");

sprite1->setPosition(Vec2(20,40));

sprite1->setAnchorPoint(Vec2(0,0));

this->addChild(sprite1);

Sprite *sprite2 = Sprite::create("CloseNormal.png");

sprite2->setPosition(Vec2(-5,-20));

sprite2->setAnchorPoint(Vec2(1,1));

this->addChild(sprite2);

Vec2 point1 = sprite1->convertToNodeSpace(sprite2->getPosition());

Vec2 point2 = sprite1->convertToWorldSpace(sprite2->getPosition());

Vec2 point3 = sprite1->convertToNodeSpaceAR(sprite2->getPosition());

Vec2 point4 = sprite1->convertToWorldSpaceAR(sprite2->getPosition());

LOG("position = (%f,%f)",point1.x,point1.y);

LOG("position = (%f,%f)",point2.x,point2.y);

LOG("position = (%f,%f)",point3.x,point3.y);

LOG("position = (%f,%f)",point4.x,point4.y);

```

Result：

```

    position = (-25.000000,-60.000000)

    position = (15.000000,20.000000)

    position = (-25.000000,-60.000000)

    position = (15.000000,20.000000)

```
--->
