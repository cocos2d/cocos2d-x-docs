## Sprite Manipulation
After creating a `Sprite` you will have access to a variety of properties it
has that can be manipulated.

Given:

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png");
{%- endcodetabs %}

![](sprites-img/i1.png "")

### Anchor Point and Position
__Anchor Point__ is a point that you set as a way to specify what part of
the `Sprite` will be used when setting its position. __Anchor Point__ affects
only properties that can be transformed. This includes __scale__, __rotation__,
__skew__. This excludes __color__ and __opacity__. The __anchor point__ uses a
bottom left coordinate system. This means that when specifying X and Y coordinate
values you need to make sure to start at the bottom left hand corner to do your
calculations. By default, all `Node` objects have a default __anchor point__ of
is __(0.5, 0.5)__.

Setting the __anchor point__ is easy:

{% codetabs name="C++", type="cpp" -%}
// DEFAULT anchor point for all Sprites
mySprite->setAnchorPoint(0.5, 0.5);

// bottom left
mySprite->setAnchorPoint(0, 0);

// top left
mySprite->setAnchorPoint(0, 1);

// bottom right
mySprite->setAnchorPoint(1, 0);

// top right
mySprite->setAnchorPoint(1, 1);
{%- endcodetabs %}

To represent this visually:

![](sprites-img/i6.png "")

### Sprite properties effected by anchor point
Using __anchor point__ effects only properties that can be transformed. This includes
__scale__, __rotation__, __skew__.

#### Position
A __sprite's__ position is affected by its __anchor point__ as it is this point
that is used as a starting point for positioning. Let's visually look at how this
happens. Notice the colored line and where the _sprite's_ position is in relation
to it. Notice, as we change the __anchor point__ values, the _sprite's_ position
changes. It is important to note that all it took was changing the __anchor point__
value. We did not use a `setPosition()` statement to achieve this:

![](sprites-img/i9.png "")

There are more ways to set position than just __anchor point__. `Sprite` objects
can also be set using the `setPosition()` method.

{% codetabs name="C++", type="cpp" -%}
// position a sprite to a specific position of x = 100, y = 200.
mySprite->setPosition(Vec2(100, 200));
{%- endcodetabs %}

#### Rotation
Changes the __sprite's__ rotation, by a positive or negative number of degrees.
A positive value rotates the `Sprite` object clockwise, while a negative value
rotates the `Sprite` object counter-clockwise. The default value is __0__.

{% codetabs name="C++", type="cpp" -%}
// rotate sprite by +20 degrees
mySprite->setRotation(20.0f);

// rotate sprite by -20 degrees
mySprite->setRotation(-20.0f);

// rotate sprite by +60 degrees
mySprite->setRotation(60.0f);

// rotate sprite by -60 degrees
mySprite->setRotation(-60.0f);
{%- endcodetabs %}

![](sprites-img/i8.png "")

#### Scale
Changes the __sprite's__ scale, either by x, y or uniformly for both x and y.
The default value is 1.0 for both x and y.

{% codetabs name="C++", type="cpp" -%}
// increases X and Y size by 2.0 uniformly
mySprite->setScale(2.0);

// increases just X scale by 2.0
mySprite->setScaleX(2.0);

// increases just Y scale by 2.0
mySprite->setScaleY(2.0);
{%- endcodetabs %}

![](sprites-img/i5.png "")

#### Skew
Changes the __sprite's__ skew, either by x, y or uniformly for both x and y.
The default value is 0,0 for both x and y.

{% codetabs name="C++", type="cpp" -%}
// adjusts the X skew by 20.0
mySprite->setSkewX(20.0f);

// adjusts the Y skew by 20.0
mySprite->setSkewY(20.0f);
{%- endcodetabs %}

![](sprites-img/i7.png "")

### Sprite properties not affected by anchor point
There are a few properties of `Sprite` objects that are not affected by
__anchor point__. Why? Because they only change superficial qualities like __color__ and __opacity__.

#### Color
Changes the _sprite's_ color. This is done by passing in a `Color3B` object.
`Color3B` objects are __RGB__ values. We haven't encountered `Color3B` yet but
it is simply an object that defines an __RGB color__. An __RGB color__ is a 3 byte
value from 0 - 255. Cocos2d-x also provides pre-defined colors that you can pick
from. Using these will be a bit faster since they are pre-defined. A few examples:
`Color3B::White` and `Color3B::Red`.

{% codetabs name="C++", type="cpp" -%}
// set the color by passing in a pre-defined Color3B object.
mySprite->setColor(Color3B::WHITE);

// Set the color by passing in a Color3B object.
mySprite->setColor(Color3B(255, 255, 255)); // Same as Color3B::WHITE
{%- endcodetabs %}

![](sprites-img/i10.png "")

#### Opacity
Changes the _sprite's_ opacity by the specified value. An opaque object is not
transparent at all. This property expects a value from 0 to 255, where 255 means
fully opaque and 0 means fully transparent. Think: __zero opacity means invisible__,
and you'll always understand how this works. The default value is 255 (fully opaque).

{% codetabs name="C++", type="cpp" -%}
// Set the opacity to 30, which makes this sprite 11.7% opaque.
// (30 divided by 256 equals 0.1171875...)
mySprite->setOpacity(30);
{%- endcodetabs %}

![](sprites-img/i11.png "")
