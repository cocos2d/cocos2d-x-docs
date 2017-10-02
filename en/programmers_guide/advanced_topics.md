# Advanced Topics
Wow! You are on the last chapter. Good Job! By now you should feel comfortable
creating your games with Cocos2d-x. However, please realize there is no limit to
what you can create. This chapter covers __advanced__ concepts. Note that this
chapter gets more technical in its content and format.

# File System Access
Even though you can use functions in __stdio.h__ to access files it can be
inconvenient for a few reasons:
* You need to invoke system specific API to get full path of a file.
* Resources are packed into .apk file on Android after installing.
* You want to load a resource (such as a picture) based on resolution automatically.

The `FileUtils` class has been created to resolve these issues. `FileUtils` is a
helper class to access files under the location of your `Resources` directory.
This includes reading data from a file and checking file existence.

### Functions to read file content
These functions will read different type of files and will return different data
types:

<table>
 <tr>
  <th>function name</th>
  <th>return type</th>
  <th>support path type</th>
 </tr>
 <tr>
  <td>getStringFromFile</td>
  <td>std::string</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getDataFromFile</td>
  <td>cocos2d::Data</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getFileDataFromZip</td>
  <td>unsigned char*</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>getValueMapFromFile</td>
  <td>cocos2d::ValueMap</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getValueVectorFromFile</td>
  <td>std::string</td>
  <td>cocos2d::ValueVector</td>
 </tr>

 </table>

###Functions to manage files or directories
These functions will manage a file or a directory:

<table>
 <tr>
  <th>function name</th>
  <th>support path type</th>
 </tr>
 <tr>
  <td>isFileExist</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>isDirectoryExist</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>createDirectory</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>removeDirectory</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>removeFile</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>renameFile</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>getFileSize</td>
  <td>relative path and absolute path</td>
 </tr>
 </table>

# Networking with HTTP
Sometimes it might be helpful to obtain resources or data from another source.
One common way of doing this is by using an `HTTP` request.

HTTP networking has three steps:
   1. Create an `HttpRequest`
   2. Create a __setResponseCallback()__ callback function for replying to requests.
   3. Send `HttpRequest` by `HttpClient`

`HttpRequest` can have four types:  __POST__, __PUT__, __DELETE__, __UNKNOWN__. Unless
specified the default type is __UNKNOWN__. The `HTTPClient` object controls sending the
__request__ and receiving the data on a __callback__.

Working with an `HTTPRequest` is quite simple:

{% codetabs name="C++", type="cpp" -%}
HttpRequest* request = new (std :: nothrow) HttpRequest();
request->setUrl("http://just-make-this-request-failed.com");
request->setRequestType(HttpRequest::Type::GET);
request->setResponseCallback(CC_CALLBACK_2 (HttpClientTest::onHttpRequestCompleted, this));

HttpClient::getInstance()->sendImmediate(request);

request->release();
{%- endcodetabs %}

Notice that we specified a __setResponseCallback()__ method for when a response is
received. By doing this we can look at the data returned and use it how we might
need to. Again, this process is simple and we can do it with ease:

{% codetabs name="C++", type="cpp" -%}
void HttpClientTest::onHttpRequestCompleted(HttpClient* sender, HttpResponse* response)
{
  if (!response)
  {
    return;
  }

  // Dump the data
  std::vector<char>* buffer = response->getResponseData();

  for (unsigned int i = 0; i <buffer-> size (); i ++)
  {
    log ("% c", (* buffer) [i]);
  }
}
{%- endcodetabs %}

#Shaders and Materials

##What is a Shader

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

##Customizing Shaders

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

##What is a Material

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

##Techniques
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

##Passes
A `Technique` can have one or more __passes__ That is, multi-pass rendering.
And each `Pass` has two main objects:

- `RenderState`: contains the GPU state information, like __depthTest__, __cullFace__,
    __stencilTest__, etc.
- `GLProgramState`: contains the shader (`GLProgram`) that is going to be used, including
    its uniforms.

##Material file format in detail
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

## Predefined uniforms

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

# How to optimize the graphics performance of your Cocos2d-x games

## Golden rules
### Know the bottlenecks and optimize the bottlenecks.
When doing optimization, we should always stick to this rule. Only 20% code in your system contribute to the 80% performance issue.

### Always use tools to profile the bottleneck, don't guess randomly.
There are many tools available now for profiling the graphics performance.
Though we are optimize the performance of Android games, but XCode could also be helpful to debugging.

