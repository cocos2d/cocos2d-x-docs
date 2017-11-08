# 碰撞

你是否看到过车祸？是否跟什么物体相撞过？就像车的相撞一样，物理刚体对象也可以互相碰撞，当它们互相接触的时候，就认为发生了碰撞。当碰撞发生时，它可以被完全忽略，也可以触发一系列事件。

## 碰撞筛选

碰撞筛选允许你启用或者阻止形状之间碰撞的发生，引擎支持使用类型，组位掩码来筛选碰撞。

Cocos2d-x 有 32 个支持的碰撞类型，对于每个形状都可以指定其所属的类型。还可以指定有哪些类型可以与这个形状进行碰撞，这些事通过掩码来完成的。例如：

{% codetabs name="C++", type="cpp" -%}
auto sprite1 = addSpriteAtPosition(Vec2(s_centre.x - 150,s_centre.y));
sprite1->getPhysicsBody()->setCategoryBitmask(0x02);    // 0010
sprite1->getPhysicsBody()->setCollisionBitmask(0x01);   // 0001

sprite1 = addSpriteAtPosition(Vec2(s_centre.x - 150,s_centre.y + 100));
sprite1->getPhysicsBody()->setCategoryBitmask(0x02);    // 0010
sprite1->getPhysicsBody()->setCollisionBitmask(0x01);   // 0001

auto sprite2 = addSpriteAtPosition(Vec2(s_centre.x + 150,s_centre.y),1);
sprite2->getPhysicsBody()->setCategoryBitmask(0x01);    // 0001
sprite2->getPhysicsBody()->setCollisionBitmask(0x02);   // 0010

auto sprite3 = addSpriteAtPosition(Vec2(s_centre.x + 150,s_centre.y + 100),2);
sprite3->getPhysicsBody()->setCategoryBitmask(0x03);    // 0011
sprite3->getPhysicsBody()->setCollisionBitmask(0x03);   // 0011

}
{%- endcodetabs %}

你可以通过检查比较，类型和掩码来确定碰撞的发生：

{% codetabs name="C++", type="cpp" -%}
if ((shapeA->getCategoryBitmask() & shapeB->getCollisionBitmask()) == 0
   || (shapeB->getCategoryBitmask() & shapeA->getCollisionBitmask()) == 0)
{
   // shapes can't collide
   ret = false;
}
{%- endcodetabs %}

![](physics-img/CollisionFiltering.gif )

碰撞组允许你指定一个完整的组索引，你可以让具有相同组索引的形状总是一直碰撞（正索引）或者永不碰撞（负索引和零索引）。对于组索引不同的形状。可以根据类型和掩码进行筛选。换句话说，组筛选比类型筛选具有更高的优先级。

## 连接/关节

回想一下之前提到的术语，关节是把接触点连接在一起的一种方式，就好像人体的关节是把人体的不同部位连接在一起。关节连接了不同的刚体，刚体可以是静态的，每一个关节类都是 `PhysicsJoint` 的子类，你可以通过设置 `joint->setCollisionEnable(false)` 来避免相互关联的刚体互相碰撞。很多关节的定义需要你提供一些几何数据。大多关节都是通过锚点来定义的，其余少数关节有各自的定义方式。

- PhysicsJointFixed：固定点关节，将两个刚体固定在一个特定的点上。如果要创建一些后续会断裂的复合刚体，使用固定关节是非常合适的。
- PhysicsJointLimit：限制关节，限制了两个刚体的最大距离，就好像它们被绳子连接了一样
- PhysicsJointPin：钉式关节，可以让两个刚体独立的围绕一个锚点进行旋转，就好像被钉在一起了一样
- PhysicsJointDistance：固定距离关节，设定了两个刚体间的固定距离
- PhysicsJointSpring：弹簧关节，就好像将一个弹簧连接了两个刚体，刚体会互相牵引和弹开
- PhysicsJointRotarySpring：弹簧旋转关节，类似弹簧关节，只是两个刚体位置的互相影响变成了旋转的互相影响
- PhysicsJointRotaryLimit：限制旋转关节，类似限制关节，只是两个刚体位置的互相影响变成了旋转的互相影响
- PhysicsJointRatchet：与套筒扳手的工作类似
- PhysicsJointGear：传动关节，使一对刚体的角速度比值保持不变
- PhysicsJointMotor：马达关节，使一对刚体的相对角速度保持不变

