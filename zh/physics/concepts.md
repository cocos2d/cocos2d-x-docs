# 术语和概念

To better understand all the details of a __physics engine__ you should understand
the following terms and concepts:

为了更好的理解物理引擎，需要先了解下面的一些术语，概念。

### Bodies

A `PhysicsBody` holds the physical properties of an object. These include __mass__,
__position__, __rotation__, __velocity__ and __damping__. `PhysicsBody` objects
are the backbone for shapes. A `PhysicsBody` does not have a shape until you attach
a shape to it.

###Material
Materials describe material attributes：

  >-density：It is used to compute the mass properties of the parent body.

  >-friction：It is used to make objects slide along each other realistically.

  >-restitution：It is used to make objects bounce. The restitution value is
 usually set to be between 0 and 1. 0 means no bouncing while 1 means perfect
 bouncing.

###Shapes
Shapes describe collision geometry. By attaching shapes to bodies, you define a
body’s shape. You can attach as many shapes to a single body as you need in order
to define a complex shape. Each shape relates to a `PhysicsMaterial` object and
contains the following attributes: __type__, __area__, __mass__, __moment__, __offset__ and
__tag__. Some of these you might not be familiar with:

  >-_type_：describes the categories of shapes, such as circle, box, polygon, etc.

  >-_area_: used to compute the mass properties of the body. The density and area
gives the mass.

  >-_mass_: the quantity of matter that a body contains, as measured by its
acceleration under a given force or by the force exerted on it by a gravitational
field.

  >-_moment_: determines the torque needed for a desired angular acceleration.

  >-_offset_: offset from the body’s center of gravity in body local coordinates.

  >-_tag_: used to identify the shape easily for developers.​ You probably remember
that you can assign all `Node` objects a tag for identification and easy access.

We describe the various __shapes__ as:
  >-`PhysicsShape`: Shapes implement the `PhysicsShape` base class.

  >-`PhysicsShapeCircle`: Circles are solid. You cannot make a hollow circle
 using the circle shape.

  >-`PhysicsShapePolygon`: Polygon shapes are solid convex polygons.

  >-`PhysicsShapeBox`: Box shape is one kind of convex polygon.

  >-`PhysicsShapeEdgeSegment`: A segment shape.

  >-`PhysicsShapeEdgePolygon`: Hollow polygon shapes. A edge-polygon shape consists
 of multiple segment shapes.

  >-`PhysicsShapeEdgeBox`：Hollow box shapes. A edge-box shape consists of four
 segment shapes.

  >-`PhysicsShapeEdgeChain`: The chain shape provides an efficient way to connect
 many edges together.

###Contacts/Joints
__Contacts__ and __joint__ objects describe how bodies are attached to each other.

###World
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
