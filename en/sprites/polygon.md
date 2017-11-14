## Polygon Sprite
A __Polygon Sprite__ is also a `Sprite`, that is used to display a 2d image.
However, unlike a normal `Sprite` object, which is a rectangle made of just 2
triangles, `PolygonSprite` objects are made of a series of triangles.

#### Why use a Polygon Sprite?
Simple, __performance__!

There is a lot of technical jargon that we can toss around here about __pixel fill rate__
but the take home lesson is that a `PolygonSprite` draws based upon the shape of
your `Sprite`, not a simple rectangle around the largest width and height. This
saves a lot of unnecessary drawing. Consider this example:

![](sprites-img/polygonsprite.png "")

Notice the difference between the left and right versions?

On the left, a typical `Sprite` drawn in rectangular fashion by the use of 2
triangles.

On the right, a `PolygonSprite` drawn with many smaller triangles.

Whether or not this trade-off is worth it for purely performance reasons depends
on a number of factors (sprite shape/detail, size, quantity drawn on screen, etc.),
but in general, *vertices are cheaper than pixels* on modern GPUs.

<!--Now more and more GPUs were tailor designed to do 3d graphics, which can handle loads of vertices, but limited in Pixel Fill-Rate. But by representing almost always "None-rectangular" 2d images with a rectangular quad, GPU wastes precious bandwidth drawing totally transparent part of the sprite.

Take the above Grossini example, the left side is a normal Sprite, the right side is the same image but with 18 triangles and 20 vertices. Because the triangles were such a "tight fit", the 18 triangles counts only 4089 pixels surface area compared to the quad version which is 10285 pixels, that is 60% pixels saved!

![](sprites-img/polygonsprite.png "")

Here is a performance test.The test keep on adding dynamic sprite to the screen until it reach down to 40 fps, the numbers are how many SpritePolygon or Sprite it can run stably at 40PS.

| Devices        | Sprite  | Polygon Sprite| Promotion|
| -------------- |:-------:| :------------:| :-------:|
| iPhone 6 plus  | 259     | 566           | 118.53%  |
| Samsung 9100   | 365     | 526           | 44.1%    |
| rMBP late 2013 | 471     | 1150          | 144.16%  |
-->
#### AutoPolygon
`AutoPolygon` is a helper class. It's purpose is to process an image into a 2d
polygon mesh at runtime.

There are functions for each step in the process, from tracing all the points,
to triangulation. The result, can be then passed to a `Sprite` objects __create__
function to create a `PolygonSprite`. Example:

{% codetabs name="C++", type="cpp" -%}
// Generate polygon info automatically.
auto pinfo = AutoPolygon::generatePolygon("filename.png");

// Create a sprite with polygon info.
auto sprite = Sprite::create(pinfo);
{%- endcodetabs %}
