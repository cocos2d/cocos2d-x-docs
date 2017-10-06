#SpriteFrameCache

##简介

SpriteFrameCache 主要服务于多张碎图合并出来的纹理图片。这种纹理在一张大图中包含了多张小图，直接通过TextureCache引用会有诸多不便，因而衍生出来精灵框帧的处理方式，即把截取好的纹理信息保存在一个精灵框帧内，精灵通过切换不同的框帧来显示出不同的图案。

##SpriteFrameCache

SpriteFrameCache的内部封装了一个Map<std::string, SpriteFrame*> _spriteFrames对象。key为帧的名称。SpriteFrameCache一般用来处理plist文件(这个文件指定了每个独立的精灵在这张“大图”里面的位置和大小)，该文件对应一张包含多个精灵的大图，plist文件可以使用TexturePacker制作。

SpriteFrameCache的常用接口和TextureCache类似，不再赘述了，唯一需要注意的是添加精灵帧的配套文件一个plist文件和一张大的纹理图。下面列举了SpriteFrameCache常用的方法：（详细API请看SpriteFrameCache API）

获取单例的SpriteFrameCache对象。sharedSpriteFrameCache方法在3.0中已经弃用

```
SpriteFrameCache* cache = SpriteFrameCache::getInstance(); 
```
销毁SpriteFrameCache对象。

```
SpriteFrameCache::destroyInstance();
```

使用SpriteFrameCache获取指定的精灵帧，创建精灵对象

```
SpriteFrameCache *frameCache = SpriteFrameCache::getInstance();
frameCache->addSpriteFramesWithFile("boy.plist","boy.png");//boy.png里集合了boy1.png,boy2.png这些小图
auto frame_sp = Sprite::createWithSpriteFrameName("boy1.png");//从SpriteFrameCache缓存中找到boy1.png这张图片.
this->addChild(frame_sp,2);
```
##SpriteFrameCache vs. TextureCache 

SpriteFrameCache精灵框帧缓存。顾名思义，这里缓存的是精灵帧SpriteFrame，它主要服务于多张碎图合并出来的纹理图片。这种纹理在一张大图中包含了多张小图，直接通过TextureCache引用会有诸多不便，因而衍生出来精灵框帧的处理方式，即把截取好的纹理信息保存在一个精灵框帧内，精灵通过切换不同的框帧来显示出不同的图案。
跟TextureCache功能一样，将SpriteFrame缓存起来，在下次使用的时候直接去取。不过跟TextureCache不同的是，如果内存池中不存在要查找的图片，它会提示找不到，而不会去本地加载图片。

* TextureCache时最底层也是最有效的纹理缓存，缓存的是加载到内存中的纹理资源，也就是图片资源。
* SpriteFrameCache精灵框帧缓存，缓存的时精灵帧。
* SpriteFrameCache是基于TextureCache上的封装。缓存的是精灵帧，是纹理指定区域的矩形块。各精灵帧都在同一纹理中，通过切换不同的框帧来显示出不同的图案。
