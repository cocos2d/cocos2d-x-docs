# 立方体纹理(TextureCube)

立方体纹理是放置在立方体各个表面上的六个单独的方形纹理的集合。大多数情况下，它们用于在物体上显示无限远的反射，类似于天空盒在背景中显示远处的风景。一个展开的立方体纹理可能是这样的：

![](../../en/3d/3d-img/Cubemap.jpg)

在 Cocos2d-x 中，这样创建立方体纹理：

```cpp
// create a textureCube object with six texture assets
auto textureCube = TextureCube::create("skybox/left.jpg",  "skybox/right.jpg", "skybox/top.jpg", "skybox/bottom.jpg", "skybox/front.jpg", "skybox/back.jpg");

// set cube map texture parameters
Texture2D::TexParams tRepeatParams;
tRepeatParams.magFilter = backend::SamplerFilter::LINEAR;;
tRepeatParams.minFilter = backend::SamplerFilter::LINEAR;;
tRepeatParams.sAddressMode = backend::SamplerAddressMode::MIRROR_REPEAT;
tRepeatParams.tAddressMode = backend::SamplerAddressMode::MIRROR_REPEAT;
textureCube->setTexParameters(tRepeatParams);

// create and set our custom shader
auto vertShader = FileUtils::getStringFromFile("cube_map.vert");
auto fragShader = FileUtils::getStringFromFile("cube_map.frag");
auto programState = new backend::ProgramState(vertShader.c_str(), fragShader.c_str());

// bind cube map texture to uniform
auto cubTexLoc = programState->getUniformLocation("u_cubeTex");
programState->setTexture(cubTexLoc ,0, textureCube->getBackendTexture());
```
