# 使用图集

__图集(Sprite Sheet)__ 是通过专门的工具将多张图片合并成一张大图，并通过 plist 等格式的文件索引的资源，使用图集比使用多个独立图像占用的磁盘空间更少，还会有更好的性能。这种方式已经是游戏行业中提高游戏性能的标准方法之一。

在使用图集时，首先将其全部加载到 `SpriteFrameCache` 中，`SpriteFrameCache` 是一个全局的缓存类，缓存了添加到其中的 `SpriteFrame` 对象，提高了精灵的访问速度。`SpriteFrame` 只加载一次，后续一直保存在 `SpriteFrameCache` 中。

示例：

![](../../en/sprites/sprites-img/3_1.png "example SpriteSheet")

单看这个图集，似乎很难分析出什么，让我们对比一下：

![](../../en/sprites/sprites-img/spritesheet.png "example SpriteSheet")

这就很容易看出来，它至少完成了将多个图像素材合为一个，同时减少了磁盘空间占用。

继续来看如何在代码中使用。

## 加载图集

获取到 `SpriteFrameCache` 的实例，把图集添加到实例中。

```cpp
// load the Sprite Sheet
auto spritecache = SpriteFrameCache::getInstance();

// the .plist file can be generated with any of the tools mentioned below
spritecache->addSpriteFramesWithFile("sprites.plist");

```

这样我们就完成了，将一个图集添加到 `SpriteFrameCache` 中，现在我们就能利用这个对象创建精灵了！

## 创建图集

手动创建图集资源是一个单调乏味的过程，幸运的是有一些工具能帮助我们自动创建，下面是推荐的几个工具：

* [Texture Packer](https://www.codeandweb.com/texturepacker)
* [Zwoptex](https://www.zwopple.com/zwoptex/)
* [ShoeBox](http://renderhjs.net/shoebox/)
* [Sprite Sheet Packer](http://amakaseev.github.io/sprite-sheet-packer/)

其中 __Texture Packer__ 有一个专门为 Cocos2d-x 写的图集创建指南。[传送门](https://www.codeandweb.com/texturepacker/tutorials/animations-and-spritesheets-in-cocos2d-x)
