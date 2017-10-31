# 3D 精灵

就像 2D 游戏一样, 3D 游戏也有精灵对象, Cocos2d-x 提供的 3D 精灵对象是 `Sprite3D`, 3D 空间位置有三个方向的自由度, 类似的 `Sprite3D` 的位置由 (x, y, z) 三个坐标值决定.

`Sprite3D` 在许多方面都和普通的 `Sprite` 一样.

创建并加载:

{% codetabs name="C++", type="cpp" -%}
auto sprite = Sprite3D::create("boss.c3b"); //c3b file, created with the FBX-converter
sprite->setScale(5.f); //sets the object scale in float
sprite->setPosition(Vec2(200,200)); //sets sprite position
scene->addChild(sprite,1); //adds sprite to scene, z-index: 1
{%- endcodetabs %}

这个对象是通过 _.c3b_ 文件创建的, 效果是这样:

![](../../en/3d/3d-img/9_1.png)

创建一个动作使这个模型不断旋转:

{% codetabs name="C++", type="cpp" -%}
//rotate around the X axis
auto rotation = RotateBy::create(15, Vec3(0, 360, 0));
//our sprite object runs the action
sprite->runAction(RepeatForever::create(rotation));
{%- endcodetabs %}

设置锚点, 与 `Sprite` 方法一样:

{% codetabs name="C++", type="cpp" -%}
sprite->setAnchorPoint(Point(0.0f,0.0f));
{%- endcodetabs %}

## 模型附加

回想一下, 3D 模型是网格的集合, 网格可以再组合, 所以为了创建丰富的效果, 你可以将 3D 模型附加到其它 3D 模型.

一个例子是向一个角色添加一把武器. 首先使用 `getAttachNode(attachment_point_name)` 获取到附加点, 然后使用 `addChild()` 方法把武器模型添加上去.

效果如下:

{% codetabs name="C++", type="cpp" -%}
auto sp = Sprite3D::create("axe.c3b");
sprite->getAttachNode("Bip001 R Hand")->addChild(sp);
{%- endcodetabs %}

![](../../en/3d/3d-img/9_3.png)

以此为例, 结合多个简单的模型, 你就能创建复杂的模型.

## 网格替换

进行 3D 游戏开发时, 你可能需要对模型进行动态更改. 如果创建的模型是由网格组成, 那你就能通过 `getMeshByIndex()` `getMeshByName()` 访问到网格数据, 然后进行一些控制. 比如使用这个功能替换一个角色的武器或者衣服.

以一个穿着外套的角色为例:

![](../../en/3d/3d-img/9_4.png)

我们通过使用网格对象, 替换掉外套, 下面是演示代码:

{% codetabs name="C++", type="cpp" -%}
auto sprite = Sprite3D::create("ReskinGirl.c3b");

// display the first coat
auto girlTop0 = sprite->getMeshByName("Girl_UpperBody01");
girlTop0->setVisible(true);

auto girlTop1 = sprite->getMeshByName("Girl_UpperBody02");
girlTop1->setVisible(false);

// swap to the second coat
girlTop0->setVisible(false);
girlTop1->setVisible(true);
{%- endcodetabs %}

效果:

![](../../en/3d/3d-img/9_4_0.png)
