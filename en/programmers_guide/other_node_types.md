# Other Node Types
You are using `Sprite`, `Label` and `Action` objects in your game and it is making
progress. Besides the basic `Node` types described in previous chapters, Cocos2d-x also
provides more advanced `Node` types to help build special functionality. Perhaps
you want to make a __tile-based__ game? Or maybe a __2d side scroller__? Or maybe you
want to add particle effects to your game? Cocos2d-x provides `Node` objects to
help you accomplish these goals!

## TileMap
__TileMaps__ are maps made up of __tiles__. Each _tile_ can have independent behavior.
__TileMaps__ are stored in an XML-based map format called `TML`. `TMX` was originally
designed for tile-based maps but is also suitable for more generic game levels
due to its support for various object types. `TMX` objects are easy to create:

{% codetabs name="C++", type="cpp" -%}
// reading in a tiled map.
auto map = TMXTiledMap::create("TileMap.tmx");
addChild(map, 0, 99); // with a tag of '99'
{%- endcodetabs %}

Tile-based maps can have many layers, determined by a
__z-order__. You can access a specific layer by it's name:

{% codetabs name="C++", type="cpp" -%}
// how to get a specific layer
auto map = TMXTiledMap::create("TileMap.tmx");
auto layer = map->getLayer("Layer0");
auto tile = layer->getTileAt(Vec2(1, 63));
{%- endcodetabs %}

Each tile has a unique position and id. This makes it very easy to cherry pick
specific tiles. You can access any tile by its id:

{% codetabs name="C++", type="cpp" -%}
// to obtain a specific tiles id
unsigned int gid = layer->getTileGIDAt(Vec2(0, 63));
{%- endcodetabs %}

Example tiled-map layouts:

![](other_node_types-img/tilemap1.png "timemap1")

![](other_node_types-img/tilemap2.png "timemap2")

