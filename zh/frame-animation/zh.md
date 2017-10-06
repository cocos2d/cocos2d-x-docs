#序列帧动画

![classcocos2d_1_1_animation](res/classcocos2d_1_1_animation.png)

##简介

Cocos2d-x中，动画的具体内容是依靠精灵显示出来的，为了显示动态图片，我们需要不停切换精灵显示的内容，通过把静态的精灵变为动画播放器从而实现动画效果。动画由帧组成，每一帧都是一个纹理，我们可以使用一个纹理序列来创建动画。

我们使用Animation类描述一个动画，而精灵显示动画的动作则是一个Animate对象。动画动作Animate是精灵显示动画的动作，它由一个动画对象创建，并由精灵执行。

##创建方法

- 手动添加序列帧到Animation类
- 使用文件初始化Animation类

###手动添加

手动添加的方法需要将每一帧要显示的精灵有序添加到Animation类中，并设置每帧的播放时间，让动画能够匀速播放。另外，还要通过`setRestoreOriginalFrame`来设置是否在动画播放结束后恢复到第一帧。创建好Animation实例后，需要创建一个Animate实例来播放序列帧动画。

```
	auto animation = Animation::create();
    for( int i=1;i<15;i++)
    {
        char szName[100] = {0};
        sprintf(szName, "Images/grossini_dance_%02d.png", i);
        animation->addSpriteFrameWithFile(szName);
    }
    // should last 2.8 seconds. And there are 14 frames.
    animation->setDelayPerUnit(2.8f / 14.0f);
    animation->setRestoreOriginalFrame(true);

    auto action = Animate::create(animation);
    _grossini->runAction(Sequence::create(action, action->reverse(), NULL));
```	

在创建Animation实例时会用到以下几个接口：

- `addSpriteFrame`，添加精灵帧到Animation实例
- `setDelayUnits`，设置每一帧持续时间，以秒为单位
- `setRestoreOriginalFrame`，设置是否在动画播放结束后恢复到第一帧
- `clone`，克隆一个该Animation实例

###文件添加

首先我们来了解下需要用到的AnimationCache类。AnimationCache可以加载xml/plist文件，plist文件里保存了组成动画的相关信息，通过该类获取到plist文件里的动画。

在使用AnimationCache类时会用到以下几个接口：

- `addAnimationsWithFile`，添加动画文件到缓存，plist文件
- `getAnimation`，从缓存中获取动画对象
- `getInstance`，获取动画缓存实例对象

使用文件添加的方法只需将创建好的plist文件添加到动画缓存里面，plist文件里包含了序列帧的相关信息。再用动画缓存初始化Animation实例，用Animate实例来播放序列帧动画。

```
	auto cache = AnimationCache::getInstance();
    cache->addAnimationsWithFile("animations/animations-2.plist");
    auto animation2 = cache->getAnimation("dance_1");

    auto action2 = Animate::create(animation2);
    _tamara->runAction(Sequence::create(action2, action2->reverse(), NULL));
```

`注意：`3.0开始，Cocos2d-x使用getInstance来获取单例实例。


###动画缓存(AnimationCache)

通常情况下，对于一个精灵动画，每次创建时都需要加载精灵帧，按顺序添加到数组，再创建对应动作类，这是一个非常烦琐的计算过程。对于使用频率高的动画，比如走路动画，将其加入缓存可以有效降低每次创建的巨大消耗。由于这个类的目的和缓存内容都非常简单直接，所以其接口也是最简单了的，如下所示：

- static AnimationCache* getInstance()，全局共享的单例
- void addAnimation(Animation *animation, const std::string& name)，添加一个动画到缓存
- void addAnimationsWithFile(const std::string& plist)，添加动画文件到缓存
- void removeAnimation(const std::string& name)，移除一个指定的动画
- Animation* getAnimation(const std::string& name)，获得事先存入的动画

`建议：`在内存警告时我们应该加入如下的清理缓存操作：

```
void releaseCaches()

{

	AnimationCache::destroyInstance();
	
	SpriteFrameCache::getInstance()->removeUnusedSpriteFrames();

	TextureCache::getInstance()->removeUnuserdTextures();
}
```

值得注意的是清理的顺序，我们推荐先清理动画缓存，然后清理精[灵帧缓存](../spriteframe-cache/zh.md)，最后是[纹理缓存](../texture-cache/zh.md)。按照引用层级由高到低，以保证释放引用有效。