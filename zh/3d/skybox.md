# 天空盒(Skybox)

__`天空盒(Skybox)`__ 是整个场景的一个包裹，显示了几何之外的世界。你可以使用 `Skybox` 来模拟无限的天空，山脉等现象。

![](../../en/3d/3d-img/Skybox.png)

`Skybox` 的创建：

{% codetabs name="C++", type="cpp" -%}
// create a Skybox object
auto box = Skybox::create();

// set textureCube for Skybox
box->setTexture(_textureCube);

// attached to scene
_scene->addChild(box);
{%- endcodetabs %}
