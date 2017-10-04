<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Building and Transitioning Scenes

### What is a Scene?
A `Scene` is a container that holds `Sprites`, `Labels`, `Nodes` and other
objects that your game needs. A `Scene` is responsible for running game logic and
rendering the content on a per-frame basis. You need at least one `Scene` to start
your game. You can think of this like a movie. The `Scene` is what is running and
users see what is happening in real-time. You can have any number of `Scene` objects
in your game and transition through them easily. Cocos2d-x provides __scene transitions__
and you can even have __scene transitions__ with cool effects.

<!---### Converting between coordinate systems

#### convertToNodeSpace

`convertToNodeSpace` will be used in, for example, tile-based games, where you
have a big map. `convertToNodeSpace` will convert your openGL touch coordinates
to the coordinates of the .tmx map or anything similar. Example:

The following picture shows that we have _node1_ with anchor point (0,0) and _node2_
with anchor point (1,1).

We invoke

```cpp
Vec2 point = node1->convertToNodeSpace(node2->getPosition());
```

 convert node2’s SCREEN coordinates to node1’s local.As the result, node2 with the position of (-25，-60).

![](scenes-img/5_10.jpg)

#### convertToWorldSpace

`convertToWorldSpace` converts on-node coordinates to SCREEN coordinates. `convertToWorldSpace` will always return SCREEN position of our sprite, might be very useful if you want to capture taps on your sprite but need to move/scale your layer.
Generally, the parent node call this method with the child node position, return the world’s postion of child’s as a result. It seems make no sense calling this method if the caller isn’t the parent.

Example:

```cpp
Point point = node1->convertToWorldSpace(node2->getPosition());
```

The above code will convert the node2‘s coordinates to the coordinates on the
screen. For example if the anchor position of node1 is which will be the bottom
left corner of the node1, but not necessarily on the screen. This will convert
the position of the node2 which is to the screen coordinate of the point relative
to node1 ). The result shows in the following picture:

![](scenes-img/5_11.jpg)

#### convertToWorldSpaceAR

`convertToWorldSpaceAR` will return the position relative to anchor point: so if
our scene - root layer has anchor point of Vec2(0.5f, 0.5f) - default,
`convertToWorldSpaceAR` should return position relative to screen center.

`convertToNodeSpaceAR` - the same logic as for `convertToWorldSpaceAR`

### Sample code：

```cpp

Sprite *sprite1 = Sprite::create("CloseNormal.png");

sprite1->setPosition(Vec2(20,40));

sprite1->setAnchorPoint(Vec2(0,0));

this->addChild(sprite1);

Sprite *sprite2 = Sprite::create("CloseNormal.png");

sprite2->setPosition(Vec2(-5,-20));

sprite2->setAnchorPoint(Vec2(1,1));

this->addChild(sprite2);

Vec2 point1 = sprite1->convertToNodeSpace(sprite2->getPosition());

Vec2 point2 = sprite1->convertToWorldSpace(sprite2->getPosition());

Vec2 point3 = sprite1->convertToNodeSpaceAR(sprite2->getPosition());

Vec2 point4 = sprite1->convertToWorldSpaceAR(sprite2->getPosition());

LOG("position = (%f,%f)",point1.x,point1.y);

LOG("position = (%f,%f)",point2.x,point2.y);

LOG("position = (%f,%f)",point3.x,point3.y);

LOG("position = (%f,%f)",point4.x,point4.y);

```

Result：

```

    position = (-25.000000,-60.000000)

    position = (15.000000,20.000000)

    position = (-25.000000,-60.000000)

    position = (15.000000,20.000000)

```
--->
