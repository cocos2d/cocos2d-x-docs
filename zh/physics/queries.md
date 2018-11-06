# 查询

你肯定有站着一个地方往四周看的经历？你能看到离你近的地方，也能看到离你远的东西，你能判断出它们离你有多远。物理引擎也提供了类似的空间查询功能。

Cocos2d-x 提供的 `PhysicsWorld` 对象支持点查询，射线查询和矩形查询。

## 点查询

当你碰到什么东西，比如说你的桌子的时候，你可以将这种情景作为一个点查询的例子。点查询是检查一个点周围的一定距离内是否有物体。通过点查询你可以找到一个物体中距离某定点最近的点，或者找到距离一个定点最近的物体，这非常适合于判断鼠标点击拾取的对象，也可以利用它进行一些其它的简单感知。

## 射线查询

当你四处看的时候，在你视线内的某些物体肯定会引起你的注意，你可以将这种情景作为一个射线查询的例子。射线查询是检查从一个定点发出的射线是否相交于一个物体，如果相交可以获取到一个交叉点，这非常适合于判断子弹（忽略子弹的飞行时间）是否命中。

示例：

```cpp
void tick(float dt)
{
    Vec2 d(300 * cosf(_angle), 300 * sinf(_angle));
    Vec2 point2 = s_centre + d;
    if (_drawNode)
    {
        removeChild(_drawNode);
    }
    _drawNode = DrawNode::create();

    Vec2 points[5];
    int num = 0;
    auto func = [&points, &num](PhysicsWorld& world,
        const PhysicsRayCastInfo& info, void* data)->bool
    {
        if (num < 5)
        {
            points[num++] = info.contact;
        }
        return true;
    };

    s_currScene->getPhysicsWorld()->rayCast(func, s_centre, point2, nullptr);

    _drawNode->drawSegment(s_centre, point2, 1, Color4F::RED);
    for (int i = 0; i < num; ++i)
    {
        _drawNode->drawDot(points[i], 3, Color4F(1.0f, 1.0f, 1.0f, 1.0f));
    }
    addChild(_drawNode);

    _angle += 1.5f * (float)M_PI / 180.0f;
}
```

![](../../en/physics/physics-img/RayTest.gif)

## 矩形查询

矩形查询提供了一种快速检查区域中有哪些物体的方法，实现起来非常容易：

```cpp
auto func = [](PhysicsWorld& world, PhysicsShape& shape, void* userData)->bool
{
    //Return true from the callback to continue rect queries
    return true;
}

scene->getPhysicsWorld()->queryRect(func, Rect(0,0,200,200), nullptr);
```

这是在制作 Logo 击碎时使用矩形查询的例子：

![](../../en/physics/physics-img/rectQuery1.gif)

![](../../en/physics/physics-img/rectQuery2.gif)
