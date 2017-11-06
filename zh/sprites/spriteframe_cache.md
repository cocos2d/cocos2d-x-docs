# 使用精灵缓存

精灵缓存是 Cocos2d-x 为了提高精灵的访问速度，提供的一个精灵的缓存机制。

我们可以创建一个精灵并把精灵放到精灵的缓存对象 __`SpriteFrameCache`__ 中：

{% codetabs name="C++", type="cpp" -%}
// Our .plist file has names for each of the sprites in it.  We'll grab
// the sprite named, "mysprite" from the sprite sheet:
auto mysprite = Sprite::createWithSpriteFrameName("mysprite.png");
{%- language name="JavaScript", type="js" -%}
// Our .plist file has names for each of the sprites in it.  We'll grab
// the sprite named, "Blue_Front1" from the sprite sheet:
var mysprite = cc.Sprite.createWithSpriteFrameName(res.mySprite_png);
{%- endcodetabs %}

![](../../en/sprites/sprites-img/i3.png "")

相对的，我们也可以从精灵的缓存对象 `SpriteFrameCache` 访问一个精灵，访问方法是先从缓存对象中获取对应的 `SpriteFrame`，然后从 `SpriteFrame`创建精灵，方法：

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

![](../../en/sprites/sprites-img/i3.png "")
