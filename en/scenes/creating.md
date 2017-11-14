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