How do you make a tiled-map? There are many tools that do this. [Tiled](http://mapeditor.org)
is a popular tool. It is actively developed and has a great user community. The
screen-shots above are actual __Tiled__ projects.

## Particle System
Perhaps your game needs effects like burning fire, spell casting visuals or explosions.
How would you make such complex effects? Is it even possible? Yes, it is. Using
a __particle system__. The term _particle system_ refers to a computer graphics
technique that uses a large number of very small sprites or other graphic objects
to simulate certain kinds of __fuzzy__ phenomena, which are otherwise very hard
to reproduce with conventional rendering techniques. Some realistic examples
might include highly chaotic systems, natural phenomena, or processes caused by
chemical reactions. Here are a few examples of __particle effects__:

![](other_node_types-img/particle1.png "snow") ![](basic_concepts-img/smallSpacer.png "") ![](other_node_types-img/particle3.png "sun")

### Tools for creating Particle Effects
Even though you can always create _particle effects_ by hand, massaging each
property to your liking. There are several third party tools for creating
_particle effects_. A few of these tools are:

1. [Particle Designer](https://71squared.com/particledesigner): A very powerful particle effects editor on Mac
2. [V-play particle editor](http://v-play.net/2014/02/v-play-particle-editor-for-cocos2d-and-v-play/): A cross-platform particle editor for Cocos2d-x
3. [Particle2dx](http://www.effecthub.com/particle2dx): An online web particle designer

These tools usually export a `.plist` file that you can read in with Cocos2d-x to
use your creation inside your game. Just like with all of the other classes we
have worked with so far we use the `create()` method:

{% codetabs name="C++", type="cpp" -%}
// create by plist file
auto particleSystem = ParticleSystem::create("SpinningPeas.plist");
{%- endcodetabs %}

### Built-In Particle Effects
Are you ready to add _particle effects_ to your game? We hope so! Are you not yet
comfortable with creating custom _particle effects_? For ease of convenience there
are a number of built-in _particle effects_ that you can choose from. Take a look
at this list:

  >-ParticleFire: Point particle system. Uses Gravity mode.

  >-ParticleFireworks: Point particle system. Uses Gravity mode.

  >-ParticleSun: Point particle system. Uses Gravity mode.

  >-ParticleGalaxy: Point particle system. Uses Gravity mode.

  >-ParticleFlower: Point particle system. Uses Gravity mode.

  >-ParticleMeteor: Point particle system. Uses Gravity mode.

  >-ParticleSpiral: Point particle system. Uses Gravity mode.

  >-ParticleExplosion: Point particle system. Uses Gravity mode.

  >-ParticleSmoke: Point particle system. Uses Gravity mode.

  >-ParticleSnow: Point particle system. Uses Gravity mode.

  >-ParticleRain: Point particle system. Uses Gravity mode.

Using `ParticleFireworks` as an example, you can use the built-in effects easily:

{% codetabs name="C++", type="cpp" -%}
auto emitter = ParticleFireworks::create();

addChild(emitter, 10);
{%- endcodetabs %}

The result is a _particle effect_ that looks something like:

![](other_node_types-img/particle2.png "particle fireworks")

But what do you do if your __particle effect__ isn't quite the way you want?
That's right, you can manually manipulate it! Let's take the same fireworks example
above and manipulate it even further by manually changing its properties:

{% codetabs name="C++", type="cpp" -%}
auto emitter = ParticleFireworks::create();

// set the duration
emitter->setDuration(ParticleSystem::DURATION_INFINITY);

// radius mode
emitter->setEmitterMode(ParticleSystem::Mode::RADIUS);

// radius mode: 100 pixels from center
emitter->setStartRadius(100);
emitter->setStartRadiusVar(0);
emitter->setEndRadius(ParticleSystem::START_RADIUS_EQUAL_TO_END_RADIUS);
emitter->setEndRadiusVar(0);    // not used when start == end

addChild(emitter, 10);
{%- endcodetabs %}

<!--### Creating Particles
Building your own _particle effects_ is a rather complex process of setting
properties to achieve the desired effects. There are a lot of properties so let's
get familiar with some of the most basic ones. Don't worry, just keep this as a
reference to refer back to! Basic _particle_ properties include:

  >-startSize: Start size of the particles in pixels.

  >-endSize: Use kCCParticleStartSizeEqualToEndSize if you want that the start size == end size.

  >-startColor: (a ccColor4F).

  >-endColor: (a ccColor4F).

  >-life: time to live of the particles in seconds.

  >-angle: (a float). Starting degrees of the particle.

  >-positon: (a Vec2).

  >-centerOfGravity: (a Point).

Besides the properties each _particle_ has, the _particle system_ itself also has
properties that can be changed to achieve your desired effects. Some of these
include:

  >-emissionRate: How many particle are emitted per second?

  >-duration: How many seconds does the particle system live? Use kCCParticleDurationInfinity for infinity.

  >-blendFunc: The OpenGL blending function used for the system. (a ccBlendFunc).

  >-positionType: Use kCCPositionTypeFree (default one) for moving particles freely.
  Or use kCCPositionTypeGrouped to move them in a group.

  >-texture: The texture used for the particles. (a Texture2D).

### Particle System Modes
_Particle systems_ have two modes of operation. _Gravity Mode_ and _Radius Mode_.

#### Gravity Mode
_Gravity Mode_ lets particles fly toward or away from a center point. It's strength
is that it allows very dynamic, organic effects.

![](other_node_types-img/particle6.png "Gravity Mode")

_Gravity Mode_ only has a few properties that you can change. They are:

  >-gravity: The gravity of the particle system.

  >-speed: The speed at which the particles are emitted.

  >-speedVar: The speed variance.

  >-tangencialAccel: The tangential acceleration of the particles.

  >-tangencialAccelVar: The tangential acceleration variance.

  >-radialAccel: The radial acceleration of the particles.

  >-radialAccelVar: The radial acceleration variance.

#### Radius Mode
_Radius Mode_ causes particles to rotate in a circle. It also allows you to create
spiral effects with particles either rushing inward or rotating outward.

![](other_node_types-img/particle5.png "Radius Mode")

_Radius Mode_ only has a few properties that you can change. They are:

  >-startRadius: The starting radius of the particles

  >-startRadiusVar: The starting radius variance

  >-endRadius: The ending radius of the particles.

  >-endRadiusVar: The ending radius variance

  >-rotatePerSecond: Number of degrees to rotate a particle around the source pos per second.

  >-rotatePerSecondVar: Number of degrees variance.

This all sounds really complicated but the fact that the code is simple helps to
clarify these concepts. Let's take a look at an example to tie everything together:
```cpp
//Create by plist file
auto particleSystem = ParticleSystem::create("SpinningPeas.plist");

// set the duration
particleSystem->setDuration(ParticleSystem::DURATION_INFINITY);

// radius mode
particleSystem->setEmitterMode(ParticleSystem::Mode::RADIUS);

// radius mode: 100 pixels from center
particleSystem->setStartRadius(100);
particleSystem->setStartRadiusVar(0);
particleSystem->setEndRadius(ParticleSystem::START_RADIUS_EQUAL_TO_END_RADIUS);
particleSystem->setEndRadiusVar(0);    // not used when start == end

// radius mode: degrees per second
// 45 * 4 seconds of life = 180 degrees
particleSystem->setRotatePerSecond(45);
particleSystem->setRotatePerSecondVar(0);
```
![](other_node_types-img/particle4.png)

** JASON - Replace the above screenshot with example from chapter 7 demo code
-->
## Parallax
A `Parallax` Node is a special `Node` type that simulates a __parallax scroller__.
What did you say? A *para*.. what? Yes, __parallax__ Simply put you can consider
a `ParallaxNode` to be a __special effect__ that makes it appear that the position
or direction of an object appears to differ when viewed from different positions.
Simple every day examples include looking through the viewfinder and the lens of
a camera. You can think of many games that function this way, Super Mario Bros
being a classic example. `ParallaxNode` objects can be moved around by a `Sequence`
and  also manually by mouse, touch, accelerometer or keyboard events.

Parallax nodes are a bit more complex than regular nodes. Why? Because they
require the use of multiple nodes to function. A `ParallaxNode` cannot function
by itself. You need at least 2 other `Node` objects to complete a `ParallaxNode`.
As usual, in true Cocos2d-x fashion, a `ParallaxNode` is easy to create:

{% codetabs name="C++", type="cpp" -%}
// create ParallaxNode
auto paraNode = ParallaxNode::create();
{%- endcodetabs %}

Since you need multiple `Node` objects, they too are easily added:

{% codetabs name="C++", type="cpp" -%}
// create ParallaxNode
auto paraNode = ParallaxNode::create();

// background image is moved at a ratio of 0.4x, 0.5y
paraNode->addChild(background, -1, Vec2(0.4f,0.5f), Vec2::ZERO);

// tiles are moved at a ratio of 2.2x, 1.0y
paraNode->addChild(middle_layer, 1, Vec2(2.2f,1.0f), Vec2(0,-200) );

// top image is moved at a ratio of 3.0x, 2.5y
paraNode->addChild(top layer, 2, Vec2(3.0f,2.5f), Vec2(200,800) );
{%- endcodetabs %}

OK, looks and feels familiar, right? Notice a few items! Each `Node` object that
was added is given a unique __z-order__ so that they stack on top of each other.
Also notice the additional 2 `Vec2` type parameters in the __addChild()__ call. These
are the __ratio__ and __offset__. These parameters can be thought of as the __ratio__
of speed to the parent `Node`.

It's hard to show a `ParallaxNode` in text, so please run the example __Programmer Guide Sample__ code to see this in action!
