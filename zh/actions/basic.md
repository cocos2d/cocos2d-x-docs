# 基本动作

基本动作通常都是单一的动作，用来完成一个简单的目标。下面通过简单的示例来介绍常见的基本动作。

## 移动

使用 `MoveTo` `MoveBy` 完成节点对象在一个设置的时间后移动。

```cpp
auto mySprite = Sprite::create("mysprite.png");

// Move a sprite to a specific location over 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50, 0));

mySprite->runAction(moveTo);

// Move a sprite 50 pixels to the right, and 0 pixels to the top over 2 seconds.
auto moveBy = MoveBy::create(2, Vec2(50, 0));

mySprite->runAction(moveBy);
```

![](../../en/actions/actions-img/i1.png "")

## 旋转

使用 `RotateTo` `RotateBy` 完成节点对象在一个设置的时间后顺时针旋转指定角度。

```cpp
auto mySprite = Sprite::create("mysprite.png");

// Rotates a Node to the specific angle over 2 seconds
auto rotateTo = RotateTo::create(2.0f, 40.0f);
mySprite->runAction(rotateTo);

// Rotates a Node clockwise by 40 degree over 2 seconds
auto rotateBy = RotateBy::create(2.0f, 40.0f);
mySprite->runAction(rotateBy);
```

![](../../en/actions/actions-img/i3.png "")

## 缩放

使用 `ScaleBy` `ScaleTo` 完成节点对象的比例缩放。

```cpp
auto mySprite = Sprite::create("mysprite.png");

// Scale uniformly by 3x over 2 seconds
auto scaleBy = ScaleBy::create(2.0f, 3.0f);
mySprite->runAction(scaleBy);

// Scale X by 5 and Y by 3x over 2 seconds
auto scaleBy = ScaleBy::create(2.0f, 3.0f, 3.0f);
mySprite->runAction(scaleBy);

// Scale to uniformly to 3x over 2 seconds
auto scaleTo = ScaleTo::create(2.0f, 3.0f);
mySprite->runAction(scaleTo);

// Scale X to 5 and Y to 3x over 2 seconds
auto scaleTo = ScaleTo::create(2.0f, 3.0f, 3.0f);
mySprite->runAction(scaleTo);
```

![](../../en/actions/actions-img/i4.png "")

### 淡入淡出

使用 `FadeIn` `FadeOut` 完成节点对象的淡入，淡出。 `FadeIn` 修改节点对象的透明度属性，从完全透明到完全不透明，`FadeOut` 相反。

```cpp
auto mySprite = Sprite::create("mysprite.png");

// fades in the sprite in 1 seconds
auto fadeIn = FadeIn::create(1.0f);
mySprite->runAction(fadeIn);

// fades out the sprite in 2 seconds
auto fadeOut = FadeOut::create(2.0f);
mySprite->runAction(fadeOut);
```

![](../../en/actions/actions-img/i2.png "")

## 色彩混合

使用 `TintTo` `TintBy`，将一个实现了 `NodeRGB` 协议的节点对象进行色彩混合。

```cpp
auto mySprite = Sprite::create("mysprite.png");

// Tints a node to the specified RGB values
auto tintTo = TintTo::create(2.0f, 120.0f, 232.0f, 254.0f);
mySprite->runAction(tintTo);

// Tints a node BY the delta of the specified RGB values.
auto tintBy = TintBy::create(2.0f, 120.0f, 232.0f, 254.0f);
mySprite->runAction(tintBy);
```

![](../../en/actions/actions-img/i5.png "")

## 帧动画

使用 `Animate` 对象可以很容易的通过每隔一个短暂时间进行图像替代的方式，实现一个翻页效果。下面是一个例子：

```cpp
auto mySprite = Sprite::create("mysprite.png");

// now lets animate the sprite we moved
Vector<SpriteFrame*> animFrames;
animFrames.reserve(12);
animFrames.pushBack(SpriteFrame::create("Blue_Front1.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Front2.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Front3.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Left1.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Left2.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Left3.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Back1.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Back2.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Back3.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Right1.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Right2.png", Rect(0,0,65,81)));
animFrames.pushBack(SpriteFrame::create("Blue_Right3.png", Rect(0,0,65,81)));

// create the animation out of the frames
Animation* animation = Animation::createWithSpriteFrames(animFrames, 0.1f);
Animate* animate = Animate::create(animation);

// run it and repeat it forever
mySprite->runAction(RepeatForever::create(animate));
```

## 变速运动

变速动作可以让节点对象具有加速度，产生平滑同时相对复杂的动作，所以可以用变速动作来模仿一些物理运动，这样比实际使用物理引擎的性能消耗低，使用起来也简单。当然你也可以将变速动作应用到动画菜单和按钮上，实现你想要的效果。

![](../../en/actions/actions-img/easing-functions.png "")

Cocos2d-x 支持上图中的大部分变速动作，实现起来也很简单。我们来看个例子，一个精灵从屏幕顶部落下然后不断跳动：

```cpp
// create a sprite
auto mySprite = Sprite::create("mysprite.png");

// create a MoveBy Action to where we want the sprite to drop from.
auto move = MoveBy::create(2, Vec2(200, dirs->getVisibleSize().height -
 newSprite2->getContentSize().height));

// create a BounceIn Ease Action
auto move_ease_in = EaseBounceIn::create(move->clone() );
auto move_ease_in_back = move_ease_in->reverse();

// create a delay that is run in between sequence events
auto delay = DelayTime::create(0.25f);

// create the sequence of actions, in the order we want to run them
auto seq1 = Sequence::create(move_ease_in, delay, move_ease_in_back,
    delay->clone(), nullptr);

// run the sequence and repeat forever.
mySprite->runAction(RepeatForever::create(seq1));
```

复杂的动作很难在这样的文本里表示，要是看效果的话最好去运行一下本指南的 [代码示例](https://github.com/chukong/programmers-guide-samples/tree/v3.16)，或者运行引擎代码的测试项目 `cpp-tests`，在子菜单 `3:Actions - Basic` 中有基本的动作效果展示。

 > _运行测试项目的方法，参考本文档的 [环境搭建](../installation/index.md) 章节_ .
