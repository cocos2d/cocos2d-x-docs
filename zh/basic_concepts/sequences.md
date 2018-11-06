# 序列(Sequence)

能在屏幕上移动精灵，是制作一个游戏所需的一切，是吗？不是的，至少要考虑一下如何执行多个 `Action`。Cocos2d-x 通过 __序列(Sequence)__ 来支持这种需求。

顾名思义，序列就是多个动作按照特定顺序的一个排列，当然反向执行这个序列也是可以的，Cocos2d-x 能很方便的完成这项工作。

让我们来看一个通过序列控制精灵移动的例子：

![](../../en/basic_concepts/basic_concepts-img/2_sequence_scaled.png "")

创建 `Sequence` ：

```cpp
auto mySprite = Node::create();

// move to point 50,10 over 2 seconds
auto moveTo1 = MoveTo::create(2, Vec2(50,10));

// move from current position by 100,10 over 2 seconds
auto moveBy1 = MoveBy::create(2, Vec2(100,10));

// move to point 150,10 over 2 seconds
auto moveTo2 = MoveTo::create(2, Vec2(150,10));

// create a delay
auto delay = DelayTime::create(1);

mySprite->runAction(Sequence::create(moveTo1, delay, moveBy1, delay.clone(),
moveTo2, nullptr));

```

这个例子执行了一个动作的 `Sequence` 序列，那要是想让所有的特定动作同时执行呢？Cocos2d-x 也支持！通过引擎中的 `Spawn` 对象，你能让多个动作同时被解析执行。可能不同动作的执行时间不一致，在这种情况下，他们不会同时结束。

```cpp
auto myNode = Node::create();

auto moveTo1 = MoveTo::create(2, Vec2(50,10));
auto moveBy1 = MoveBy::create(2, Vec2(100,10));
auto moveTo2 = MoveTo::create(2, Vec2(150,10));

myNode->runAction(Spawn::create(moveTo1, moveBy1, moveTo2, nullptr));

```

为什么要有同时执行多个动作的需求呢？当然是有原因的啦！比如你的游戏角色被电了，或者在关卡结束打 boss 的时候，想一想类似的场景.
