# 瓦片地图

在游戏开发过程中，我们会遇到超过屏幕大小的地图，例如在即时战略游戏中，它使得玩家可以在地图中滚动游戏画面。这类游戏通常会有丰富的背景元素，如果直接使用背景图切换的方式，需要为每个不同的场景准备一张背景图，而且每个背景图都不小，这样会造成资源浪费。

瓦片地图就是为了解决这问题而产生的。一张大的世界地图或者背景图可以由几种地形来表示，每种地形对应一张小的的图片，我们称这些小的地形图片为瓦片。把这些瓦片拼接在一起，一个完整的地图就组合出来了，这就是瓦片地图的原理。

在 Cocos2d-x 中，瓦片地图实现的是 TileMap 方案，TileMap 要求每个瓦片占据地图上一个四边形或六边形的区域。把不同的瓦片拼接在一起，就可以组成完整的地图。TileMap 使用一种基于 XML 的 TMX 格式文件。

使用 TMX 文件创建一个瓦片地图：

```cpp
// reading in a tiled map.
auto map = TMXTiledMap::create("TileMap.tmx");
addChild(map, 0, 99); // with a tag of '99'
```

瓦片地图可能有许多层，通过层名获取到一个特定的层。

```cpp
// how to get a specific layer
auto map = TMXTiledMap::create("TileMap.tmx");
auto layer = map->getLayer("Layer0");
auto tile = layer->getTileAt(Vec2(1, 63));
```

每个瓦片都有独一无二的位置和 ID，这使得我们很容易选择特定的瓦片。

通过位置访问：

```cpp
// to obtain a specific tiles id
unsigned int gid = layer->getTileGIDAt(Vec2(0, 63));
```

瓦片地图布局示例：

![](../../en/other_node_types/other_node_types-img/tilemap1.png "timemap1")

![](../../en/other_node_types/other_node_types-img/tilemap2.png "timemap2")

有很多工具可以用来制作瓦片地图，[Tiled](//mapeditor.org) 就是其中一款流行的制作工具，它有一个活跃的用户社区。推荐你去使用，上面的屏幕截图就来自 [Tiled](//mapeditor.org) 的项目。
