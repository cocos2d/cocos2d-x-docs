# 地形(Terrain)

地形 `Terrain` 是 3D 游戏中重要的组成部分，地形就是通过载入一张高度图和若干张细节纹理，从而在场景中绘制若干高低不平的几何体，用以在游戏场景中模拟自然中的沙漠，草原等景象。从地形的资源构成角度来说，包含了下面几个元素：

## 高度图

高度图从本质而言，也是一张图片，但是图中的每一个像素的颜色值并不被当做颜色，而是被视为一个高度值。`Terrain` 对象通过高度图所给的高度信息，加以适当的缩放，构建出整个地形的网格结构。

## 细节图

如果说高度图确定了整个地形的几何形状，那么细节图则确定了地形的外观。通过将细节图贴在地形上，可以制造非常好的表现效果。最多可以使用四个纹理作为细节图。

## Alpha贴图

Alpha贴图用于控制细节图是在地形上何处以及如何绘制的。Alpha贴图从本质而言，也是一张图片，但是它将图片中每个像素中的 Red,Green,Blue 以及Alpha通道对应四张细节图在地形的某个位置上，每一张细节图颜色比例是多少。通过这种方式，我们就可以在地形上同时出现诸如沙丘，石板路，草地等纹理，使得地形的外观不再那么单调。

## 细节级别策略

`Terrain` 使用细节级别(Level Of Detail)策略，它根据摄像机离对象的远近，切换不同细节级别，达到一种近处的对象细节丰富，远处的对象细节简单，这样减少了整体需要渲染的三角形数量，提高了性能。

可以使用 `Terrain::setLODDistance(float lod1, float lod2, float lod3` 方法设置摄像机的距离。 具有不同细节级别的地形相邻块可能存在裂缝，`Terrain` 提供了两种方式(裙边法，补边法)避免这种情况的出现：

{% codetabs name="C++", type="cpp" -%}
Terrain::CrackFixedType::SKIRT

Terrain::CrackFixedType::INCREASE_LOWER
{%- endcodetabs %}

__Terrain::CrackFixedType::SKIRT__ 裙边法：在块的每个边缘生成四个裙状网格

__Terrain::CrackFixedType::INCREASE_LOWER__ 补边法：动态调整每个快的索引，使其无缝连接

## 创建地形

下面代码演示了如何创建一个地形，并在上面放一个精灵

{% codetabs name="C++", type="cpp" -%}
auto player = Sprite3D::create("chapter9/orc.c3b");
player->setScale(0.08);
player->setPositionY(terrain->getHeight(player->getPositionX(),player->getPositionZ()));
{%- endcodetabs %}

![](../../en/3d/3d-img/9_10.png)

* 通过 `Terrain::DetailMap` 对象创建细节图：

{% codetabs name="C++", type="cpp" -%}
Terrain::DetailMap r("dirt.dds");
Terrain::DetailMap g("grass.dds");
Terrain::DetailMap b("road.dds");
Terrain::DetailMap a("greenSkin.jpg");
{%- endcodetabs %}

* 构造 `Terrain::TerrainData` 对象，构造函数的第一个参数为高度图的路径，第二个参数为 Alpha 贴图的路径，接下来的四个参数为之前所构造的四个 DetailMap 结构体。

{% codetabs name="C++", type="cpp" -%}
Terrain::TerrainData data("chapter9/heightmap16.jpg","TerrainTest/alphamap.png", r, g, b, a);
{%- endcodetabs %}

* 调用 `Terrain::create` 创建出地形，第一个参数是之前构造好的 `TerrainData` 对象，第二个参数是细节级别策略。

{% codetabs name="C++", type="cpp" -%}
_terrain = Terrain::create(data, Terrain::CrackFixedType::SKIRT);
{%- endcodetabs %}

* 请注意，在地形对象被添加到节点或场景中(进行了 `addChild()` 操作)后，就不能再对地形对象使用转换，比如缩放大小。 否则，`Terrain` 的方法可能会造成难以预料的结果。

### 获取地形高度

使用方法 `Terrain::getHeight(float x, float z, Vec3 * normal= nullptr)` 可以获取到地形的高度，当你想把一个节点对象放到地形表面的时候，这个方法会非常有用。

### Ray-Terrain intersection test

A __Ray-Terrain__ intersection test will calculate the intersection point by giving
a specified position.

__Terrain::CrackFixedType::SKIRT__ will generate four skirt-like meshes at each
chunks edge.

__Terrain::CrackFixedType::INCREASE_LOWER__ will dynamically adjust each chunks
index to seamlessly connect them.
