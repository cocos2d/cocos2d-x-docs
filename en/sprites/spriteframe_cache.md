## Creating a Sprite from SpriteFrameCache
This creates a `Sprite` by pulling it from the `SpriteFrameCache`.

{% codetabs name="C++", type="cpp" -%}
// Our .plist file has names for each of the sprites in it.  We'll grab
// the sprite named, "mysprite" from the sprite sheet:
auto mysprite = Sprite::createWithSpriteFrameName("mysprite.png");
{%- endcodetabs %}

![](sprites-img/i3.png "")

### Creating a Sprite from a SpriteFrame
Another way to create the same `Sprite` is by fetching the `SpriteFrame` from the
`SpriteFrameCache`, and then creating the `Sprite` with the `SpriteFrame`. Example:

{% codetabs name="C++", type="cpp" -%}
// this is equivalent to the previous example,
// but it is created by retrieving the SpriteFrame from the cache.
auto newspriteFrame = SpriteFrameCache::getInstance()->getSpriteFrameByName("Blue_Front1.png");
auto newSprite = Sprite::createWithSpriteFrame(newspriteFrame);
{%- endcodetabs %}

![](sprites-img/i3.png "")
