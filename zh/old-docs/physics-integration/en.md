# Physics Integration

* version: since 3.0 alpha1

## Introduction

Simulating real world physics in a game is annoying and so, usually physics engines take charge of this kind of stuff. As you already know, Box2D can simulate almost all the physics effects. However, Chipmunk is more light-weight. In Cocos2d-x 2.0, game uses physics engine directly and Cocos2d-x provide a simple CCPhysicsSprite. CCPhysicsSprite resolve the relationship between physics engine's body and CCSprite, but other elements of physics engine didn't connect to Cocos2d-x, in this way you had to call the APIs of Chipmunk or Box2D in game to solve the logical stuff. Using physics engine directly is complex, it has a lot of API parameters and so it's too much for game developers to remember.

Things have been changed in Cocos2d-x 3.0, with Physics Integration packing Chipmunk and Box2D into Cocos2d-x 3.0. Game developers don't need to concern about which physics engine will be used or call the engine API directly.

Physics engines integrated into Cocos2d-x:

* Physics world integrated into Scene, so when you create a scene you can assign if it uses physics engine or not.
* Node has body property itself, that is sprite has body property too.
* Cocos2d-x 3.0 has encapsulated physics engines' Body(PhysicsBody), Shape(PhysicsShape), Contact(PhysicsContact), Joint(PhysicsJoint) and World(PhysicsWorld), which makes the usage more easier.
* More easier collision detection listener - EventListenerPhysicsContact.

## Creating a game project with physics engines

You can create a 3.0 project by using the script in this path **/tools/project-creator/create_project.py**

The physics integration is opened by default, and it uses chipmunk as the base physics engine.

You can comment the definition of `CC_USE_PHYSICS` in `ccConfig.h` to disable it.

## Creating a scene with physics world

Following code creates a scene with physics world and passes it on to child layer. Add codes in **PhysicsLayer.h** :

```
class PhysicsLayer : public cocos2d::Layer
{
...
// add following codes
void setPhyWorld(PhysicsWorld* world){m_world = world;}
private:
    PhysicsWorld* m_world;
...
}
```

And add following code to **createScene** method in **PhysicsLayer.cpp**:

```
Scene* PhysicsLayer::createScene()
{
...
// add following codes
auto scene = Scene::createWithPhysics();
scene->getPhysicsWorld()->setDebugDrawMask(PhysicsWorld::DEBUGDRAW_ALL);

auto layer = HelloWorld::create();
layer->setPhyWorld(scene->getPhysicsWorld());
...
return scene;
}
```

Scene class has a new static factory method - createWithPhysics() to create a scene with physics world. You can get PhysicsWorld instance by Scene's `getPhysicsWorld()` method.

PhysicsWorld's `setDebugDrawMask()` method is very useful when debugging physics engine as it can make shape, joint and contact visible in physics world. Remember to switch off the debug function when you want to release your game.

You can pass on PhysicsWorld to ChildLayer by `setPhyWorld()`, and there is only one PhysicsWorld instance in a scene, which is shared by other layers.

PhysicsWorld has default gravity setting, which is `Vect(0.0f, -98.0f)`, you can invoke `setGravity()` to set it to another value.

You can change the speed of physics world with `setSpeed()`.

## Creating Physics Boundary

As we know, everything in physics world is influenced by gravity. Physics engine provides **staticShape** method to create a shape that is not influenced by gravity and in Cocos2d-x 2.0 we need to know every parameters of **staticShape** in physics engine.

However, in 3.0 PhysicsShape is a property of Node, so if you want to set PhysicsWorld's property you have to pass them by a Node instance.

Following code will show you how to create a physics boundary around the screen:

```
Size visibleSize = Director::getInstance()->getVisibleSize();
auto body = PhysicsBody::createEdgeBox(visibleSize, PHYSICSBODY_MATERIAL_DEFAULT, 3);
auto edgeNode = Node::create();
edgeNode->setPosition(Point(visibleSize.width/2,visibleSize.height/2));
edgeNode->setPhysicsBody(body);
scene->addChild(edgeNode);
```

PhysicsWorld has many factory methods, such as **createEdgeBox** - create a rectangle edge and all the parameters are:

1. Rectangle area, set as **visibleSize**.
2. Optional parameter-Texture, defaulted to **PHYSICSBODY_MATERIAL_DEFAULT**.
3. Optional parameter-Border Size, defaulted to **1**.

Then we created a Node and attached the body we just created to Node. We set the center of the screen as the position of the Node, and finally added the Node to the Scene.

In Cocos2d-x 3.0 the **addChild** method of Node can deal with physical body. It will add Node's body to scene's PhysicsWorld automatically.

PhysicsBody's project method can create corresponding PhysicsBody and a PhysicsShape automatically according to body's size, which is set using parameters. And it's a common practice to create a body by using physics engine directly. However, Physics Integration in Cocos2d-x 3.0 has simplified this process, so we don't need to write a lot of code.