![](physics-img/joints.PNG )

## 碰撞检测

Contacts are objects created by the __physics engine__ to manage the collision
between two shapes. __Contact__ objects are not created by the user, they are
created automatically. There are a few terms associated with contacts.

 >-contact point: A contact point is a point where two shapes touch.

 >-contact normal: A contact normal is a unit vector that points from one shape
 to another.

You can get the `PhysicsShape` from a __contact__. From those you can get the bodies.

{% codetabs name="C++", type="cpp" -%}
bool onContactBegin(PhysicsContact& contact)
{
    auto bodyA = contact.getShapeA()->getBody();
    auto bodyB = contact.getShapeB()->getBody();
    return true;
}
{%- endcodetabs %}

You can get access to __contacts__ by implementing a __contact listener__. The __contact
listener__ supports several events: __begin__, __pre-solve__, __post-solve__ and __separate__.

  >-begin: Two shapes just started touching for the first time this step. Return
true from the callback to process the collision normally or false to cause physics
engine to ignore the collision entirely. If you return false, the _preSolve()_ and
_postSolve()_ callbacks will never be run, but you will still receive a separate
event when the shapes stop overlapping.

 >-pre-solve: Two shapes are touching during this step. Return false from the callback
 to make physics engine ignore the collision this step or true to process it normally.
 Additionally, you may override collision values using _setRestitution()_, _setFriction()_
 or _setSurfaceVelocity()_ to provide custom restitution, friction, or surface velocity
 values.

 >-post-solve: Two shapes are touching and their collision response has been
 processed.

 >-separate: Two shapes have just stopped touching for the first time this step.

You also can use `EventListenerPhysicsContactWithBodies`,
`EventListenerPhysicsContactWithShapes`, `EventListenerPhysicsContactWithGroup`
to listen for the event you're interested with bodies, shapes or groups. Besides this you
also need to set the physics contact related bitmask value, as the contact event
won't be received by default, even if you create the relative __EventListener__.

For example:

{% codetabs name="C++", type="cpp" -%}
bool init()
{
    //create a static PhysicsBody
    auto sprite = addSpriteAtPosition(s_centre,1);
    sprite->setTag(10);
    sprite->getPhysicsBody()->setContactTestBitmask(0xFFFFFFFF);
    sprite->getPhysicsBody()->setDynamic(false);

    //adds contact event listener
    auto contactListener = EventListenerPhysicsContact::create();
    contactListener->onContactBegin = CC_CALLBACK_1(PhysicsDemoCollisionProcessing::onContactBegin, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(contactListener, this);

    schedule(CC_SCHEDULE_SELECTOR(PhysicsDemoCollisionProcessing::tick), 0.3f);
    return true;

    return false;
}

void tick(float dt)
{
    auto sprite1 = addSpriteAtPosition(Vec2(s_centre.x + cocos2d::random(-300,300),
      s_centre.y + cocos2d::random(-300,300)));
    auto physicsBody = sprite1->getPhysicsBody();
    physicsBody->setVelocity(Vec2(cocos2d::random(-500,500),cocos2d::random(-500,500)));
    physicsBody->setContactTestBitmask(0xFFFFFFFF);
}

bool onContactBegin(PhysicsContact& contact)
{
    auto nodeA = contact.getShapeA()->getBody()->getNode();
    auto nodeB = contact.getShapeB()->getBody()->getNode();

    if (nodeA && nodeB)
    {
        if (nodeA->getTag() == 10)
        {
            nodeB->removeFromParentAndCleanup(true);
        }
        else if (nodeB->getTag() == 10)
        {
            nodeA->removeFromParentAndCleanup(true);
        }
    }

    //bodies can collide
    return true;
}
{%- endcodetabs %}

![](physics-img/CollisionProcessing.gif)
