# 场景切换

开始一个新游戏，改变关卡，或结束游戏时，为了给用户不同的效果呈现，大多需要切换不同的场景。Cocos2d-x 提供了一系列方式去做这件事情 __场景切换__。

## 场景切换的方式

有很多场景切换的方式，每种都有特定的方法，让我们来看看：

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();
{%- endcodetabs %}

__`runWithScene()`__ 用于开始游戏，加载第一个场景。只用于第一个场景！

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->runWithScene(myScene);
{%- endcodetabs %}

__`replaceScene()`__ 使用传入的场景替换当前场景来切换画面，当前场景被释放。这是切换场景时最常用的方法

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->replaceScene(myScene);
{%- endcodetabs %}

__`pushScene()`__ 将当前运行中的场景暂停并压入到场景栈中，再将传入的场景设置为当前运行场景。只有存在正在运行的场景时才能调用该方法。

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->pushScene(myScene);
{%- endcodetabs %}

__`popScene()`__ 释放当前场景，再从场景栈中弹出栈顶的场景，并将其设置为当前运行场景。如果栈为空，直接结束应用。

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->popScene(myScene);
{%- endcodetabs %}

## 场景切换的效果设置

在场景切换的过程中，你可以添加一些效果：

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();

// Transition Fade
Director::getInstance()->replaceScene(TransitionFade::create(0.5, myScene, Color3B(0,255,255)));

// FlipX
Director::getInstance()->replaceScene(TransitionFlipX::create(2, myScene));

// Transition Slide In
Director::getInstance()->replaceScene(TransitionSlideInT::create(1, myScene) );
{%- endcodetabs %}