## Creating a sprite which is influenced by gravity

With Cocos2d-x 3.0 creating a sprite that is influenced by gravity is very easy.

```
void HelloWorld::addNewSpriteAtPosition(Point p)
{
    auto sprite = Sprite::create("circle.png");
    sprite->setTag(1);
    auto body = PhysicsBody::createCircle(sprite->getContentSize().width / 2);
    sprite->setPhysicsBody(body);
    sprite->setPosition(p);
    this->addChild(sprite);
}
```

Create a sprite first, and then create a circle body that is attached on a sprite by PhysicsBody::createCircle. The whole process is as same as creating a boundary.

You can create a PhysicsShape and add it to the body by `addShape()`, but notice that the mass(product of density and area) and momentum of the shape will be added to the body automatically, and you can't change the relative position and rotation of this shape after it is added to the body. You can remove it with `removeShape()` if you don't need it anymore.

## Collision detection

Cocos2d-x has refactored event dispatch and all the events are managed by event dispatcher. So physics engine's collision event is managed by event dispatcher now.

Register a collision callback function **begin** by following code:

```
auto contactListener = EventListenerPhysicsContact::create();
contactListener->onContactBegin = CC_CALLBACK_1(HelloWorld::onContactBegin, this);
_eventDispatcher->addEventListenerWithSceneGraphPriority(contactListener, this);
```

Every collision detect event is listened by **EventListenerPhysicsContact**. Create an instance, then set its callback function **conContactBegin**. **CC_CALLBACK_1** is callback pointer transform function used by C++11. Because **onContactBegin** callback function has two parameters, we use **CC_CALLBACK_1** to transform them.

_eventDispatcher is a member of base class Node, it can be used by an initialized Layer.

You can also use `EventListenerPhysicsContactWithBodies`, `EventListenerPhysicsContactWithShapes`, `EventListenerPhysicsContactWithGroup` to listen to the particular event you are interested in depending on bodys, shapes or group. But you also need to set the physics contact related bitmask value, because the contact event won't be received by default, even when you create the relative EventListener.

The contact relative bitmask setting and group setting are the same as Box2D. 

There are three values: **CategoryBitmask**， **ContactTestBitmask** and **CollisionBitmask**. you can use corresponding get/set method to get/set them. They are tested by logical and operation. When **CategoryBitmask** of one body and with **ContactTestBitmask** of another body with the result doesn't equal to zero, the contact event will be sent, otherwise the contact event won't be sent. When **CategoryBitmask** of one body and with **CollisionBitmask** of another body with the result doesn't equal to zero, they will collied, otherwise it won't. You should notice that by default, **CategoryBitmask** value is 0xFFFFFFFF, **ContactTestBitmask** value is 0x00000000, and **CollisionBitmask** value is 0xFFFFFFFF, which means all bodies will collide with each other but without sending contact event by default.

Another setting for physics contact is **group**, the objects in the same group will collide with each other when it's value larger than zero, and won't collide with each other when it's value is less than zero. Notice that when **group** doesn't equal to zero, it will ignore the collide bitmask setting (The contact test setting still works.).

There are four contact callback functions in `EventListenerPhysicsContact`: `onContactBegin`, `onContactPreSolve`, `onContactPostSolve` and `onContactSeperate`.

`onContactBegin` will be invoked at contact begin, and only invoked once at this contact. You can decide if two shapes have collision or not by returning true or false. You can use `PhysicsContact::setData()` to set user data for coming contact operation. Notice that `onContactPreSolve` and `onContactPostSolve` will not be invoked when `onContactBegin` returns false, but however `onContactSeperate` will be invoked once.

`onContactPreSolve` will be invoked at each step, you can use `PhysicsContactPreSolve` setting functions to set contact parameters, like restitution, friction etc. You can also decide if two shapes have collision or not by returning true or false, and you can invoke `PhysicsContactPreSolve::ignore()` to skip subsequent `onContactPreSolve` and `onContactPostSolve` callbacks(returns true by default).

`onContactPostSolve`will be invoked at two shapes collision response has been processed in each step. You can do some subsequent contact operations in it, destroy a body for example.

`onContactSeperate` will be invoked at two shapes separated. It is also invoked once at this contact. It must be in pair with `onContactBegin`, so you can destroy you own userdata here which you set with `PhysicsContact::setData()`.

## Demo

You can get Demo of this document from this: <https://github.com/Yangtb/newPhysics.git>

Demo is based on [cocos2d-x-3.0alpha1](http://cdn.cocos2d-x.org/cocos2d-x-3.0alpha1.zip), clone it and put it in **cocos2d-x-3.0alpha1/projects**, you can create one if you don't have project folder.

You can also run PhysicsTest in test-cpp to learn how to use the physics integration.
