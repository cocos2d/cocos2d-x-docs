## By and To, what is the difference?
You will notice that each `Action` has a __By__ and __To__ version. Why? Because
they are different in what they accomplish. A __By__ is relative to the current
state of the `Node`. A __To__ action is absolute, meaning it doesn't take into
account the current state of the `Node`. Let's take a look at a specific example:

{% codetabs name="C++", type="cpp" -%}
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
{%- endcodetabs %}

![](actions-img/i0.png "")
