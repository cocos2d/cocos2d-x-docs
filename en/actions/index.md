## Actions
`Action` objects are just like they sound. They make a `Node` perform a change
to its properties. `Action` objects allow the transformation of `Node` properties
in time. Any object with a base class of `Node` can have `Action` objects performed
on it. As an example, you can move a `Sprite` from one position to another and
do it over a span of time.

Example of `MoveTo` and `MoveBy` action:

{% codetabs name="C++", type="cpp" -%}
// Move sprite to position 50,10 in 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50, 10));
mySprite1->runAction(moveTo);

// Move sprite 20 points to right in 2 seconds
auto moveBy = MoveBy::create(2, Vec2(20,0));
mySprite2->runAction(moveBy);
{%- endcodetabs %}

#### By and To, what is the difference?
You will notice that each `Action` has a __By__ and __To__ version. Why? Because
they are different in what they accomplish. A __By__ is relative to the current
state of the `Node`. A __To__ action is absolute, meaning it doesn't take into
account the current state of the `Node`. Let's take a look at a specific example:

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
{%- endcodetabs %}

![](actions-img/i0.png "")
