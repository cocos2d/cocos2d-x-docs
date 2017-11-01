# 序列

__动作序列(Sequence)__ 是将一系列要顺序执行的动作封装到一起的对象，一个 `Sequence` 可以包含任何数量的动作对象，回调方法和其它序列。可以包含回调方法? 没错! Cocos2d-x 允许把一个方法添加进去 `CallFunc` 对象，然后将 `CallFunc` 添加到 `Sequence`，这样，在执行序列的时候就能触发方法调用。因此，你能在一个序列中添加一些个性化的功能，而不仅仅是添加 Cocos2d-x 提供的有限动作。下面是一个序列的动作执行示意图：

![](../../en/actions/actions-img/sequence.png "")

## `Sequence` 示例

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png");

// create a few actions.
auto jump = JumpBy::create(0.5, Vec2(0, 0), 100, 1);

auto rotate = RotateTo::create(2.0f, 10);

// create a few callbacks
auto callbackJump = CallFunc::create([](){
    log("Jumped!");
});

auto callbackRotate = CallFunc::create([](){
    log("Rotated!");
});

// create a sequence with the actions and callbacks
auto seq = Sequence::create(jump, callbackJump, rotate, callbackRotate, nullptr);

// run it
mySprite->runAction(seq);
{%- endcodetabs %}

上面这个 `Sequence` 做了什么? 按照下面的顺序执行了每一个动作。

__Jump__ -> __callbackJump()__ -> __Rotate__ -> __callbackRotate()__

## `Spawn`

`Spawn` 和 `Sequence` 是非常相似的，区别是 `Spawn` 同时执行所有的动作。`Spawn` 对象可以添加任意数量的动作和其它 `Spawn` 对象。

![](../../en/actions/actions-img/spawn.png "")

`Spawn` 的效果和同时运行多个动作的 `runAction()` 方法是一致的，但是它的独特之处是 `Spawn` 能被放到 `Sequence` 中，结合 `Spawn` 和 `Sequence` 能实现非常强大的动作效果。

例如，创建两个动作：

{% codetabs name="C++", type="cpp" -%}
// create 2 actions and run a Spawn on a Sprite
auto mySprite = Sprite::create("mysprite.png");

auto moveBy = MoveBy::create(10, Vec2(400,100));
auto fadeTo = FadeTo::create(2.0f, 120.0f);
{%- endcodetabs %}

使用 `Spawn`：

{% codetabs name="C++", type="cpp" -%}
// running the above Actions with Spawn.
auto mySpawn = Spawn::createWithTwoActions(moveBy, fadeTo);
mySprite->runAction(mySpawn);
{%- endcodetabs %}

同时调用方法 `runAction()`：

{% codetabs name="C++", type="cpp" -%}
// running the above Actions with consecutive runAction() statements。
mySprite->runAction(moveBy);
mySprite->runAction(fadeTo);
{%- endcodetabs %}

上面两种方式产生的效果是一样的，现在看把一个 `Spawn` 添加到一个 `Sequence` 中是怎样的一种情景，动作的执行流程会看起来像这样：

![](../../en/actions/actions-img/spawn_in_a_sequence.png "")

{% codetabs name="C++", type="cpp" -%}
// create a Sprite
auto mySprite = Sprite::create("mysprite.png");

// create a few Actions
auto moveBy = MoveBy::create(10, Vec2(400,100));
auto fadeTo = FadeTo::create(2.0f, 120.0f);
auto scaleBy = ScaleBy::create(2.0f, 3.0f);

// create a Spawn to use
auto mySpawn = Spawn::createWithTwoActions(scaleBy, fadeTo);

// tie everything together in a sequence
auto seq = Sequence::create(moveBy, mySpawn, moveBy, nullptr);

// run it
mySprite->runAction(seq);
{%- endcodetabs %}

运行本文档的 [代码示例](https://github.com/chukong/programmers-guide-samples/tree/v3.16) 去看一下效果吧!
