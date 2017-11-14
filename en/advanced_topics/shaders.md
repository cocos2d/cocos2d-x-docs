## Shaders and Materials

### What is a Shader

From wikipedia:

__In the field of computer graphics, a shader is a computer program that is used
to do shading: the production of appropriate levels of color within an image,
or, in the modern era, also to produce special effects or do video post-processing.
A definition in layman's terms might be given as "a program that tells a computer
how to draw something in a specific and unique way".__

In other words, it is a piece of code that runs on the GPU (not CPU) to draw the
different Cocos2d-x Nodes.

Cocos2d-x uses the [OpenGL ES Shading Language v1.0](https://www.khronos.org/opengles/)
for the shaders. But describing the GLSL language is outside the scope of this
document. In order to learn more about the language, please refer to:
[OpenGL ES Shading Language v1.0 Spec](https://www.khronos.org/files/opengles_shading_language.pdf).

In Cocos2d-x, all `Node` objects that are __renderable__ use shaders. As an example
`Sprite` uses optimized shaders for 2d sprites, `Sprite3D` uses optimized shaders
for 3d objects, and so on.

### Customizing Shaders

Users can change the predefined shaders from any Cocos2d-x `Node` by calling:

{% codetabs name="C++", type="cpp" -%}
sprite->setGLProgramState(programState);
sprite3d->setGLProgramState(programState);
{%- endcodetabs %}

The `GLProgramState` object contains two important things:

- A `GLProgram`: Basically this is _the_ shader. It contains a vertex and fragment shader.
- And the __state__, which basically are the uniforms of the shader.

In case you are not familiar with the term _uniform_ and why it is needed, please
refer to the [OpenGL Shading Language Specification](https://www.khronos.org/files/opengles_shading_language.pdf)

Setting uniforms to a `GLProgramState` is as easy as this:

{% codetabs name="C++", type="cpp" -%}
glProgramState->setUniformFloat("u_progress", 0.9);
glProgramState->setUniformVec2("u_position", Vec2(x,y));
glProgramState->setUniformMat4("u_transform", matrix);
{%- endcodetabs %}

You can even set callbacks as a uniform value:

{% codetabs name="C++", type="cpp" -%}
glProgramState->setUniformCallback("u_progress", [](GLProgram* glProgram, Uniform* uniform)
{
    float random = CCRANDOM_0_1();
    glProgram->setUniformLocationWith1f(uniform->location, random);
}
);
{%- endcodetabs %}

And although it is possible to set `GLProgramState` objects manually, an easier
way to do it is by using `Material` objects.

### What is a Material

Assume that you want to draw a sphere like this one:

![](advanced_topics-img/model.jpg)

The first thing that you have to do is to define its geometry, something like this:

![](advanced_topics-img/geometry.jpg)

...and then define the brick texture, like:

![](advanced_topics-img/brick.jpg)


- But what if you want to use a lower quality texture when the sphere is far away
from the camera?
- or what if you want to apply a blur effect to the bricks?
- or what if you want to enable or disable lighting in the sphere ?

The answer is to use a `Material` instead of just a plain and simple texture. In fact,
with `Material` you can have more than one texture, and much more features like multi-pass rendering.

`Material` objects are created from `.material` files, which contain the following information:

- `Material` can have one or more `Technique` objects
- each `Technique` can have one more `Pass` objects
- each `Pass` object has:
  - a `RenderState` object,
  - a `Shader` object including the uniforms

As an example, this is how a material file looks like:

{% codetabs name="JavaScript", type="js" -%}
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
{%- endcodetabs %}

And this is how to set a `Material` to a `Sprite3D`:

{% codetabs name="C++", type="cpp" -%}
Material* material = Material::createWithFilename("Materials/3d_effects.material");
sprite3d->setMaterial(material);
{%- endcodetabs %}

And if you want to change between different `Technique`s, you have to do:

{% codetabs name="C++", type="cpp" -%}
material->setTechnique("normal");
{%- endcodetabs %}

### Techniques
Since you can bind only one `Material` per `Sprite3D`, an additional feature
is supported that's designed to make it quick and easy to change the way you
render the parts at runtime. You can define multiple techniques by giving them
different names. Each one can have a completely different rendering technique,
and you can even change the technique being applied at runtime by using
__Material::setTechnique(const std::string& name)__. When a material is loaded,
all the techniques are loaded ahead too. This is a practical way of handling
different light combinations or having lower-quality rendering techniques, such
as disabling bump mapping, when the object being rendered is far away from the
camera.

### Passes
A `Technique` can have one or more __passes__ That is, multi-pass rendering.
And each `Pass` has two main objects:

- `RenderState`: contains the GPU state information, like __depthTest__, __cullFace__,
    __stencilTest__, etc.
- `GLProgramState`: contains the shader (`GLProgram`) that is going to be used, including
    its uniforms.

### Material file format in detail
Material uses a file format  optimized to create Material files.
This file format is very similar to other existing Material file formats, like
GamePlay3D's and OGRE3D's.

__Notes__:

- Material file extensions do not matter. Although it is recommended to use
__.material__ as extension
- __id__ is optional for material, technique and pass
- Materials can inherit values from another material by optionally setting a
__parent_material_id__
- Vertex and fragment shader file extensions do not matter. The convention in
Cocos2d-x is to use __.vert__ and __frag__

{% codetabs name="C++", type="cpp" -%}
// When the .material file contains one material
sprite3D->setMaterial("Materials/box.material");
// When the .material file contains multiple materials
sprite3D->setMaterial("Materials/circle.material#wood");
{%- endcodetabs %}

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

__Enums__:

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

__Types__:

<ul>
 <li class=MsoNormal><a name=scalar><span class=Non-literalCode>scalar</span> </a>is
     float, int or bool.</li>
 <li class=MsoNormal><a name=vector><span class=Non-literalCode>vector</span></a><span
     class=Non-literalCode> </span>is a comma separated list of floats.</li>
</ul>

### Predefined uniforms

The following are predefined uniforms used by Cocos2d-x that can be used in
your shaders:

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
