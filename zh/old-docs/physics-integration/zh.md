# 使用 Cocos2d-x 3.0 physicals

## 概述

在游戏中模拟真实的物理世界是个比较麻烦的，通常都是交给物理引擎来做。比较知名的有Box2D了，它几乎能模拟所有的物理效果，而chipmunk则是个更轻量的引擎等。在Cocos2d-x 2.0中，游戏直接使用物理引擎，引擎提供了一个简单的CCPhysicsSprite，处理了物理引擎的body与CCSprite的关系，而物理引擎的其他要素并没有和引擎对应起来，游戏需要选择直接调用chipmunk或Box2D的api来处理逻辑。然而直接使用物理引擎是比较复杂的，它物理引擎的接口参赛很多，很复杂，而且需要开发人员对物理引擎和Cocos2d-x都很了解，才能把两者融合得很好。

这个情况在3.0中有了改变，全新的Physics integration，把chipmunk和Box2D封装到引擎内部，游戏开发不用关心底层具体是用的哪个物理引擎，不用直接调用物理引擎的接口。

物理引擎和Cocos2d-x进行了深度融合：

* 物理世界被融入到Scene中，即当创建一个场景时，就可以指定这个场景是否使用物理引擎。
* Node自带body属性，也就是sprite自带body属性。
* Cocos2d-x 3.0对物理引擎的Body(PhysicsBody)，Shape(PhysicsShape)，Contact(PhysicsContact)，Joint(PhysicsJoint)，World(PhysicsWorld)进行了封装抽象，使用更简单。
* 更简单的碰撞检测监听EventListenerPhysicsContact。

## 创建带物理引擎的游戏工程

在3.0中创建工程由/tools/project-creator下的create_project.py脚本完成。

默认创建的工程已支持物理引擎，内部启用的是chipmunk。

你可以注释掉`ccConfig.h`里的`CC_USE_PHYSICS`宏定义去关闭它。

## 创建带物理世界的scene

下面的代码创建带物理世界的scene，并传递给child layer。

在.h文件中添加以下代码


```
void setPhyWorld(PhysicsWorld* world){m_world = world;}
private:
    PhysicsWorld* m_world;

```

在.cpp文件的createScene方法中添加以下代码

```
auto scene = Scene::createWithPhysics();
scene->getPhysicsWorld()->setDebugDrawMask(PhysicsWorld::DEBUGDRAW_ALL);

auto layer = HelloWorld::create();
layer->setPhyWorld(scene->getPhysicsWorld());
```

Scene类有了新的静态工厂方法，createWithPhysics()，创建带物理世界的scene。
Scene的getPhysicsWorld()方法获取PhysicsWorld实例，

PhysicsWorld的setDebugDrawMask()方法，在调试物理引擎中是很有用的，它把物理世界中不可见的shape，joint，contact可视化。当调试结束，游戏发布的时候，你需要把这个debug开关关闭。

通过setPhyWorld()方法来传递PhysicsWorld给ChildLayer。一个scene只有一个PhysicsWorld，其下的所有layer共用一个PhysicsWorld实例。

PhysicsWorld默认是有带重力的，默认大小为`Vect(0.0f, -98.0f)`, 你也可以通过的`setGravity()`方法来设置Physics的重力参数。

你还可以通过`setSpeed()`来设置物理世界的模拟速度。


## 创建物理边界

我们知道物理世界中，所有物体受重力的影响。
物理引擎提供staticShape创建一个不受重力影响的形状，在Cocos2d-x 2.0中，我们需要了解物理引擎的staticShape相关的各种参数来完成边界设置。

在3.0中，PhysicsShape属于Node的一个属性，要设置PhysicsWorld的属性，都需要通过一个Node实例来中介传达。

下面的代码展示如何创建一个围绕屏幕四周的物理边界。

```
Size visibleSize = Director::getInstance()->getVisibleSize();
auto body = PhysicsBody::createEdgeBox(visibleSize, PHYSICSBODY_MATERIAL_DEFAULT, 3);
auto edgeNode = Node::create();
edgeNode->setPosition(Point(visibleSize.width/2,visibleSize.height/2));
edgeNode->setPhysicsBody(body);
scene->addChild(edgeNode);
```

PhysicsBody包含很多工厂方法，createEdgeBox创建一个矩形边界，参数含义依次是：

1. 矩形区域大小，这里设置为visibleSize。
2. 设置材质，可选参数，默认为PHYSICSBODY_MATERIAL_DEFAULT。
3. 边线宽度，可选参数，默认为1。

然后我们创建一个Node，把刚才创建的body附加到Node上，并设置好Node的position为屏幕中心点。
最后，把Node添加到scene。

Node的addChild方法，在3.0中，有对物理body做处理，它会自动把node的body设置到scene的PhysicsWorld上去。

PhysicsBody中的工程方法，针对参数设置的body大小，会自动创建对应的PhysicsBody和一个PhysicsShape，这也是通常情况下，直接使用物理引擎创建一个body需要做的事情。3.0的Physics integration极大的简化了使用物理引擎的代码量。

