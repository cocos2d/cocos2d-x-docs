# 术语和概念

为了更好的理解物理引擎，需要先了解下面的一些术语，概念。

## 刚体(Bodies)

刚体描述了抽象物体的物理属性，包括：质量、位置、旋转角度、速度和阻尼。Cocos2d-x 中用 `PhysicsBody` 对象表示刚体。当 _Shape_ 和 `PhysicsBody` 关联后，`PhysicsBody` 对象才具有几何形状，未关联 _Shape_， `PhysicsBody` 只是一个抽象物体的属性集。

## 材质(Material)

材质描述了抽象物体的材料属性：

  >- 密度：用于计算物体的质量
  >- 摩擦：用于模拟物体间的接触滑动
  >- 恢复系数：模拟物体的反弹的系数，系数一般设为 0 到 1 之间。0 代表不反弹，1 代表完全反弹。

## 形状(Shape)

形状(Shape) 描述了抽象物体的几何属性，将 _Shape_ 关联到刚体，刚体就具有了形状。如果需要刚体具有复杂的形状，可以为它关联多个 _Shape_，每个 _Shape_ 都与一个 `PhysicsMaterial` 相关，并且拥有以下属性：type（种类）, area（面积）, mass（质量）, moment（扭矩）, offset（重心偏移量）和 tag（标签）。其中有一些你可能还不熟悉，我们来逐一介绍：

  >- type（种类）：描述了形状的类别，如圆形，矩形，多边形等
  >- area（面积）：用于计算刚体的质量，密度和体积决定了刚体的质量
  >- mass（质量）：刚体的质量，影响：物体在给定的力下获得的加速度大小，物体在一个引力场中物体受到力的大小
  >- moment（扭矩）：决定了获得特定角加速度所需要的扭矩
  >- offset（重心偏移量）：在刚体的当前坐标中，相对于刚体重心的偏移量
  >- tag（标签）：_Shape_ 对象的一个标识，你可能还记得，所有的 Node 对象都可以被分配一个 tag，以进行辨识，实现更容易的访问。_Shape_ 对象的 tag 作用也一样。

Cocos2d-x 中预定义了这些形状：

  >- `PhysicsShape`：实现了 `PhysicsShape` 的基类
  >- `PhysicsShapeCircle`：实心的圆形，无法用 `PhysicsShapeCircle` 实现一个空心圆
  >- `PhysicsShapePolygon`：实心且外凸的多边形
  >- `PhysicsShapeBox`：矩形，它是一种特殊的外凸多边形
  >- `PhysicsShapeEdgeSegment`：表示一种线段.
  >- `PhysicsShapeEdgePolygon`：空心多边形，由多个线段构成的多边形边缘。
  >- `PhysicsShapeEdgeBox`：空心矩形，由四个线段组成的矩形边缘
  >- `PhysicsShapeEdgeChain`: 链形形状，它可以有效的把许多边缘连接起来

## 连接/关节

_连接(Contacts)_ 和 _关节(joint)_ 对象描述了刚体相互关联的方式。

## 世界(World)

A __world__ container is what your physics bodies are added to and where they are
simulated. You add __bodies__, __shapes__ and __constraints__ to a world and then
update the world as a whole. The __world__ controls how all of these items interact
together. Much of the interaction with the physics API will be with a `PhysicsWorld`
object.

There is a lot to remember here, keep these terms handy to refer back to them as
needed.

##Physics World and Physics Body

###PhysicsWorld
A `PhysicsWorld` object is the core item used when simulating physics. Just like
the world we live in, a `PhysicsWorld` has a lot of things happening at once.
`PhysicsWorld` integrates deeply at the `Scene` level because of it's many facets.
Let's use a simple example that we can all relate to. Does your residence have a
kitchen? Think of this as your __physics world__! Now your world has `PhysicsBody`
objects, like food, knives, appliances! These bodies interact with each other
inside the world. These objects touch and also react to those touches. Example:
use a knife to cut food and put it in an appliance. Does the knife cut
the food? Maybe. Maybe not. Perhaps it isn't the correct type of knife for the
job.

You can create a `Scene` that contains a `PhysicsWorld` just by calling the function
`initWithPhysics()` in your `Scene`. Your `init()` function should have:

{% codetabs name="C++", type="cpp" -%}
if( !Scene::initWithPhysics() )
{

}
{%- endcodetabs %}

Every `PhysicsWorld` has properties associated with it:
 >-gravity: Global gravity applied to the world. Defaults to Vec2(0.0f, -98.0f).

 >-speed: Set the speed of physics world, speed is the rate at which the simulation
 executes. Defaults to 1.0.

 >-updateRate: set the update rate of physics world, update rate is the value of
 EngineUpdateTimes/PhysicsWorldUpdateTimes.

 >-substeps: set the number of substeps in an update of the physics world.

The process of updating a `PhysicsWorld` is called __stepping__. By default, the
`PhysicsWorld` __updates through time__ automatically. This is called __auto stepping__.
It automatically happens for you, each frame. You can disable __auto steping__ of
the `PhysicsWorld` by setting __setAutoStep(false)__. If you do this, you would __step__
the `PhysicsWorld` manually by setting __step(time)__. __Substeps__ are used
to step the `PhysicsWorld` forward multiple times using a more precise time
increment than a single frame. This allows for finer grained control of the
__stepping__ process including more fluid movements.

###PhysicsBody
`PhysicsBody` objects have __position__ and __velocity__. You can apply __forces__,
__movement__, __damping__ and __impulses__ (as well as more) to `PhysicsBody` objects.
`PhysicsBody` can be __static__ or __dynamic__. A __static__ body does not move under
simulation and behaves as if it has infinite __mass__. A __dynamic__ body is fully
simulated. They can be moved manually by the user, but normally they move according
to forces. A dynamic body can collide with all body types. `Node` provides
__setPhysicsBody()__ to associate a `PhysicsBody` to a `Node` object.

Lets create a static and 5 dynamic `PhysicsBody` objects that are a box shape:

{% codetabs name="C++", type="cpp" -%}
auto physicsBody = PhysicsBody::createBox(Size(65.0f, 81.0f),
						PhysicsMaterial(0.1f, 1.0f, 0.0f));
physicsBody->setDynamic(false);

//create a sprite
auto sprite = Sprite::create("whiteSprite.png");
sprite->setPosition(s_centre);
addChild(sprite);

//apply physicsBody to the sprite
sprite->addComponent(physicsBody);

//add five dynamic bodies
for (int i = 0; i < 5; ++i)
{
    physicsBody = PhysicsBody::createBox(Size(65.0f, 81.0f),
    				PhysicsMaterial(0.1f, 1.0f, 0.0f));

    //set the body isn't affected by the physics world's gravitational force
    physicsBody->setGravityEnable(false);

    //set initial velocity of physicsBody
    physicsBody->setVelocity(Vec2(cocos2d::random(-500,500),
    			cocos2d::random(-500,500)));
    physicsBody->setTag(DRAG_BODYS_TAG);

    sprite = Sprite::create("blueSprite.png");
    sprite->setPosition(Vec2(s_centre.x + cocos2d::random(-300,300),
    			s_centre.y + cocos2d::random(-300,300)));
    sprite->addComponent(physicsBody);

    addChild(sprite);
}
{%- endcodetabs %}

The result is a stationary `PhysicsBody` with 5 additional `PhysicsBody` objects
colliding around it.

![](physics-img/CorrelationSprite.gif)
