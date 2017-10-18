# 动作(Action)

创建一个场景, 在场景里面增加精灵只是完成一个游戏的第一步, 接下来我们要解决的问题就是, 怎么让精灵动起来. __动作(Action)__ 就是用来解决这个问题的, 它可以让精灵在场景中移动, 如从一个点移动到另外一个点. 你还可以创建一个动作 __序列(Sequence)__ , 让精灵按照这个序列做连续的动作, 在动作过程中你可以改变精灵的位置, 旋转角度, 缩放比例等等.

在 [代码示例](https://github.com/chukong/programmers-guide-samples)
中, 有对应的章节, 执行效果是这样:

![](../../en/basic_concepts/basic_concepts-img/2n_level1_action_start.png "")

5s 后, 精灵移动到了一个新的位置.

![](../../en/basic_concepts/basic_concepts-img/2n_level1_action_end.png "")

`Action` 对象的创建:

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("Blue_Front1.png");

// Move a sprite 50 pixels to the right, and 10 pixels to the top over 2 seconds.
auto moveBy = MoveBy::create(2, Vec2(50,10));
mySprite->runAction(moveBy);

// Move a sprite to a specific location over 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50,10));
mySprite->runAction(moveTo);

{%- language name="JavaScript", type="js" -%}
var mySprite = new cc.Sprite(res.mySprite_png);

// Move a sprite 50 pixels to the right and 10 pixels to the top over 2 seconds.
var moveBy = new cc.MoveBy(2, cc._p(50,10));
mySprite.runAction(moveBy);

// Move a sprite to a specific location over 2 seconds.
var moveTo = new cc.MoveTo(2, cc._p(50,10));
mySprite.runAction(moveTo);
{%- endcodetabs %}
