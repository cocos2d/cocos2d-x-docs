## Physics is scary, do I really need it? Please tell me no!
Please don't run away there are no physics monsters under your bed! Your needs might be simple enough to not need to use a __physics engine__. Perhaps a combination of using a `Node` objects __update()__ function, `Rect` objects and a combination of the __containsPoint()__ or __intersectsRect()__ functions might be enough for you? Example:

```cpp
void update(float dt)
{
  auto p = touch->getLocation();
  auto rect = this->getBoundingBox();

  if(rect.containsPoint(p))
  {
      // do something, intersection
  }
}
```

This mechanism works for __very simple__ needs, but doesn't scale. What if you had 100 `Sprite` objects all continuously updating to check for intersections with
other objects? It could be done but the the CPU usage and __framerate__ would suffer severely. Your game would be unplayable. A __physics engine__ solves these concerns
for us in a scalable and CPU friendly way. Even though this might look foreign, let's take a look at a simple example and then nut and bolt the example, terminology and best practice together.

```cpp
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
```

Even though this example is simple, it looks complicated and scary. It really isn't if we look closely. Here are the steps that are happening:

  * A `PhysicsBody` object is created.
  * A `Sprite` object is created.
  * The `Sprite` object applies the properties of the `PhysicsBody` object.
  * A listener is created to respond to an __onContactBegin()__ event.

Once we look step by step the concept starts to make sense.
