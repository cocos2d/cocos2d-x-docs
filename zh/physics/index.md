# 简介

学过之前的那些章节，你就能做出来一款好玩的小游戏了，可是当你试图做一款复杂的游戏，那游戏需要模拟现实世界的情境，比如模拟两个物体碰撞，模拟物体受到重力，你就不知道该怎么办了。别担心，本章就介绍物理引擎，让我们来探索一下如何合理的使用物理引擎！

## 是否需要使用物理引擎

当你的需求很简单时，就不要使用物理引擎。比如只需要确定两个对象是否有碰撞，结合使用节点对象的 `update` 函数和 Rect 对象的 `containsPoint()`，`intersectsRect()` 方法可能就足够了。例如：

{% codetabs name="C++", type="cpp" -%}
void update(float dt)
{
  auto p = touch->getLocation();
  auto rect = this->getBoundingBox();

  if(rect.containsPoint(p))
  {
      // do something, intersection
  }
}
{%- endcodetabs %}

这种检查交集以确定两个对象是否有碰撞的方法，只能解决非常简单的需求，无法扩展。比如你要开发一个游戏，一个场景有 100 个精灵对象，需要判断它们互相是否有碰撞，如果使用这种方式那将非常复杂，同时性能消耗还会严重影响 CPU 的使用率和游戏运行的帧率，这游戏根本没法玩。

这个时候就需要物理引擎了，在模拟物理情景上，物理引擎的扩展性好，性能的消耗也低。像刚才提到的那个情景，使用物理引擎就能很好的解决。第一次了解物理引擎的话，肯定会觉得这些很陌生，我们来看一个简单的例子，通过例子来介绍术语，或许会容易接受一些。

{% codetabs name="C++", type="cpp" -%}
// create a static PhysicsBody
auto physicsBody = PhysicsBody::createBox(Size(65.0f , 81.0f ), PhysicsMaterial(0.1f, 1.0f, 0.0f));
physicsBody->setDynamic(false);

// create a sprite
auto sprite = Sprite::create("whiteSprite.png");
sprite->setPosition(Vec2(400, 400));

// sprite will use physicsBody
sprite->addComponent(physicsBody);

//add contact event listener
auto contactListener = EventListenerPhysicsContact::create();
contactListener->onContactBegin = CC_CALLBACK_1(onContactBegin, this);
_eventDispatcher->addEventListenerWithSceneGraphPriority(contactListener, this);
{%- endcodetabs %}

尽管例子很简单，代码只有几行，但实际上内部做了相当复杂的工作。仔细观察，发生的步骤：

  1. `PhysicsBody` 对象创建
  1. `Sprite` 对象创建
  1. The `Sprite` object applies the properties of the `PhysicsBody` object.
  1. `PhysicsBody` 对象以组件的形式被添加到 `Sprite` 对象
  1. 创建监听器以响应 `onContactBegin()` 事件.

保持耐心，一步一步的去分析，慢慢的就能理解整个过程
