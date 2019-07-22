# CustomCommand Tutorial
This example uses `CreateColor` as an example to demonstrate how to use `CustomCommand` to become familiar with and understand __Cocos2d-x V4__ API usage.

# Create LayerColor

```c++
auto layerColor = LayerColor::create(Color4B::RED,
                                     visibleSize.width,
                                     visibleSize.height);
```

Next, go inside the LayerColor class and see what happens compared to V3.

In V3, the process of creating a shader is as follows:

```c++
setGLProgramState(GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_COLOR_NO_MVP));
```

As with [Example 1](spriteTutorial.md), during the initialization phase, V4 needs to complete the following steps:

1. Create backend::ProgramState

   ```c++
   auto& pipelineDescriptor = _customCommand.getPipelineDescriptor();
   _programState = new (std::nothrow) backend::ProgramState(positionColor_vert,
                                                            positionColor_frag);
   pipelineDescriptor.programState = _programState;
   _mvpMatrixLocation = pipelineDescriptor.programState->getUniformLocation("u_MVPMatrix");
   ```

2. Create backend::VertexLayout

   ```c++
   auto& vertexLayout = _customCommand.getPipelineDescriptor().vertexLayout;
   const auto& attributeInfo = _programState->getProgram()->getActiveAttributes();
   auto iter = attributeInfo.find("a_position");
   if (iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_position",
                                 Iter->second.location,
                                 Backend::VertexFormat::FLOAT3,
                                 0,
                                 False);
   }
   iter = attributeInfo.find("a_color");
   if (iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_color",
                                 Iter->second.location,
                                 Backend::VertexFormat::FLOAT4,
                                 Sizeof(_vertexData[0].vertices),
                                 False);
   }
   vertexLayout.setLayout(sizeof(_vertexData[0]), backend::VertexStepMode::VERTEX);
   ```

3. Create backend::BlendDescriptor

   `CustomCommand` has two common initialization methods: `CustomCommand::init(float globalZOrder)` and `CustomCommand::init(float globalZOrder, const BlendFunc& blendFunc)`. For the first one, you need to manually set the __blend state__:

   ```c++
   backend::BlendDescriptor& blendDescriptor = _customCommand.getPipelineDescriptor().blendDescriptor;
   blendDescriptor.blendEnabled = true;
   If (_blendFunc == BlendFunc::ALPHA_NON_PREMULTIPLIED)
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

   For the second initialization method, you need to specify `BlendFunc`, and then the `CustomCommand` initialization function will set the corresponding __blend state__ according to `BlendFunc`.

   ```c++
   _blendFunc = BlendFunc::ALPHA_PREMULTIPLIED;
   _customCommand.init(_globalZOrder, _blendFunc);
   ```

4. Create backend::Buffer

   ```c++
   _customCommand.createIndexBuffer(CustomCommand::IndexFormat::U_SHORT, //index type format
                                    6, //index count
                                    CustomCommand::BufferUsage::STATIC);
   unsigned short indices[] = {0, 1, 2, 2, 1, 3};
   _customCommand.updateIndexBuffer(indices, sizeof(indices));
   
   _customCommand.createVertexBuffer(sizeof(_vertexData[0]), //vertex size
                                     4, //vertex count
                                     CustomCommand::BufferUsage::DYNAMIC);
   _customCommand.setDrawType(CustomCommand::DrawType::ELEMENT);
   _customCommand.setPrimitiveType(CustomCommand::PrimitiveType::TRIANGLE);
   ```

   Because the index data does not change during the run, when the index buffer is created, specify bufferUsage as static and update the index buffer during the initialization phase. The vertex buffer data needs to be updated dynamically. Refer to [Update Vertex buffer](#Update Vertex buffer).

## Update Unifrom

```c++
cocos2d::Mat4 projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
auto& pipelineDescriptor = _customCommand.getPipelineDescriptor();
pipelineDescriptor.programState->setUniform(_mvpMatrixLocation,
                                            projectionMat.m,
                                            Sizeof(projectionMat.m));
```

## Update Vertex buffer

CommandBuffer provides the `updateVertexBuffer` interface for updating vertex buffer data.

```c++
_customCommand.updateVertexBuffer(_vertexData, sizeof(_vertexData));
```

If you need to update the sub-block of vertex buffer, you can use `CustomCommand::updateVertexBuffer(void* data, unsigned int offset, unsigned int length)` to pass in the offset.

## addCommand

```c++
_customCommand.init(_globalZOrder, _blendFunc);
renderer->addCommand(&_customCommand);
```