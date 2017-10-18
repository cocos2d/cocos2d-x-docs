div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

### Creating a Sprite from SpriteFrameCache
This creates a `Sprite` by pulling it from the `SpriteFrameCache`.

{% codetabs name="C++", type="cpp" -%}
// Our .plist file has names for each of the sprites in it.  We'll grab
// the sprite named, "mysprite" from the sprite sheet:
auto mysprite = Sprite::createWithSpriteFrameName("mysprite.png");
{%- language name="JavaScript", type="js" -%}
// Our .plist file has names for each of the sprites in it.  We'll grab
// the sprite named, "Blue_Front1" from the sprite sheet:
var mysprite = cc.Sprite.createWithSpriteFrameName(res.mySprite_png);
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
{%- language name="JavaScript", type="js" -%}

// this is equivalent to the previous example,
// but it is created by retrieving the SpriteFrame from the cache.
var newspriteFrame = cc.SpriteFrameCache.getSpriteFrameByName(res.sprites_plist);
var newSprite = cc.Sprite.createWithSpriteFrame(newspriteFrame);

{%- endcodetabs %}

![](sprites-img/i3.png "")
