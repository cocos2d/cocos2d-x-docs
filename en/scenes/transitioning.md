### Transitioning between Scenes
You might need to move between `Scene` objects in your game. Perhaps starting a
new game, changing levels or even ending your game. Cocos2d-x provides a number
of ways to do __scene transitions__.

#### Ways to transition between Scenes
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

#### Transition Scenes with effects
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
