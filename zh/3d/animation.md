# 3D 动画

我们知道 3D 精灵对游戏很重要, 也学会了如何操纵, 但是可能还希望能有一些更丰富的效果.

那就添加动画吧!

要运行 3D 动画, 你需要使用 `Animation3D` 和 `Animate3D` 对象, 首先用 `Animation3D` 加载一个动画文件, 然后使用 `Animate3D` 完成添加.

示例:

{% codetabs name="C++", type="cpp" -%}
// the animation is contained in the .c3b file
auto animation = Animation3D::create("orc.c3b");

// creates the Action with Animation object
auto animate = Animate3D::create(animation);

// runs the animation
sprite->runAction(RepeatForever::create(animate));
{%- endcodetabs %}

去运行本文档的代码示例看看效果, _记住, 3D 动画与 2D 动画基本相同. 可参考本文档的 [第四章](../actions/index.md)_

## 多动画

当想同时运行多个动画时, 该怎么办? 你可以创建多个动画, 并指定开始时间和动画长度参数, 两个参数的单位都是秒. 例如:

{% codetabs name="C++", type="cpp" -%}
auto animation = Animation3D::create(fileName);

auto runAnimate = Animate3D::create(animation, 0, 2);
sprite->runAction(runAnimate);

auto attackAnimate = Animate3D::create(animation, 3, 5);
sprite->runAction(attackAnimate);
{%- endcodetabs %}

在上面的例子中, 有两个动画可以运行, 第一个从动画启动时开始然后持续 2 秒, 第二个在 3 秒时开始然后持续 5 秒.

## 动画速度

动画速度由一个整数控制, 整数的绝对值代表动画的持续时间, 整数大于零动画正序播放, 整数小于零倒序播放. 速度设置为 10 意味着动画在 10 秒内正序播放完.

## 动画混合

使用多个动画时, 会在每个动画之间自动应用混合, 混合的目的是为了创造平滑的过渡. 给定两个动画 A 和 B,  动画 A 最后一小段时间的几帧会和动画 B 前一小段时间的几帧重叠, 这使得动画的变化看起来很自然. 默认的混合的时间是 0.1 秒, 你可以使用 `Animate3D::setTransitionTime` 更改默认的混合时间.

Cocos2d-x 支持关键帧之间的线性插值, 这能填补曲线上的空白, 确保光滑的路径. 如果在模型构建时指定的其它插值方法, 我们内置的工具 _fbx-conv_ 将生成额外的关键帧, 这种补偿通常根据目标框架完成.
 _有关 fbx-conv 的更多信息, 请参考本章末尾的讨论_
