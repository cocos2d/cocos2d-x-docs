# 动作

__动作 Action__ 对象在引擎中的意义就和字面意思一样, 它通过改变一个 `Node` 对象的属性, 让它表现出某种动作. 动作对象能实时的改变 `Node` 的属性, 任何一个对象只要它是 `Node` 的子类都能被改变. 比如, 你能通过动作对象把一个精灵从一个位置移动到另一个位置.

通过 `MoveTo` 和 `MoveBy` 方法:

{% codetabs name="C++", type="cpp" -%}
// Move sprite to position 50,10 in 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50, 10));
mySprite1->runAction(moveTo);

// Move sprite 20 points to right in 2 seconds
auto moveBy = MoveBy::create(2, Vec2(20,0));
mySprite2->runAction(moveBy);
{%- language name="JavaScript", type="js" -%}
// Move sprite to position 50,10 in 2 seconds.
var moveTo = new cc.MoveTo(2, cc._p(50, 10));
mySprite1.runAction(moveTo);

// Move sprite 20 points to right in 2 seconds
var moveBy = new cc.MoveBy(2, cc._p(20,0));
mySprite2.runAction(moveBy);
{%- endcodetabs %}

## By 和 To 的区别

你能注意到, 每一个动作都会有两个方法 __By__ 和 __To__. 两种方法方便你在不同的情况使用, __By__ 算的是相对于节点的当前位置, __To__ 算的是绝对位置, 不考虑当前节点在哪. 如果你想动作的表现是相对于 `Node` 对象当前位置的, 就用 __By__, 相对的想让动作的表现是按照坐标的绝对位置就用 __To__. 看一个例子:

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png");
mySprite->setPosition(Vec2(200, 256));

// MoveBy - lets move the sprite by 500 on the x axis over 2 seconds
// MoveBy is relative - since x = 200 + 200 move = x is now 400 after the move
auto moveBy = MoveBy::create(2, Vec2(500, mySprite->getPositionY()));

// MoveTo - lets move the new sprite to 300 x 256 over 2 seconds
// MoveTo is absolute - The sprite gets moved to 300 x 256 regardless of
// where it is located now.
auto moveTo = MoveTo::create(2, Vec2(300, mySprite->getPositionY()));

// Delay - create a small delay
auto delay = DelayTime::create(1);

auto seq = Sequence::create(moveBy, delay, moveTo, nullptr);

mySprite->runAction(seq);
{%- language name="JavaScript", type="js" -%}
var mySprite = new cc.Sprite(res.mysprite_png);
mySprite.setPosition(cc._p(200, 256));

// MoveBy - lets move the sprite by 500 on the x axis over 2 seconds
// MoveBy is relative - since x = 200 + 200 move = x is now 400 after the move
var moveBy = new cc.MoveBy(2, cc._p(500, mySprite.y));

// MoveTo - lets move the new sprite to 300 x 256 over 2 seconds
// MoveTo is absolute - The sprite gets moved to 300 x 256 regardless of
// where it is located now.
var moveTo = new cc.MoveTo(2, cc._p(300, mySprite.y));

// Delay - create a small delay
var delay = new cc.DelayTime(1);

var seq = new cc.Sequence(moveBy, delay, moveTo);

mySprite.runAction(seq);
{%- endcodetabs %}

![](../../en/actions/actions-img/i0.png "")
