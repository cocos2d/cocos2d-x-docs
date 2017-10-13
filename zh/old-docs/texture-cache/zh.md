#纹理缓存

#概述

在游戏中需要加载大量的纹理图片，这些操作都是很耗内存和资源的。

当游戏中有个界面用到的图片非常多，第一次点进这界面时速度非常慢（因为要加载绘制很多图片）出现卡顿，我们可以使用TextureCache提前异步加载纹理，等加载结束，进入到这个界面再使用这些图片速度就会非常快。

Texture2D: 纹理，即图片加载入内存后供CPU和GPU操作的贴图对象。  
TextureCache（纹理缓存），用于加载和管理纹理。一旦纹理加载完成，下次使用时可使用它返回之前加载的纹理，从而减少对GPU和CPU内存的占用。


##常用的方法

当你创建一个精灵，你一般会使用Sprite::create(pszFileName)。假如你去看Sprite::create(pszFileName)的实现方式，你将看到它将这个图片增加到纹理缓存中去了，

```
Sprite* Sprite::create(const std::string& filename)
{
    Sprite *sprite = new Sprite();
    if (sprite && sprite->initWithFile(filename))
    {
        sprite->autorelease();
        return sprite;
    }
    _SAFE_DELETE(sprite);
    return nullptr;
}

bool Sprite::initWithFile(const std::string& filename)
{
    ASSERT(filename.size()>0, "Invalid filename for sprite");

    Texture2D *texture = Director::getInstance()->getTextureCache()->addImage(filename);
    if (texture)
    {
        Rect rect = Rect::ZERO;
        rect.size = texture->getContentSize();
        return initWithTexture(texture, rect);
    }

    // don't release here.
    // when load texture failed, it's better to get a "transparent" sprite then a crashed program
    // this->release();
    return false;
}
```
上面代码显示在控制加载纹理。一旦这个纹理被加载了，在下一时刻就会返回之前加载的纹理引用，并且减少加载的时候瞬间增加的内存。（详细API请看TextureCache API）

##获取TextureCache

在3.0版本中，TextureCache不再作为单例模式使用。作为Director的成员变量，通过以下方式获取

```
Director::getInstance()->getTextureCache();
```


##获取纹理

如果文件名以前没有被加载时，它会创建一个新的Texture2D 对象，它会返回它。它将使用文件名作为key否则，它会返回一个引用先前加载的图像。
TextureCache屏蔽了加载纹理的许多细节；
addImage函数会返回一个纹理Texture2D的引用，可能是新加载到内存的，也可能是之前已经存在的；

```
Texture2D *texture = Director::getInstance()->getTextureCache()->addImage(filename);
```

也可以通过getTextureForKey方法来获得这个key所对应的纹理缓存，如果这个Key对应的纹理不存在，那么就返回NULL

```
Texture2D *texture = Director::getInstance()->getTextureCache()->getTextureForKey(textureKeyName);
```

##异步加载纹理

TextureCache类还支持异步加载资源的功能，利用addImageAsync方法。你可以很方面地给addImageAsync方法添加一个回调方法，这样，当纹理异步加载结束的时候，可以得到通知。

你可以选择异步加载方式，这样你就可以为loading场景增加一个进度条。关键代码如下：

```
TextureCacheTest::TextureCacheTest()
: _numberOfSprites(20)
, _numberOfLoadedSprites(0)
{
    auto size = Director::getInstance()->getWinSize();

    _labelLoading = Label::createWithTTF("loading...", "fonts/arial.ttf", 15);
    _labelPercent = Label::createWithTTF("%0", "fonts/arial.ttf", 15);

    _labelLoading->setPosition(Point(size.width / 2, size.height / 2 - 20));
    _labelPercent->setPosition(Point(size.width / 2, size.height / 2 + 20));

    this->addChild(_labelLoading);
    this->addChild(_labelPercent);

    // load textrues
    Director::getInstance()->getTextureCache()->addImageAsync("Images/HelloWorld.png", _CALLBACK_1(TextureCacheTest::loadingCallBack, this));
    Director::getInstance()->getTextureCache()->addImageAsync("Images/grossini.png", _CALLBACK_1(TextureCacheTest::loadingCallBack, this));
    Director::getInstance()->getTextureCache()->addImageAsync("Images/grossini_dance_01.png", _CALLBACK_1(TextureCacheTest::loadingCallBack, this));
    ....

}

void TextureCacheTest::loadingCallBack(cocos2d::Texture2D *texture)
{
    ++_numberOfLoadedSprites;
    char tmp[10];
    sprintf(tmp,"%%%d", (int)(((float)_numberOfLoadedSprites / _numberOfSprites) * 100));
    _labelPercent->setString(tmp);

    if (_numberOfLoadedSprites == _numberOfSprites)
    {
        this->removeChild(_labelLoading, true);
        this->removeChild(_labelPercent, true);
        addSprite();
    }
}
```

##清理缓存

removeUnusedTextures则会释放当前所有引用计数为1的纹理，即目前没有被使用的纹理。比如新场景创建好后，使用此方法释放没有使用的纹理非常方便。

```
Director::getInstance()->getTextureCache()->removeUnusedTextures();
```

当没有其它对象（比如sprite）持有纹理的引用的时候，纹理仍然会存在内存之间。基于这一点，我们可以立马从缓存中移除出去，这样，当纹理不存需要的时候，马上就会从内存中释放掉。如下代码所示：

```
Director::getInstance()->getTextureCache()->removeTextureForKey("Images/grossinis_sister2.png");
```

当收到"Memory Warning"时，可以调用removeAllTextures()方法。在短期内: 它还将释放一些资源，防止您的应用程序被杀害； 中期: 它将分配更多的资源；从长远来看：它会是相同的。

```
Director::getInstance()->getTextureCache()->removeAllTextures();
```



