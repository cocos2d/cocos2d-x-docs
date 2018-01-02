## Clone
__Clone__ is exactly like it sounds. If you have an `Action`, you can apply it to
multiple `Node` objects by using `clone()`. Why do you have to clone? Good question.
`Action` objects have an __internal state__. When they run, they are actually
changing the `Node` objects properties. Without the use of `clone()` you don't
truly have a unique `Action` being applied to the `Node`. This will produce
unexpected results, as you can't know for sure what the properties of the `Action`
are currently set at.

Let's hash through an example, say you have a __heroSprite__ and it has a position
of __(0,0)__. If you run an `Action` of:

{% codetabs name="C++", type="cpp" -%}
MoveBy::create(10, Vec2(400,100));
{%- endcodetabs %}

This will move __heroSprite__ from *(0,0)* to *(400, 100)* over the course of
*10 seconds*. __heroSprite__ now has a new position of *(400, 100)* and more
importantly the `Action` has this position in it's __internal state__. Now, say
you have an __enemySprite__ with a position of *(200, 200)*. If you were to apply
this same:

{% codetabs name="C++", type="cpp" -%}
MoveBy::create(10, Vec2(400,100));
{%- endcodetabs %}

to your __enemySprite__, it would end up at a position of *(800, 200)* and not
where you thought it would. Do you see why? It is because the `Action` already
had an __internal state__ to start from when performing the `MoveBy`. __Cloning__
an `Action` prevents this. It ensures you get a unique version `Action` applied
to your `Node`.

Let's also see this in code, first, incorrect.

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

Correctly, using __clone()__!:

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

## Reverse
__Reverse__ is also exactly like it sounds. If you run a series of actions, you
can call `reverse()` to run it, in the opposite order. Otherwise known as, backwards.
However, it is not just simply running the `Action` in reverse order. Calling
`reverse()` is actually manipulating the properties of the original `Sequence` or
`Spawn` in reverse too.

Using the `Spawn` example above, reversing is simple.

{% codetabs name="C++", type="cpp" -%}
// reverse a sequence, spawn or action
mySprite->runAction(mySpawn->reverse());
{%- endcodetabs %}

Most `Action` and `Sequence` objects are reversible!

It's easy to use, but let's make sure we see what is happening. Given:

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
newSprite2->runAction(sequence);

// reverse it
newSprite2->runAction(sequence->reverse());
{%- endcodetabs %}

What is really happening? If we lay out the steps as a list it might be helpful:

   * __mySprite__ is created
   * __mySprite__ position is set to *(50, 56)*
   *  __sequence__ starts to run
   *  __sequence__ moves __mySprite__ by *500*, over *2 seconds*, __mySprite__ new position
      _(550, 56)_
   *  __sequence__ delays for *2 seconds*
   *  __sequence__ scales __mySprite__ by *2x* over *2 seconds*
   *  __sequence__ delays for *6* more seconds (notice we run another sequence to
   accomplish this)
   * we run a __reverse()__ on the sequence so we re-run each action backwards
   * __sequence__ is delayed for *6 seconds*
   * __sequence__ scales __mySprite__ by *-2x* over *2 seconds*
   * __sequence__ delays for *2 seconds*
   * __sequence__ moves __mySprite__ by *-500*, over *2 seconds*, __mySprite__ new position
    _(50, 56)_

You can see that a `reverse()` is simple for you to use, but not so simple in
its internal logic. Cocos2d-x does all the heavy lifting!
