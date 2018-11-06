# 相机(Camera)

玩家看到的 3D 游戏世界，就是游戏制作中 __`相机(Camera)`__ 对象查看到的场景，就如，观众看一部电影，看到的是电影拍摄时相机查看到的现实世界。游戏制作中的相机与电影拍摄时的相机作用是一样的。`Camera` 对象继承了 `Node` 对象，因此 `Camera` 支持大多数 `Action`。

相机有两种，一种是透视相机，一种是正交相机。透视相机看到的游戏世界具有远近效果，像这样：

![](../../en/3d/3d-img/PerspectiveCamera.png)

就好像眼睛观察现实世界，近处的对象较大，远处的对象较小。第一人称的游戏通常使用透视视角渲染。正交相机看到的游戏世界没有远近效果，看到的只是游戏世界一个方向的投影，像这样：

![](../../en/3d/3d-img/OrthographicCamera.png)

正交相机看到的 3D 对象，大小不会因为距离而变化。游戏中的迷你地图通常是用正交相机渲染，需要上帝视角的游戏，也会使用正交相机渲染。

## 使用相机

不用担心，相机听起来很复杂，但使用 Cocos2d-x 操作相机很容易。使用 3D 时，无需做任何特殊的操作即可创建 `Camera` 对象，每个场景都会根据 `Director` 对象的投影属性默认创建一个相机。如果需要多台相机，可以使用以下代码创建一个：

```cpp
auto s = Director::getInstance()->getWinSize();
auto camera = Camera::createPerspective(60, (GLfloat)s.width/s.height, 1, 1000);

// set parameters for camera
camera->setPosition3D(Vec3(0, 100, 100));
camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));

addChild(camera); //add camera to the scene
```

## 创建正交相机

默认的相机是透视相机，如果你想创建一个正交相机，这样做：

```cpp
Camera::createOrthographic();
```

示例：

```cpp
auto s = Director::getInstance()->getWinSize();
auto camera = Camera::createOrthographic(s.width, s.height, 1, 1000);
```

## 在相机中隐藏对象

有时候，你不想在一个相机视角让所有对象显现，比如需要在玩家的视野中隐藏一个角色。这在 Cocos2d-x 中很容易做到，在节点对象使用 `setCameraMask(CameraFlag)` 函数，或者在相机对象使用 `setCameraFlag(CameraFlag)` 函数，都可以达到同样的效果。

示例：

```cpp
//Camera
camera->setCameraFlag(CameraFlag::USER1);

//Node
node->setCameraMask(CameraFlag::USER1);
```
