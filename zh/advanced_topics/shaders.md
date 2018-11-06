# 着色器和材质

## 什么是着色器

从维基百科：

在计算机图形学领域，__着色器(Shader)__ 是一种特殊类型的计算机程序，最初用于做阴影，在图像中产生适当的光照、明暗，现在主要用于产生特殊效果，也用于视频后期处理。

非专业人士的定义可能是：告诉计算机如何以一种特定的方式绘制东西的程序。简单地说，着色器就是运行在 GPU 上用于图像渲染的一段程序，Cocos2d-x 用它绘制节点。

Cocos2d-x 使用的着色器语言是 [OpenGL ES Shading Language v1.0](https://www.khronos.org/opengles/)，描述 GLSL 语言不在本文的范围之内。想了解更多，请参考 [规范文档](https://www.khronos.org/files/opengles_shading_language.pdf)。在 Cocos2d-x 中，所有的可渲染的 Node 对象都使用着色器。比如，`Sprite` 对象使用为 2D 精灵优化过的着色器，`Sprite3D` 使用为 3D 对象优化过的着色器。

## 自定义着色器

开发者能为任一 Cocos2d-x 的节点对象设置自定义的着色器，添加着色器示例：

```cpp
sprite->setGLProgramState(programState);
sprite3d->setGLProgramState(programState);
```

`GLProgramState` 对象包含两个重要的东西

- `GLProgram`：从根本上来说就是着色器。包含一个顶点着色器和一个像素着色器。
- 状态属性：根本上来说就是着色器的 uniform 变量

如果你不熟悉 uniform 变量也不知道为什么需要它，请参考刚才提到的 [语言规范](https://www.khronos.org/files/opengles_shading_language.pdf)

可以很容易的将 uniform 变量设置到  `GLProgramState`：

```cpp
glProgramState->setUniformFloat("u_progress", 0.9);
glProgramState->setUniformVec2("u_position", Vec2(x,y));
glProgramState->setUniformMat4("u_transform", matrix);
```

你还可以将一个回调函数设置成 uniform 变量，下面是一个 lambda 表达式作为回调函数的例子：

```cpp
glProgramState->setUniformCallback("u_progress", [](GLProgram* glProgram, Uniform* uniform)
{
    float random = CCRANDOM_0_1();
    glProgram->setUniformLocationWith1f(uniform->location, random);
}
);
```

虽然可以手动设置 `GLProgramState` 对象，但更简单的方法是使用材质对象。

## 什么是材质

设想你想在游戏中画一个这样的球体：

![](../../en/advanced_topics/advanced_topics-img/model.jpg)

你要做的第一件事就是定义它的几何形状，像这样：

![](../../en/advanced_topics/advanced_topics-img/geometry.jpg)

然后定义砖块纹理，像这样：

![](../../en/advanced_topics/advanced_topics-img/brick.jpg)

这样做也能达成目标的效果，但是如果进一步的考虑：

- 如果当球体离相机很远时，想使用质量较低的纹理呢？
- 如果想对砖块应用模糊效果呢？
- 如果想启用或者禁用球体中的照明呢？

答案是使用 __材质(Material)__，而不是使用一个简单的纹理。对于材质，你可以拥有多个纹理，还可以拥有其它的一些特性，比如多重渲染。

材质对象通过 _.material_ 文件创建，其中包含以下信息：

- 材质有一个或多个渲染方法(technique)
- 每个渲染方法有一个或多个通道(pass)
- 每个通道有：
  - 一个渲染状态(RenderState)
  - 一个包含了 uniform 变量的着色器

例如，这是一个材质文件：

```javascript
// A "Material" file can contain one or more materials
material spaceship
{
    // A Material contains one or more Techniques.
    // In case more than one Technique is present, the first one will be the default one
    // A "Technique" describes how the material is going to be renderer
    // Techniques could:
    //  - define the render quality of the model: high quality, low quality, etc.
    //  - lit or unlit an object
    // etc...
    technique normal
    {
        // A technique can contain one or more passes
        // A "Pass" describes the "draws" that will be needed
        //   in order to achieve the desired technique
        // The 3 properties of the Passes are shader, renderState and sampler
        pass 0
        {
            // shader: responsible for the vertex and frag shaders, and its uniforms
            shader
            {
                vertexShader = Shaders3D/3d_position_tex.vert
                fragmentShader = Shaders3D/3d_color_tex.frag

                // uniforms, including samplers go here
                u_color = 0.9,0.8,0.7
                // sampler: the id is the uniform name
                sampler u_sampler0
                {
                    path = Sprite3DTest/boss.png
                    mipmap = true
                    wrapS = CLAMP
                    wrapT = CLAMP
                    minFilter = NEAREST_MIPMAP_LINEAR
                    magFilter = LINEAR
                }
            }
            // renderState: responsible for depth buffer, cullface, stencil, blending, etc.
            renderState
            {
                cullFace = true
                cullFaceSide = FRONT
                depthTest = true
            }
        }
    }
}
```

将一个材质设置到 `Sprite3D` 的方法：

```cpp
Material* material = Material::createWithFilename("Materials/3d_effects.material");
sprite3d->setMaterial(material);
```

如果你想改变不同的渲染方法，你可以这样做：

```cpp
material->setTechnique("normal");
```

### 渲染方法(Technique)

你只能为一个 `Sprite3D` 绑定一个材质，但这并不意味着固定了一种渲染方式。材质(Material)有一个特性：允许包含多个 __渲染方法(Technique)__，当一个材质被加载时，所有的渲染方法也都被提前加载。有了这个特性，你就可以在运行时方便快速的改变一个对象的渲染效果。

通过使用 `Material::setTechnique(const std::string& name)` 函数，就可以完成渲染方法的切换。这种特性可以用来处理不同灯光的变换，也可以用来处理，在渲染的对象离相机很远时采用质量较低的纹理这种情景。

### 通道(Pass)

一个渲染方法可以有多个渲染 __通道(Pass)__，其中一个通道对应一次渲染，多通道意味着对一个对象渲染多次，这被称为多通道渲染，也叫多重渲染。每个通道有两个主要的对象：

- `RenderState`：包含 GPU 状态信息，如 _depthTest_, _cullFace_,
    _stencilTest_，等
- `GLProgramState`：包含要使用的着色器，和一些 uniform 变量

### 材质文件格式

Cocos2d-x 的材质文件使用一种优化过的文件格式，同时与其它一些开源引擎的材质文件格式类似，如 _GamePlay3D_，_OGRE3D_。

注意点：

- 材质文件的扩展名无关紧要，建议使用 _.material_ 作为扩展名
- 顶点着色器和像素着色器的文件扩展名也无关紧要，建议使用 _.vert_ 和 _.frag_
- _id_ 是材质(Meterial)，渲染方法(technique)，通道(pass)的可选属性
- 材质可以通过设置 _parent_material_id_ 继承其它材质的值

```cpp
// When the .material file contains one material
sprite3D->setMaterial("Materials/box.material");
// When the .material file contains multiple materials
sprite3D->setMaterial("Materials/circle.material#wood");
```

#### 字段定义

<table>
 <tr>
  <td><a name=material>material</a> <span class=Non-literal><span style='font-family:"Courier New"'>material_id</span></span> : <span class=Non-literal><span style='font-family:"Courier New"'>parent_material_id</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  renderState {}</td>
  <td>[0..1]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>  technique <span class=Non-literal><span style='font-family: "Courier New"'>id </span></span>{}</td>
  <td>[0..*]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
</table>

<table>
 <tr>
  <td><a name=technique>technique</a> <span class=Non-literal><span style='font-family:"Courier New"'>technique_id</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  renderState {}</td>
  <td>[0..1]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>  pass <span class=Non-literal><span style='font-family:"Courier New"'>id </span></span>{}</td>
  <td>[0..*]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
</table>

<table>
 <tr>
  <td><a name=pass>pass </a><span class=Non-literal><span style='font-family:"Courier New"'>pass_id</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  renderState {}</td>
  <td>[0..1]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>  shader {}</td>
  <td>[0..1]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
</table>

<table>
 <tr>
  <td><a name=renderState>renderState</a></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  blend = <span class=Non-literal><span style='font-family: "Courier New"'>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>  blendSrc = <a href="#BLEND_ENUM">BLEND_ENUM</a></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>  blendDst = <a href="#BLEND_ENUM">BLEND_ENUM</a></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>  cullFace = <span class=Non-literal><span style='font-family: "Courier New"'>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>  depthTest = <span class=Non-literal><span style='font-family: "Courier New"'>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>  depthWrite = <span class=Non-literal><span style='font-family: "Courier New"'>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>&nbsp; frontFace = <span class="Non-literal"><span>CW | CCW</span></span></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>&nbsp; depthTest = <span class="Non-literal"><span>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>&nbsp; depthWrite = <span class="Non-literal"><span>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>&nbsp; depthFunc = <a href="#wiki-FUNC_ENUM">FUNC_ENUM</a></td>
  <td>[0..1]</td>
  <td>enum</td>
  </tr>
 <tr>
  <td>&nbsp; stencilTest = <span class="Non-literal"><span>false</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>&nbsp; stencilWrite = <span class="Non-literal"><span>4294967295</span></span></td>
  <td>[0..1]</td>
  <td>uint</td>
 </tr>
<tr>
<td>&nbsp; stencilFunc = <a href="#wiki-FUNC_ENUM">FUNC_ENUM</a></td>
<td>[0..1]</td>
<td>enum</td>
</tr>
<tr>
<td>&nbsp; stencilFuncRef = <span class="Non-literal"><span>0</span></span></td>
<td>[0..1]</td>
<td>int</td>
</tr>
<tr>
<td>&nbsp; stencilFuncMask = <span class="Non-literal"><span>4294967295</span></span></td>
<td>[0..1]</td>
<td>uint</td>
</tr>
<tr>
<td>&nbsp; stencilOpSfail = <a href="#wiki-STENCIL_OP_ENUM">STENCIL_OPERATION_ENUM</a></td>
<td>[0..1]</td>
<td>enum</td>
</tr>
<tr>
<td>&nbsp; stencilOpDpfail = <a href="#wiki-STENCIL_OP_ENUM">STENCIL_OPERATION_ENUM</a> </td>
<td>[0..1]</td>
<td>enum</td>
</tr>
<tr>
<td>&nbsp; stencilOpDppass = <a href="#wiki-STENCIL_OP_ENUM">STENCIL_OPERATION_ENUM</a></td>
<td>[0..1]</td>
<td>enum</td>
</tr>
</table>

<table>
 <tr>
  <td><a name=shader>shader</a><span class=Non-literal><span style='font-family:"Courier New"'>shader_id</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  vertexShader = <span class=Non-literal><span style='font-family:"Courier New"'>res/colored.vert</span></span></td>
  <td>[0..1]</td>
  <td>file path</td>
 </tr>
 <tr>
  <td>  fragmentShader = <span class=Non-literal><span style='font-family:"Courier New"'>res/colored.frag</span></span></td>
  <td>[0..1]</td>
  <td>file path</td>
 </tr>
 <tr>
  <td>  defines = <span class=Non-literal><span style='font-family: "Courier New"'>semicolon separated list</span></span></td>
  <td>[0..1]</td>
  <td>string</td>
 </tr>
 <tr>
  <td><span class=Non-literal><span style='font-family:"Courier New"'>&nbsp;</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td><span class=Non-literal><span style='font-family:"Courier New"'>  uniform_name </span></span>=<span class=Non-literal><span style='font-family: "Courier New"'> </span></span><a href="#scalar">scalar</a><span class=Non-literal><span style='font-family:"Courier New"'> | </span></span><a href="#vector">vector</a></td>
  <td>[0..*]</td>
  <td>uniform</td>
 </tr>
 <tr>
  <td>  <span class=Non-literal><span style='font-family:"Courier New"'>uniform_name </span></span>= <a href="#AUTO_BIND_ENUM">AUTO_BIND_ENUM</a></td>
  <td>[0..*]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>  sampler <span class=Non-literal><span style='font-family: "Courier New"'>uniform_name </span></span>{}</td>
  <td>[0..*]</td>
  <td>block</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
</table>

<table>
 <tr>
  <td><a name=sampler>sampler</a> <span class=Non-literal><span style='font-family:"Courier New"'>uniform_name</span></span></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>  path = <span class=Non-literal><span style='font-family:"Courier New"'>res/wood.png | @wood</span></span></td>
  <td>[0..1]</td>
  <td>image path</td>
 </tr>
 <tr>
  <td>  mipmap = <span class=Non-literal><span style='font-family: "Courier New"'>bool</span></span></td>
  <td>[0..1]</td>
  <td>bool</td>
 </tr>
 <tr>
  <td>  wrapS = <span class=Non-literal><span style='font-family: "Courier New"'>REPEAT | CLAMP</span></span></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>  wrapT = <span class=Non-literal><span style='font-family: "Courier New"'>REPEAT | CLAMP</span></span></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td> minFilter = <a href="#TEXTURE_MIN_FILTER_ENUM">TEXTURE_MIN_FILTER_ENUM</a></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>  magFilter = <a href="#TEXTURE_MAG_FILTER_ENUM">TEXTURE_MAG_FILTER_ENUM</a></td>
  <td>[0..1]</td>
  <td>enum</td>
 </tr>
 <tr>
  <td>}</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
 </tr>
</table>

#### 枚举类型定义

<table>
 <tr>
  <th align="left"><a name="TEXTURE_MIN_FILTER_ENUM"></a><b>TEXTURE_MIN_FILTER_ENUM</b></th>
  <th>&nbsp;</th>
 </tr>
 <tr>
  <td>NEAREST</td>
  <td>Lowest quality non-mipmapped</td>
 </tr>
 <tr>
  <td>LINEAR</td>
  <td>Better quality non-mipmapped</td>
 </tr>
 <tr>
  <td>NEAREST_MIPMAP_NEAREST</td>
  <td>Fast but low quality mipmapping</td>
 </tr>
 <tr>
  <td>LINEAR_MIPMAP_NEAREST</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>NEAREST_MIPMAP_LINEAR</td>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>LINEAR_MIPMAP_LINEAR</td>
  <td>Best quality mipmapping</td>
 </tr>
</table>

<table>
 <tr>
  <th align="left"><a name="TEXTURE_MAG_FILTER_ENUM"></a><b>TEXTURE_MAG_FILTER_ENUM</b></th>
  <th>&nbsp;</th>
 </tr>
 <tr>
  <td>NEAREST</td>
  <td>Lowest quality</td>
 </tr>
 <tr>
  <td>LINEAR</td>
  <td>Better quality</td>
 </tr>
</table>

<table>
 <tr>
  <th align="left"><a name="BLEND_ENUM"></a><b>BLEND_ENUM</b></th>
  <th>&nbsp;</th>
 </tr>
 <tr>
  <td>ZERO</td>
  <td>ONE_MINUS_DST_ALPHA</td>
 </tr>
 <tr>
  <td>ONE</td>
  <td>CONSTANT_ALPHA</td>
 </tr>
 <tr>
  <td>SRC_ALPHA</td>
  <td>ONE_MINUS_CONSTANT_ALPHA</td>
 </tr>
 <tr>
  <td>ONE_MINUS_SRC_ALPHA</td>
  <td>SRC_ALPHA_SATURATE</td>
 </tr>
 <tr>
  <td>DST_ALPHA</td>
  <td>&nbsp;</td>
 </tr>
</table>

<table>
 <tr>
  <th align="left"><a name="wiki-CULL_FACE_SIDE_ENUM"></a><b>CULL_FACE_SIDE_ENUM</b></th><th></th>
 </tr>
 <tr>
  <td>BACK</td>
  <td>Cull back-facing polygons.</td>
 </tr>
 <tr>
  <td>FRONT</td>
  <td>Cull front-facing polygons.</td>
 </tr>
 <tr>
  <td>FRONT_AND_BACK</td>
  <td>Cull front and back-facing polygons.</td>
 </tr>
</table>

<table>
 <tr>
  <th align="left"><a name="wiki-FUNC_ENUM"></a><b>FUNC_ENUM</b></th>
  <th></th>
 </tr>
 <tr>
  <td>NEVER</td>
  <td>ALWAYS</td>
 </tr>
 <tr>
  <td>LESS</td>
  <td>GREATER</td>
 </tr>
 <tr>
  <td>EQUAL</td>
  <td>NOTEQUAL</td>
 </tr>
 <tr>
  <td>LEQUAL</td>
  <td>GEQUAL</td>
 </tr>
</table>

<table>
 <tr>
  <th align="left"><a name="wiki-STENCIL_OP_ENUM"></a><b>STENCIL_OPERATION_ENUM</b></th>
  <th></th>
 </tr>
 <tr>
  <td>KEEP</td>
  <td>REPLACE</td>
 </tr>
 <tr>
  <td>ZERO</td>
  <td>INVERT</td>
 </tr>
 <tr>
  <td>INCR</td>
  <td>DECR</td>
 </tr>
 <tr>
  <td>INCR_WRAP</td>
  <td>DECR_WRAP</td>
 </tr>
</table>

__数据类型__:

- scalar 代表标量，可以用浮点型(float)，整形(int)，布尔型(bool)
- vector 代表矢量，用逗号分隔的一系列浮点数表示

### 预定义的 uniform 变量

下面是 Cocos2d-x 预定义的一些 uniform 变量，你可以在自定义的着色器中使用它们。

* `CC_PMatrix`: A `mat4` with the projection matrix
* `CC_MVMatrix`: A `mat4` with the Model View matrix
* `CC_MVPMatrix`: A `mat4` with the Model View Projection matrix
* `CC_NormalMatrix`: A `mat4` with Normal Matrix
* `CC_Time`: a `vec4` with the elapsed time since the game was started
   * CC_Time[0] = time / 10;
   * CC_Time[1] = time;
   * CC_Time[2] = time * 2;
   * CC_Time[3] = time * 4;
* `CC_SinTime`: a `vec4` with the elapsed time since the game was started:
   * CC_SinTime[0] = time / 8;
   * CC_SinTime[1] = time / 4;
   * CC_SinTime[2] = time / 2;
   * CC_SinTime[3] = sinf(time);
* `CC_CosTime`: a `vec4` with the elapsed time since the game was started:
   * CC_CosTime[0] = time / 8;
   * CC_CosTime[1] = time / 4;
   * CC_CosTime[2] = time / 2;
   * CC_CosTime[3] = cosf(time);
* `CC_Random01`: A `vec4` with four random numbers between 0.0f and 1.0f
* `CC_Texture0`: A `sampler2D`
* `CC_Texture1`: A `sampler2D`
* `CC_Texture2`: A `sampler2D`
* `CC_Texture3`: A `sampler2D`
