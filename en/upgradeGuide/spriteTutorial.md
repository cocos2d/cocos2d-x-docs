# Sprite Tutorial

This example is mainly used to demonstrate Sprite's drawing process in V4 to help developers understand and understand the V4 API usage.

# Create Sprite

Sprites are created in the same way as V3 and have not changed:

```c++
auto visibleSize = Director::getInstance()->getVisibleSize();
auto origin = Director::getInstance()->getVisibleOrigin();

auto mySprite = Sprite::create("mysprite.png");
sprite->setPosition(Vec2(visibleSize / 2) + origin);
this->addChild(sprite);
```

Next, go inside the Sprite and see what happens compared to V3.

## Shader and program

In V3, the shader is specified for the sprite via `setGLProgramState`.

```c++
setGLProgramState(GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP, texture));
```

V4 removed GLProgramState and removed the code that uses the OpenGL ES API directly in the app. The use of the OpenGL ES API only appears in the `renderer/backend/opengl` file.

V4 defines a protected member backend::PipelineDescriptor in the RenderCommand class to hold backend::ProgramState, backend::BlendDescriptor and backend::VertexLayout.

So in the initialization phase, you need to complete the following three steps:

1. Create backend::ProgramState

    Create a backend::ProgramState object with `ProgramState(const std::string& vertexShader, const std::string& fragmentShader)`, store uniform and texture with the backend::ProgramState object, and store vertex data by creating `backend::Buffer`.

   ```c++
   auto& pipelineDescriptor = _trianglesCommand.getPipelineDescriptor();
   _programState = new (std::nothrow) backend::ProgramState(positionTextureColor_vert, positionTextureColor_frag);
   pipelineDescriptor.programState = _programState;
   
   _mvpMatrixLocation = pipelineDescriptor.programState->getUniformLocation("u_MVPMatrix");
   _textureLocation = pipelineDescriptor.programState->getUniformLocation("u_texture");
   _alphaTextureLocation = pipelineDescriptor.programState->getUniformLocation("u_texture1");
   ```

2. Create backend::VertexLayout

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

3. Create backend::BlendDescriptor 

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

## Update shader

The shader can be dynamically replaced by `Node::setProgramState(backend::ProgramState* programState)`. For example, when you need to turn on alpha test, since OpenGL ES 2.0 does not support `glAlphaFunc`, you need to replace the original fragment shader with positionTextureColorAlphaTest_frag.

```c++
auto programState = new (std::nothrow) backend::ProgramState(positionTextureColor_vert, positionTextureColorAlphaTest_frag);
_sprite->setProgramState(programState);
auto alphaLocation = programState->getUniformLocation("u_alpha_value");
programState->setUniform(alphaLocation, &alphaThreshold, sizeof(alphaThreshold));
CC_SAFE_RELEASE_NULL(programState);
```

## Update uniform

```c++
const auto& projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
auto programState = _trianglesCommand.getPipelineDescriptor().programState;
if (programState && _mvpMatrixLocation)
    programState->setUniform(_mvpMatrixLocation, projectionMat.m, sizeof(projectionMat.m));
```

## Update texture

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

To reduce the number of draw calls, the TriangleCommand is batched in the Renderer. So instead of creating a `backend::Buffer` in the Sprite, it is placed in the Renderer. [Example 2](./customCommandTutorial.md) will demonstrate how to create backend::Buffer and how to copy vertex data when using CustomCommand.