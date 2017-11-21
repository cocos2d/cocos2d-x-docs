# 动作的克隆

__克隆(Clone)__ 的功能和字面含义一样，如果你对一个节点对象使用了 `clone()` 方法，你就获得了这个节点对象的拷贝。

为什么要使用 `clone()` 方法? 因为当 `Action` 对象运行时会产生一个内部状态，记录着节点属性的改变。当你想将一个创建的动作，重复使用到不同的节点对象时，如果不用 `clone()` 方法，就无法确定这个动作的属性到底是怎样的(因为被使用过，产生了内部状态)，这会造成难以预料的结果。

我们来看示例，假如你有一个坐标位置是 `(0,0)` 的 `heroSprite`，执行这样一个动作：

{% codetabs name="C++", type="cpp" -%}
MoveBy::create(10, Vec2(400,100));
{%- endcodetabs %}

你的 `heroSprite` 就在 10s 的时间中，从 `(0,0)` 移动到了 `(400,100)`，`heroSprite` 有了一个新位置 `(400,100)`，更重要的是动作对象也有了节点位置相关的内部状态了。现在假如你有一个坐标位置是 `(200,200)`的 `emenySprite`。你还使用这个相同的动作，`emenySprite` 就会移动到 `(800,200)`的坐标位置，并不是你期待的结果。因为第二次将这个动作应用的时候，它已经有内部状态了。使用 `clone()` 能避免这种情况，克隆获得一个新的动作对象，新的对象没有之前的内部状态。

从代码中学习用法吧，先看看错误的情况：

{% codetabs name="C++", type="cpp" -%}
// create our Sprites
auto heroSprite = Sprite::create("herosprite.png");
auto enemySprite = Sprite::create("enemysprite.png");

// create an Action
auto moveBy = MoveBy::create(10, Vec2(400,100));

// run it on our hero
heroSprite->runAction(moveBy);

// run it on our enemy
enemySprite->runAction(moveBy); // oops, this will not be unique!
// uses the Actions current internal state as a starting point.
{%- endcodetabs %}

使用 `clone()` 的正确情况：

{% codetabs name="C++", type="cpp" -%}
// create our Sprites
auto heroSprite = Sprite::create("herosprite.png");
auto enemySprite = Sprite::create("enemysprite.png");

// create an Action
auto moveBy = MoveBy::create(10, Vec2(400,100));

// run it on our hero
heroSprite->runAction(moveBy);

// run it on our enemy
enemySprite->runAction(moveBy->clone()); // correct! This will be unique
{%- endcodetabs %}

## 动作的倒转

__倒转(Reverse)__ 的功能也和字面意思一样，调用 `reverse()` 可以让一系列动作按相反的方向执行。`reverse()` 不是只能简单的让一个 `Action` 对象反向执行，还能让 `Sequence` 和
`Spawn` 倒转。

倒转使用起来很简单：

{% codetabs name="C++", type="cpp" -%}
// reverse a sequence, spawn or action
mySprite->runAction(mySpawn->reverse());
{%- endcodetabs %}

思考下面这段代码在执行的时候, 内部发生了什么?

{% codetabs name="C++", type="cpp" -%}
// create a Sprite
auto mySprite = Sprite::create("mysprite.png");
mySprite->setPosition(50, 56);

// create a few Actions
auto moveBy = MoveBy::create(2.0f, Vec2(500,0));
auto scaleBy = ScaleBy::create(2.0f, 2.0f);
auto delay = DelayTime::create(2.0f);

// create a sequence
auto delaySequence = Sequence::create(delay, delay->clone(), delay->clone(),
delay->clone(), nullptr);

auto sequence = Sequence::create(moveBy, delay, scaleBy, delaySequence, nullptr);

// run it
mySprite->runAction(sequence);

// reverse it
mySprite->runAction(sequence->reverse());
{%- endcodetabs %}

思考起来可能有点困难，我们将执行的每一步列出来，或许能帮助你理解：

1. `mySprite` 创建
1. `mySprite` 的坐标位置设置成(50,56)
1. `sequence` 开始执行
1. `sequence` 执行第一个动作 `moveBy`，2s 中 `mySprite` 移动到了坐标位置(550,56)
1. `sequence` 执行第二个动作， 暂停 2s
1. `sequence` 执行第三个动作，`scaleBy`，2s 中 `mySprite` 放大了2倍
1. `sequence` 执行第四个动作，`delaySequence`，暂停 6s
1. `reverse()` 被调用，序列倒转，开始反向执行
1. `sequence` 执行第四个动作，`delaySequence`，暂停 6s
1. `sequence` 执行第三个动作，`scaleBy`，2s 中 `mySprite` 缩小了2倍 (注意：序列内的动作被倒转)
1. `sequence` 执行第二个动作， 暂停 2s
1. `sequence` 执行第一个动作 `moveBy`，2s 中 `mySprite` 从坐标位置 (550,56)，移动到了 (50, 56)
1. `mySprite` 回到了最初的位置

我们能发现 `reverse()` 方法使用起来很简单，内部逻辑却一点都不简单。因为 Cocos2d-x 封装了复杂的逻辑，为你留下了简单易用的接口！
