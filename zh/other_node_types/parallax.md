# 视差滚动

视差滚动是指让多层背景以不同的速度移动，从而形成的立体运动效果。比如超级马里奥游戏中，角色所在地面的移动与背景天空的移动，就是一个视差滚动。Cocos2d-x 通过 __`ParallaxNode`__ 对象模拟视差滚动。可以通过序列控制移动，也可以通过监听鼠标，触摸，加速度计，键盘等事件控制移动。`ParallaxNode` 对象比常规节点对象复杂一些，因为为了呈现不同的移动速度，需要多个子节点。它类似 `Menu` 像一个容器，本身不移动，移动的是被添加进入其中的不同子节点。`ParallaxNode` 的创建：

{% codetabs name="C++", type="cpp" -%}
// create ParallaxNode
auto paraNode = ParallaxNode::create();
{%- endcodetabs %}

添加多个节点对象：

{% codetabs name="C++", type="cpp" -%}
// create ParallaxNode
auto paraNode = ParallaxNode::create();

// background image is moved at a ratio of 0.4x, 0.5y
paraNode->addChild(background, -1, Vec2(0.4f,0.5f), Vec2::ZERO);

// tiles are moved at a ratio of 2.2x, 1.0y
paraNode->addChild(middle_layer, 1, Vec2(2.2f,1.0f), Vec2(0,-200) );

// top image is moved at a ratio of 3.0x, 2.5y
paraNode->addChild(top_layer, 2, Vec2(3.0f,2.5f), Vec2(200,800) );
{%- endcodetabs %}

需要注意的是，被添加的每个 Node 对象被赋予了一个唯一的 `z-order` 顺序，以便他们堆叠在彼此之上。另外要注意 `addChild()` 调用中两个 `Vec2` 参数，第一个决定这个子节点的移动速度与父节点移动速度的比率，第二个是相对父节点 `ParallaxNode` 的偏移量。

在文本中很难展示视差滚动，请运行本文档的代码示例吧！
