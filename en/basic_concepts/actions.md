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
