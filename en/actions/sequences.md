## Sequences and how to run them
__Sequences__ are a series of `Action` objects to be executed sequentially. This can
be any number of `Action` objects, __Functions__ and even another `Sequence`.
Functions? Yes! Cocos2d-x has a `CallFunc` object that allows you to create a
__function()__ and pass it in to be run in your `Sequence`. This allows you to add
your own functionality to your `Sequence` objects besides just the stock `Action`
objects that Cocos2d-x provides. This is what a `Sequence` looks like when executing:

![](actions-img/sequence.png "")

### An example sequence

```cpp
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
```

So what does this `Sequence` action do?

It will execute the following actions sequentially:

__Jump__ -> __callbackJump()__ -> __Rotate__ -> __callbackRotate()__

### Delays in Sequences
Sometimes you may want to create a `Sequence` that has a small delay between each `Action`. You can achieve this using `CallFunc`. Example:

```cpp
// use a sequence incorporating delays between items
cocos2d::CallFunc* A = cocos2d::CallFunc::create([=]() {
    // do something
});
cocos2d::CallFunc* B = cocos2d::CallFunc::create([=]() {
    // do something
});
cocos2d::CallFunc* C = cocos2d::CallFunc::create([=]() {
    // do something
});

cocos2d::DelayTime* delay = cocos2d::DelayTime::create(1);

runAction(cocos2d::Sequence::create(A, delay, B, delay, C, NULL));
```

### Spawn
__Spawn__ is very similar to `Sequence`, except that all actions will run at the same
time. You can have any number of `Action` objects and even other `Spawn` objects!

![](actions-img/spawn.png "")

`Spawn` produces the same result as running multiple consecutive __runAction()__
statements. However, the benefit of spawn is that you can put it in a `Sequence`
to help achieve specific effects that you cannot otherwise. Combining `Spawn` and
`Sequence` is a very powerful feature.

Example, given:

```cpp
// create 2 actions and run a Spawn on a Sprite
auto mySprite = Sprite::create("mysprite.png");

auto moveBy = MoveBy::create(10, Vec2(400,100));
auto fadeTo = FadeTo::create(2.0f, 120.0f);
```

Using a `Spawn`:

```cpp
// running the above Actions with Spawn.
auto mySpawn = Spawn::createWithTwoActions(moveBy, fadeTo);
mySprite->runAction(mySpawn);
```

and consecutive __runAction()__ statements:

```cpp
// running the above Actions with consecutive runAction() statements.
mySprite->runAction(moveBy);
mySprite->runAction(fadeTo);
```

Both would produce the same result. However, one can use `Spawn` in a `Sequence`.
This flowchart shows how this might look:

![](actions-img/spawn_in_a_sequence.png "")

```cpp
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
```
