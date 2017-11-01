# 常用工具

## 3D 编辑器

3D 编辑器是用于构建 3D 模型的工具集合，有商业的和免费的可用，这是其中一些受欢迎的编辑器：

* [Blender (Free)](http://www.blender.org/)
* [3DS Max](http://www.autodesk.com/products/3ds-max/overview)
* [Cinema4D](http://www.maxon.net/products/)
* [Maya](http://www.autodesk.com/products/maya/overview)

大多数 3D 编辑器都能将文件保存成通用的格式，方便文件在其它编辑器中使用，同时也方便了游戏引擎对 3D 模型的导入和使用。

## Cocos2d-x 提供的工具

Cocos2d-x 提供了一个转换工具，可以将编辑器生成的通用格式转换为引擎支持的格式。

### fbx-conv 命令行

__`fbx-conv`__ 允许将 _FBX_ 格式转换为 Cocos2d-x 专有格式。 _FBX_ 是最受欢迎的 3D 文件格式，被所有编辑器支持。 命令行工具默认的导出文件格式是 _.c3b_ 。

命令行的使用：

{% codetabs name="shell", type="sh" -%}
fbx-conv [-a|-b|-t] FBXFile
{%- endcodetabs %}

参数含义：

* -?：显示帮助信息
* -a：导出文本格式和二进制格式
* -b：导出二进制格式
* -t：导出文本格式

示例：

{% codetabs name="shell", type="sh" -%}
fbx-conv -a boss.FBX
{%- endcodetabs %}

工具使用注意点：

* 模型需要一个至少包含一个纹理的材质
* 只支持骨骼动画
* 只支持一个骨骼对象，没有多个骨骼对象的支持
* 您可以通过导出多个静态模型来创建一个 3D 场景
* 网格顶点或索引的最大数量为 32767

## 3D 文件格式

Cocos2d-x 目前支持两种 3D 文件格式：

* Wavefront 对象文件：_.obj_ 文件
* Cocos2d-x 专有格式：_.c3t_ ，_.c3b_ 文件

支持 Wavefront 文件格式，因为它被 3D 编辑器广泛采用，并且非常容易解析。然而，它是有缺点的，不支持诸如动画的高级功能。

另一方面，_c3t_ 和 _c3b_ 是 Cocos2d-x 专有的文件格式，允许动画，材质和其它高级3D功能。_c3t_ 是文本格式，_c3b_ 是二进制格式。开发人员进行最终的游戏发布时应使用 _c3b_ ，因为使用它性能更好。如果是想要调试文件，或是跟踪其在 Git 或任何其他版本控制系统中的更改，则应使用 _c3t_ 。

注意：可以使用 _c3b_ 或 _c3t_ 文件，不能使用 _obj_ 文件，创建 _Animation3D_ 对象。
