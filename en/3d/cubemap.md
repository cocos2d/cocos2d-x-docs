## Cubemap Texture
A __cube map texture__ is a collection of six separate square textures that are
put onto the faces of an imaginary cube. Most often they are used to display
infinitely far away reflections on objects, similar to how __sky box__ displays
far away scenery in the background. This is what an expanded cube map might look
like:

![](3d-img/Cubemap.jpg)

In Cocos2d-x, you can create a __cube map texture__ in this way:

{% codetabs name="C++", type="cpp" -%}
// create a textureCube object with six texture assets
auto textureCube = TextureCube::create("skybox/left.jpg",  "skybox/right.jpg", "skybox/top.jpg", "skybox/bottom.jpg", "skybox/front.jpg", "skybox/back.jpg");

// set cube map texture parameters
Texture2D::TexParams tRepeatParams;
tRepeatParams.magFilter = GL_NEAREST;
tRepeatParams.minFilter = GL_NEAREST;
tRepeatParams.wrapS = GL_MIRRORED_REPEAT;
tRepeatParams.wrapT = GL_MIRRORED_REPEAT;
textureCube->setTexParameters(tRepeatParams);

// create and set our custom shader
auto shader = GLProgram::createWithFilenames("cube_map.vert", "cube_map.frag");
auto _state = GLProgramState::create(shader);

// bind cube map texture to uniform
state->setUniformTexture("u_cubeTex", textureCube);
{%- endcodetabs %}
