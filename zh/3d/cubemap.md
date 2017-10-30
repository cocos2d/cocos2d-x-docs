# 立方体纹理(TextureCube)

立方体纹理是放置在立方体各个表面上的六个单独的方形纹理的集合。大多数情况下，它们用于在物体上显示无限远的反射，类似于天空盒在背景中显示远处的风景。一个展开的立方体纹理可能是这样的：

![](3d-img/Cubemap.jpg)

在 Cocos2d-x 中, 这样创建立方体纹理:

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