- Xcode: https://github.com/rstrahl/rudistrahl.me/blob/master/entries/Debugging-OpenGL-ES-With-Xcode-Profile-Tools.md
and the official document: https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ToolsOverview/ToolsOverview.html

There are three major mobile GPU vendors nowadays and they provide decent graphics profiling tools:

- For ARM Mali GPU: http://malideveloper.arm.com/resources/tools/mali-graphics-debugger/
- For Imagination PowerVR GPU: https://community.imgtec.com/developers/powervr/tools/pvrtune/
- For Qualcomm Adreno GPU: https://developer.qualcomm.com/software/adreno-gpu-profiler

Use these tools when you suffer from graphics issues. **But not at the first beginning, usually the bottleneck resides on CPU.**

### Know your target device and your game engine
Know the CPU/GPU family of your target device  which is important when sometimes the performance issues
only occurs on certain kind of devices. And you will find they share the same kind of GPU(ARM or PowerVR or Mali).

Know the limitations of your currently used game engine is also important. If you know how your engine organize the graphics command,
how your engine do batch drawing. You could avoid many common pitfalls during coding.

### The principle of "Good enough".
(“If the viewer cannot tell the difference between differently rendered images always use the cheaper implementation".)
As we know a PNG with RGBA444 pixel format has lower graphics quality than the one with RGBA888 pixel format.
But if we can't tell the difference between the two, we should stick to RGBA4444 pixel format.
The RGBA444 format use less memory and it will less likely to cause the memory issue and bandwidth issue.

It is the same goes for the audio sample rate.

## Common Bottlenecks
As a rules of thumb, your game will suffer CPU bottlenecks easily than graphics bottlenecks.

### The CPU is often limited by the number of draw calls and the heavy compute operations in your game loop
Try to minimize the total draw calls of your game. We should use batch draw as much as possible.
Cocos2d-x 3.x has auto batch support, but it needs some effort to make it work.

Also try avoid IO operations when players are playing your game. Try to preload your spritesheets, audios, TTF fonts etc.

Also don't do heavy compute operations in your game loop which means don't let the heavy operations called 60 times per frame.

Never!

### The GPU is often limited by the overdraw(fillrate) and bandwidth.
If you are creating a 2D game and you don't write complex shaders, you might won't suffer GPU issues.
But the overdraw problem still has trouble and it will slow your graphics performance with too much bandwidth consumption.

Though modern mobile GPU have TBDR(Tiled-based Defered Rendering) architecture, but only PowerVR's HSR(Hidden Surface Removal)
could reduce the overdraw problem significantly. Other GPU vendors only implement a TBDR + early-z testing, it only reduce the overdraw
problem when you submit your opaque geometry with the order(font to back). And Cocos2d-x always submit rendering commands ordered from back to front.
Because in 2D, we might have many transparency images and only in this order the blending effect is correct.

Note: By using poly triangles, we could improve the fillrate.  Please refer to this article for more information:
https://www.codeandweb.com/texturepacker/tutorials/cocos2d-x-performance-optimization

But don't worry too much of this issue, it doesn't perform too bad in practice.

## Simple checklist to make your Cocos2d-x game faster
1.  Always use batch drawing. Package sprite images in the same layer into a large atlas(Texture packer could help).
2.  As rule of thumb, try to keep your draw call below 50. In other words, try to minimize your draw call number.
3.  Prefer 16bit(RGBA4444+dithering) over raw 32bit(RGBA8888) textures.
4.  Use compressed textures: In iOS use PVRTC texture. In Android platform, use ETC1. but ETC1 doesn't has alpha,
you might need to write a custom shader and provide a separate ETC1 image for the alpha channel.
5.  Don't use system font as your game score counter. It's slow. Try to use TTF or BMFont, BMfont is better.
6.  Try to preload audio and other game objects before usage.
7. Use armeabi-v7a to build Android native code and it will enable neon instructors which is very fast.
8. Bake the lighting rather than using the dynamic light.
9. Avoid using complex pixel shaders.
10. Avoid using **discard** and alpha test in your pixel shader, it will break the HSR(Hidden surface removal). Only use it when necessary.

<!--
## Best Practice - Optimization, memory, performance, profiling

## SQLite

## Subclass Cocos2d-x classes

## Data structures (i.e Vector)

## Custom OpenGL (what to cover here? CustomCommand?)

## c++11 usage

## rendering pipeline (notes about this in the wiki)
-->
