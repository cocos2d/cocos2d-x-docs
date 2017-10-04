<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Actions
Creating a `Scene` and adding `Sprite` objects on the screen is only part
of what we need to do. For a game to be a game we need to make things move
around! `Action` objects are an integral part of every game. __Actions__ allow the
transformation of `Node` objects in time space. Want to move a `Sprite`
from one `Point` to another and use a callback when complete? No problem!
You can even create a `Sequence` of `Action` items to be performed on a
`Node`. You can change `Node` properties like position, rotation and scale.
Example Actions: `MoveBy`, `Rotate`, `Scale`. All games use __Actions__.

Taking a look at the [sample code](https://github.com/chukong/programmers-guide-samples)
for this chapter, here are __Actions__ in work:

![](basic_concepts-img/2n_level1_action_start.png "")

and after 5 seconds the sprite will move to a new position:

![](basic_concepts-img/2n_level1_action_end.png "")

`Action` objects are easy to create:

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

<a name="seqs"></a>

## Sequences and Spawns
With moving `Sprite` objects on the screen we have everything we need to create
our game, right? Not quite. What about running multiple __Actions__? Yes,
Cocos2d-x handles this too in a few different ways.

Just like it sounds, a `Sequence` is multiple `Action` objects run in a specified
order. Need to run the `Sequence` in reverse? No problem, Cocos2d-x handles
this with no additional work.

Take a look at the flow of an example `Sequence` for moving a `Sprite`
gradually:

![](basic_concepts-img/2_sequence_scaled.png "")

This `Sequence` is easy to make:

{% codetabs name="C++", type="cpp" -%}
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

{%- language name="JavaScript", type="js" -%}
var mySprite = new cc.Node();

// move to point 50,10 over 2 seconds
var moveTo1 = new cc.MoveTo(2, cc._p(50,10));

// move from current position by 100,10 over 2 seconds
var moveBy1 = new cc.MoveBy(2, cc._p(100,10));

// move to point 150,10 over 2 seconds
var moveTo2 = new cc.MoveTo(2, cc._p(150,10));

// create a delay
var delay = new cc.DelayTime(1);

mySprite.runAction(Sequence.create(moveTo1, delay, moveBy1, delay.clone(),
moveTo2));

{%- endcodetabs %}

This example runs a `Sequence`, in order, but what about running all the
specified __Actions__ at the same time? Cocos2d-x supports this too and it
is called `Spawn`. `Spawn` will take all the specified `Action` objects and
executes them at the same time. Some might be longer than others, so they won't
all finish at the same time if this is the case.

{% codetabs name="C++", type="cpp" -%}
auto myNode = Node::create();

auto moveTo1 = MoveTo::create(2, Vec2(50,10));
auto moveBy1 = MoveBy::create(2, Vec2(100,10));
auto moveTo2 = MoveTo::create(2, Vec2(150,10));

myNode->runAction(Spawn::create(moveTo1, moveBy1, moveTo2, nullptr));

{%- language name="JavaScript", type="js" -%}
var myNode = new cc.Node();

var moveTo1 = new cc.MoveTo(2, cc._p(50,10));
var moveBy1 = new cc.MoveBy(2, cc._p(100,10));
var moveTo2 = new cc.MoveTo(2, cc._p(150,10));

myNode.runAction(Spawn.create(moveTo1, moveBy1, moveTo2));
{%- endcodetabs %}

Why `Spawn` actions? Is there ever a reason? Sure! What if your main
character has multiple __Actions__ when obtaining a power up? Maybe beating
the boss at the end of a level has multiple __Actions__ that need to happen
to end the level.