## 创建受重力作用的sprite

在3.0中创建一个受重力作用的Sprite也很简单。

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

首先创建一个sprite，然后用PhysicsBody::createCircle创建一个圆形的body附加在sprite上。
整个过程和之前创建边界的过程是一致的。

你也可以创建自己的PhysicsShape然后通过PhysicsBody的addShape()方法加入到body中，但需要注意的是，shape的重量（mess,通过密度和体积计算得出）和转动惯量(moment)是会自动加到body上的，并且shape加到body后是不能改变它相对于body的位置和角度的，不需要时可以通过removeShape()来移除。

## 碰撞检测

Cocos2d-x中，事件派发机制做了重构，所有事件均有事件派发器统一管理。物理引擎的碰撞事件也不例外，
下面的代码注册碰撞begin回调函数。

```
auto contactListener = EventListenerPhysicsContact::create();
contactListener->onContactBegin = CC_CALLBACK_1(HelloWorld::onContactBegin, this);
_eventDispatcher->addEventListenerWithSceneGraphPriority(contactListener, this);
```

碰撞检测的所有事件由EventListenerPhysicsContact来监听，创建一个实例，然后设置它的onContactBegin回调函数，CC_CALLBACK_1是Cocos2d-x 3.0使用C++ 11的回调函数指针转换助手函数，由于onContactBegin回调有一个参数，所有这里使用CC_CALLBACK_1来做转换。

_eventDispatcher是基类Node的成员，Layer初始化后就可直接使用。

你还可以使用`EventListenerPhysicsContactWithBodies`, `EventListenerPhysicsContactWithShapes`, `EventListenerPhysicsContactWithGroup` 来监听你感兴趣的两个物体,两个形状，或者某组物体的碰撞事件，但是要注意设置物体碰撞相关的mask值（下面会详细说明），因为物体碰撞事件在默认情况下是不接收的，即使你创建了相应的EventListener。

PhysicsBody碰撞相关的mask设置和group设置跟Box2D的设置是一致的。

mask设置分为**CategoryBitmask**， **ContactTestBitmask** 和 **CollisionBitmask**，你可以通过相关的get/set接口来获得或者设置他们。他们是通过逻辑与来进行测试的，当一个物体的**CategoryBitmask**跟另一个物体的**ContactTestBitmask**的逻辑与测试结果不为零时，将会发送相应的事件，否则不发送。而当一个物体的**CategoryBitmask**跟另一个物体的**CollisionBitmask**的逻辑与测试结果不为零时，将会发生碰撞，否则不发生碰撞。注意，在默认情况下**CategoryBitmask**的值为0xFFFFFFFF，**ContactTestBitmask**的值为0x00000000，**CollisionBitmask**的值为0xFFFFFFFF，也就是说默认情况下所有物体都会发生碰撞但不发送通知。

另一个碰撞相关的设置是**group**（组），当它大于零时，同组的物体将发生碰撞，当它小于零时，同组的物体不碰撞。注意，当**group**不为零时，他将忽略mask的碰撞设置（是否通知的设置依然有效）。

在`EventListenerPhysicsContact`里有四个碰撞回调函数，他们分别是`onContactBegin`，`onContactPreSolve`，`onContactPostSolve`和`onContactSeperate`。

在碰撞刚发生时，`onContactBegin`会被调用，并且在此次碰撞中只会被调用一次。你可以通过返回true或者false来决定物体是否发生碰撞。你可以通过`PhysicsContact::setData()`来保存自己的数据以便用于后续的碰撞处理。需要注意的是，当`onContactBegin`返回flase时，`onContactPreSolve`和`onContactPostSolve`将不会被调用，但`onContactSeperate`必定会被调用。

`onContactPreSolve`发生在碰撞的每个step，你可以通过调用`PhysicsContactPreSolve`的设置函数来改变碰撞处理的一些参数设定，比如弹力，阻力等。同样你可以通过返回true或者false来决定物体是否发生碰撞。你还可以通过调用`PhysicsContactPreSolve::ignore()`来跳过后续的`onContactPreSolve`和`onContactPostSolve`回调事件通知（默认返回true）。

`onContactPostSolve`发生在碰撞计算完毕的每个step，你可以在此做一些碰撞的后续处理，比如摧毁某个物体等。

`onContactSeperate`发生在碰撞结束两物体分离时，同样只会被调用一次。它跟`onContactBegin`必定是成对出现的，所以你可以在此摧毁你之前通过`PhysicsContact::setData()`设置的用户数据。

## Demo

你可以在这里获取文章配套Demo：<https://github.com/Yangtb/newPhysics.git>

Demo基于 [cocos2d-x-3.0alpha1](http://cdn.cocos2d-x.org/cocos2d-x-3.0alpha1.zip), clone后放到引擎的projects（如果没有自行创建）文件夹下。

你也可以运行引擎自带的test-cpp下的PhysicsTest查看和学习物理集成的使用方式。
