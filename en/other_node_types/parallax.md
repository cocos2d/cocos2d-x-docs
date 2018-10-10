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
paraNode->addChild(top_layer, 2, Vec2(3.0f,2.5f), Vec2(200,800) );
{%- endcodetabs %}

OK, looks and feels familiar, right? Notice a few items! Each `Node` object that
was added is given a unique __z-order__ so that they stack on top of each other.
Also notice the additional 2 `Vec2` type parameters in the __addChild()__ call. These
are the __ratio__ and __offset__. These parameters can be thought of as the __ratio__
of speed to the parent `Node`.

It's hard to show a `ParallaxNode` in text, so please run the example __Programmer Guide Sample__ code to see this in action!
