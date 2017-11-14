# 调试

如果你希望在刚体周围绘制红框来帮助调试，那么可以简单的将这两行添加到物理场景的初始化代码中。你当然也可以学习官方测试项目，加一个菜单，在菜单的回调函数里控制是否打开调试功能。

{% codetabs name="C++", type="cpp" -%}
Director::getInstance()->getRunningScene()->getPhysics3DWorld()->setDebugDrawEnable(true);
Director::getInstance()->getRunningScene()->setPhysics3DDebugCamera(cameraObjecct);
{%- endcodetabs %}

## 禁用物理引擎

使用内置的物理引擎是个好的选择，它稳定又强大。不过，如果你的确想使用一些其它的物理引擎，只需要在 _base/ccConfig.h_ 文件中将 _CC_USE_PHYSICS_ 的值改为 0 禁用内置的物理引擎即可。
