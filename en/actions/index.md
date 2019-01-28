## Actions
`Action` objects are just like they sound. They make a `Node` perform a change
to its properties. `Action` objects allow the transformation of `Node` properties in time. Any object with a base class of `Node` can have `Action` objects performed on it. As an example, you can move a `Sprite` from one position to another and do it over a span of time.

Example of `MoveTo` and `MoveBy` actions:

```cpp
// Move sprite to position 50,10 in 2 seconds.
auto moveTo = MoveTo::create(2, Vec2(50, 10));
mySprite1->runAction(moveTo);

// Move sprite 20 points to right in 2 seconds
auto moveBy = MoveBy::create(2, Vec2(20,0));
mySprite2->runAction(moveBy);
```

[Let's get started with Actions!](getting_started.md)