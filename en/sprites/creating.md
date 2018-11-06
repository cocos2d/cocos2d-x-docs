## Creating Sprites
There are different ways to create Sprites depending upon what you need to
accomplish. You can create a `Sprite` from an image with various graphic formats
including: __PNG__, __JPEG__, __TIFF__, and others. Let's go through some create methods and
talk about each one.

### Creating a Sprite
A `Sprite` can be created by specifying an image file to use.

```cpp
auto mySprite = Sprite::create("mysprite.png");
```

![](sprites-img/i1.png "")

The statement above creates a `Sprite` using the __mysprite.png__ image. The result
is that the created `Sprite` uses the whole image. `Sprite` has the same dimensions
of __mysprite.png__. If the image file is 200 x 200 the resulting `Sprite` is 200 x 200.

### Creating a Sprite with a Rect

In the previous example, the created `Sprite` has the same size as the original
image file. If you want to create a `Sprite` with only a certain portion of the
image file, you can do it by specifying a `Rect`.

`Rect` has 4 values: __origin x__, __origin y__, __width__ and __height__.

```cpp
auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
```

![](sprites-img/i4.png "")

`Rect` starts at the top left corner. This is the opposite of what you might be
used to when laying out screen position as it starts from the lower left corner.
Thus the resulting `Sprite` is only a portion of the image file. In this case the
`Sprite` dimension is 40 x 40 starting at the top left corner.

If you don't specify a `Rect`, Cocos2d-x will automatically use the full width
and height of the image file you specify. Take a look at the example below. If
we use an image with dimensions 200 x 200 the following 2 statements would have
the same result.

```cpp
auto mySprite = Sprite::create("mysprite.png");

auto mySprite = Sprite::create("mysprite.png", Rect(0,0,200,200));
```
