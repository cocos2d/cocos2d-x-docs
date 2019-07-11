# Overview

本范例主要用于演示 Sprite 在 V4 中的绘制流程，以帮助开发者熟悉和理解 V4 API 使用。

#创建 Sprite

Sprite 创建方式与 V3 一样，并未改动：

```c++
auto visibleSize = Director::getInstance()->getVisibleSize();
auto origin = Director::getInstance()->getVisibleOrigin();

auto mySprite = Sprite::create("mysprite.png");
sprite->setPosition(Vec2(visibleSize / 2) + origin);
this->addChild(sprite);
```

接下来进入到 Sprite 内部，看看与 V3 相比，发生了哪些变化。

## Shader 与 program

在 V3，通过 `setGLProgramState` 为 Sprite 指定 shader。

```c++
setGLProgramState(GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP, texture));
```

V4 移除了 GLProgramState，删除了在 app 中 直接使用 OpenGL ES API 的代码，OpenGL ES API 的使用只出现在 `renderer/backend/opengl` 文件中。

V4 在 RenderCommand 类中定义了一个 protected 成员 backend::PipelineDescriptor，用于保存 backend::ProgramState， backend::BlendDescriptor 及 backend::VertexLayout。

因此在初始化阶段，需要完成以下三个步骤：

1. 创建 backend::ProgramState

   通过 `ProgramState(const std::string& vertexShader, const std::string& fragmentShader)` 创建 backend::ProgramState 对象，通过 backend::ProgramState 对象存储 uniform 和 texture，通过创建 `backend::Buffer` 存储顶点数据。

   ```c++
   auto& pipelineDescriptor = _trianglesCommand.getPipelineDescriptor();
   _programState = new (std::nothrow) backend::ProgramState(positionTextureColor_vert, positionTextureColor_frag);
   pipelineDescriptor.programState = _programState;
   
   _mvpMatrixLocation = pipelineDescriptor.programState->getUniformLocation("u_MVPMatrix");
   _textureLocation = pipelineDescriptor.programState->getUniformLocation("u_texture");
   _alphaTextureLocation = pipelineDescriptor.programState->getUniformLocation("u_texture1");
   ```

2. 创建 backend::VertexLayout

   ```c++
   //set vertexLayout according to V3F_C4B_T2F structure
   auto& vertexLayout = _trianglesCommand.getPipelineDescriptor().vertexLayout;
   const auto& attributeInfo = _programState->getProgram()->getActiveAttributes();
   auto iter = attributeInfo.find("a_position");
   if(iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_position", 
                                 iter->second.location, 
                                 backend::VertexFormat::FLOAT3, 
                                 0, 
                                 false);
   }
   
   iter = attributeInfo.find("a_texCoord");
   if(iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_texCoord", 
                                 iter->second.location, 
                                 backend::VertexFormat::FLOAT2, 
                                 offsetof(V3F_C4B_T2F, texCoords), 
                                 false);
   }
   
   iter = attributeInfo.find("a_color");
   if(iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_color", 
                                 iter->second.location, 
                                 backend::VertexFormat::UBYTE4, 
                                 offsetof(V3F_C4B_T2F, colors), 
                                 true);
   }
   vertexLayout.setLayout(sizeof(V3F_C4B_T2F), backend::VertexStepMode::VERTEX);
   ```

3. 创建 backend::BlendDescriptor 

   ```c++
   backend::BlendDescriptor& blendDescriptor = _trianglesCommand.getPipelineDescriptor().blendDescriptor;
   blendDescriptor.blendEnabled = true;
   if (_blendFunc == BlendFunc::ALPHA_NON_PREMULTIPLIED)
   {
       blendDescriptor.sourceRGBBlendFactor = backend::BlendFactor::SRC_ALPHA;
       blendDescriptor.destinationRGBBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;
       blendDescriptor.sourceAlphaBlendFactor = backend::BlendFactor::SRC_ALPHA;
       blendDescriptor.destinationAlphaBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;
   }
   else
   {
       blendDescriptor.sourceRGBBlendFactor = backend::BlendFactor::ONE;
       blendDescriptor.destinationRGBBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;
       blendDescriptor.sourceAlphaBlendFactor = backend::BlendFactor::ONE;
       blendDescriptor.destinationAlphaBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;
   }
   ```

## 更新 shader

通过 `Node::setProgramState(backend::ProgramState* programState)`，可以动态替换 shader。例如，当需要开启 alpha test 时，由于OpenGL ES 2.0 不支持 `glAlphaFunc`，此时需要将原来的 fragment shader 替换成 positionTextureColorAlphaTest_frag。

```c++
auto programState = new (std::nothrow) backend::ProgramState(positionTextureColor_vert, positionTextureColorAlphaTest_frag);
_sprite->setProgramState(programState);
auto alphaLocation = programState->getUniformLocation("u_alpha_value");
programState->setUniform(alphaLocation, &alphaThreshold, sizeof(alphaThreshold));
CC_SAFE_RELEASE_NULL(programState);
```

## 更新 uniform

```c++
const auto& projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
auto programState = _trianglesCommand.getPipelineDescriptor().programState;
if (programState && _mvpMatrixLocation)
    programState->setUniform(_mvpMatrixLocation, projectionMat.m, sizeof(projectionMat.m));
```

## 更新 texture

```c++
if (_texture == nullptr || _texture->getBackendTexture() == nullptr)
    return;

auto programState = _trianglesCommand.getPipelineDescriptor().programState;
programState->setTexture(_textureLocation, 0, _texture->getBackendTexture());
auto alphaTexture = _texture->getAlphaTexture();
if(alphaTexture && alphaTexture->getBackendTexture())
{
    programState->setTexture(_alphaTextureLocation, 1, alphaTexture->getBackendTexture());
}
```

## add triangle command

```c++
_trianglesCommand.init(_globalZOrder,
                       _texture,
                       _blendFunc,
                       _polyInfo.triangles,
                       transform,
                       flags);
renderer->addCommand(&_trianglesCommand);
```

为了减少 draw call 次数，在 Renderer 中会对 TriangleCommand 进行 batch。因此在 Sprite 中并未创建 backend::Buffer，而是放到了 Renderer 中。[范例2](./customCommandTutorial.md) 将演示当使用 CustomCommand 时如何创建 backend::Buffer 以及如何拷贝顶点数据。