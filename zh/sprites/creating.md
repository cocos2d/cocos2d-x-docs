# 精灵的创建

可以使用一张图像来创建精灵，*PNG, JPEG, TIFF, WebP*, 这几个格式都可以。当然也有一些其它的方式可以创建精灵，如使用 __图集__ 创建，通过 __精灵缓存__ 创建，我们会一个一个的讨论。本节介绍通过图像创建精灵。

## 使用图像创建

`Sprite` 能用一个特定的图像去创建:

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png");
{%- endcodetabs %}

![](../../en/sprites/sprites-img/i1.png "")

上面直接使用了 __mysprite.png__ 图像来创建精灵。精灵会使用整张图像，图像是多少的分辨率，创建出来的精灵就是多少的分辨率。比如图像是 200 x 200，`Sprite` 也是 200 x 200。

### 使用矩形

上一个例子，精灵和原始图像的尺寸一致。但是如果你想创建一个尺寸只有原始图像一部分的精灵，那你可以在创建的时候指定一个矩形，指定矩形需要四个值，初始 x 坐标，初始 y 坐标，矩形宽，矩形高。

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
{%- endcodetabs %}

![](../../en/sprites/sprites-img/i4.png "")

矩形的初始坐标，从图形的左上角开始算，即左上角的坐标是 (0, 0)，不是从左下角。因此结果精灵是图像左上角的一小块，从左上角开始算起，40 x 40 的大小。

如果你没指定一个矩形，Cocos2d-x 引擎就会自动使用这个图像全部的宽和高，看下面的例子，如果你把矩形的宽高指定为图像的宽高，矩形的初始坐标指定为 (0, 0)，那这就和第一种情况的效果是完全一样的。

{% codetabs name="C++", type="cpp" -%}
auto mySprite = Sprite::create("mysprite.png");

auto mySprite = Sprite::create("mysprite.png", Rect(0,0,200,200));

{%- endcodetabs %}
