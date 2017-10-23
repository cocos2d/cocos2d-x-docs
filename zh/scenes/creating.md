# 场景创建

创建一个场景非常简单:

{% codetabs name="C++", type="cpp" -%}
auto myScene = Scene::create();
{%- endcodetabs %}

## 还记得场景图吗

第二章中我们学到了 [场景图(scene graph)](../basic_concepts/scene.md) 以及在游戏中它是如何生效的. 要记得场景图决定了场景内节点对象的渲染顺序, 也要记得 __z-order__ 是如何影响场景图的.

_渲染时 `z-order` 值大的节点对象会覆盖值小的节点对象_

## 一个简单场景

让我们构建一个简单的场景, 来学习场景的使用. 记得 Cocos2d-x 用右手坐标系, 也就是说坐标原点(0,0)在展示区的左下角, 当你在场景里放置一些节点对象设置位置时, 注意左下角是位置计算的初始点.

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

当运行这个代码的时候, 我们会看到有一个场景, 场景里面有一个标签和一个精灵. 虽然很简单, 但这却是一个游戏的开始!