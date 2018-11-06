# 动作(Action)

__动作(Action)__ 的功能就和字面含义一样，它通过改变一个 `Node` 对象的属性，让它表现出某种动作。动作对象能实时的改变 `Node` 的属性，任何一个对象只要它是 `Node` 的子类都能被改变。比如，你能通过动作对象把一个精灵从一个位置移动到另一个位置。

通过 `MoveTo` 和 `MoveBy` 方法:

```cpp
// Move sprite to position 50,10 in 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50, 10));
mySprite1->runAction(moveTo);

// Move sprite 20 points to right in 2 seconds
auto moveBy = MoveBy::create(2, Vec2(20,0));
mySprite2->runAction(moveBy);
```

## By 和 To 的区别

你能注意到，每一个动作都会有两个方法 __By__ 和 __To__。两种方法方便你在不同的情况使用，__By__ 算的是相对于节点对象的当前位置，__To__ 算的是绝对位置，不考虑当前节点对象在哪。如果你想动作的表现是相对于 `Node` 当前位置的，就用 __By__，相对的想让动作的表现是按照坐标的绝对位置就用 __To__。看一个例子：

```cpp
auto mySprite = Sprite::create("mysprite.png");
mySprite->setPosition(Vec2(200, 256));

// MoveBy - lets move the sprite by 500 on the x axis over 2 seconds
// MoveBy is relative - since x = 200 + 500 move = x is now 700 after the move
auto moveBy = MoveBy::create(2, Vec2(500, mySprite->getPositionY()));

// MoveTo - lets move the new sprite to 300 x 256 over 2 seconds
// MoveTo is absolute - The sprite gets moved to 300 x 256 regardless of
// where it is located now.
auto moveTo = MoveTo::create(2, Vec2(300, mySprite->getPositionY()));

// Delay - create a small delay
auto delay = DelayTime::create(1);

auto seq = Sequence::create(moveBy, delay, moveTo, nullptr);

mySprite->runAction(seq);
```

![](../../en/actions/actions-img/i0.png "")
