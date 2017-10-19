# 多边形精灵

__多边形精灵(Polygon Sprite)__ 也是一个精灵, 同样是为了展示一个可以被控制的图像, 但是和普通精灵的区别是, 普通精灵在绘图处理中被分为了两个三角形, 多边形精灵则是被分为了一系列三角形.

## 为什么要使用多边形精灵

__提高性能__!

要深入分析这个是如何提高性能的, 会需要很多和像素填充率有关的技术术语. 幸好本节是入门性质的文档, 能让大家理解多边形精灵比普通精灵性能好就可以了, 不用讨论特定宽高矩形绘制时的性能问题.

![](sprites-img/polygonsprite.png "")

注意左右两种情况的不同.

左侧, 是一个典型的精灵绘制时的处理, 精灵被处理成一个有两个三角形组成的矩形.

右侧, 是一个多边形精灵绘制时的处理, 精灵被处理成一系列小的三角形.

显然可以看到, 右侧多边形精灵需要绘制的像素数量比左侧精灵需要的像素数量更小, 但是由于划分了多个三角形出现了更多的顶点, 由于在现代的图形处理中, 一般绘制定点比绘制像素消耗的性能少. 所以多边形精灵的性能更好, 实际的测试结果也验证了这一点.

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

## AutoPolygon

__`AutoPolygon`__ 是一个工具类, 它可以在程序运行时, 通过跟踪关键点和三角测量, 将一个矩形图像划分成一系列小三角形块.

首先将图像资源传入 `AutoPolygon` 进行处理, 然后我们使用它生成的对象进行精灵的创建就能得到多边形精灵.

{% codetabs name="C++", type="cpp" -%}
// Generate polygon info automatically.
auto pinfo = AutoPolygon::generatePolygon("filename.png");

// Create a sprite with polygon info.
auto sprite = Sprite::create(pinfo);
{%- language name="JavaScript", type="js" -%}
// Generate polygon info automatically.
var pinfo = cc.autopolygon.generatePolygon(res.mysprite_png);

// Create a sprite with polygon info.
var sprite = new cc.Sprite(pinfo);
{%- endcodetabs %}
