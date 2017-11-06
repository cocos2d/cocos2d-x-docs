<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Physics
Your game is coming along nicely. You have `Sprite` objects, gameplay mechanics
and your coding efforts are paying off. You are starting to feel like your game
is playable. What do you do when you realize your game needs to simulate real
world situations? You know, __collision detection__, __gravity__, __elasticity__ and
__friction__. Yes, you guessed it! This chapter is on __physics__ and the use of a
__physics engine__. Let's explore the *when*, *wheres* and *whys* of using a
__physics engine__.

### Physics is scary, do I really need it? Please tell me no!
Please don't run away there are no physics monsters under your bed! Your needs
might be simple enough to not need to use a __physics engine__. Perhaps a combination
of using a `Node` objects __update()__ function, `Rect` objects and a combination
of the __containsPoint()__ or __intersectsRect()__ functions might be enough for
you? Example:

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

This mechanism works for __very simple__ needs, but doesn't scale. What if you had
100 `Sprite` objects all continuously updating to check for intersections with
other objects? It could be done but the the CPU usage and __framerate__ would suffer
severely. Your game would be unplayable. A __physics engine__ solves these concerns
for us in a scalable and CPU friendly way. Even though this might look foreign,
let's take a look at a simple example and then nut and bolt the example,
terminology and best practice together.

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

Even though this example is simple, it looks complicated and scary. It really
isn't if we look closely. Here are the steps that are happening:

  * A `PhysicsBody` object is created.
  * A `Sprite` object is created.
  * The `Sprite` object applies the properties of the `PhysicsBody` object.
  * A listener is created to respond to an __onContactBegin()__ event.

Once we look step by step the concept starts to make sense.
