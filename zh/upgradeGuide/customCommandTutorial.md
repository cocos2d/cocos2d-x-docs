# Overview

本范例以创建 LayerColor 为例，演示如何使用 CustomCommand，以帮助开发者熟悉和理解 V4 API 使用。

# 创建 LayerColor

```c++
auto layerColor = LayerColor::create(Color4B::RED, 
                                     visibleSize.width, 
                                     visibleSize.height);
```

接下来进入到 LayerColor 类内部，看看与 V3 相比，发生了哪些变化。

在 V3，创建 shader 过程如下：

```c++
setGLProgramState(GLProgramState::getOrCreateWithGLProgramName(GLProgram::SHADER_NAME_POSITION_COLOR_NO_MVP));
```

与[范例1](spriteTutorial.md)一样，在初始化阶段，V4 需要完成以下几个步骤：

1. 创建 backend::ProgramState

   ```c++
   auto& pipelineDescriptor = _customCommand.getPipelineDescriptor();
   _programState = new (std::nothrow) backend::ProgramState(positionColor_vert, 
                                                            positionColor_frag);
   pipelineDescriptor.programState = _programState;
   _mvpMatrixLocation = pipelineDescriptor.programState->getUniformLocation("u_MVPMatrix");
   ```

2. 创建 backend::VertexLayout

   ```c++
   auto& vertexLayout = _customCommand.getPipelineDescriptor().vertexLayout;
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
   iter = attributeInfo.find("a_color");
   if(iter != attributeInfo.end())
   {
       vertexLayout.setAttribute("a_color", 
                                 iter->second.location, 
                                 backend::VertexFormat::FLOAT4,
                                 sizeof(_vertexData[0].vertices), 
                                 false);
   }
   vertexLayout.setLayout(sizeof(_vertexData[0]), backend::VertexStepMode::VERTEX);
   ```

3. 创建 backend::BlendDescriptor

   CustomCommand 常见的初始化方式有两种：`CustomCommand::init(float globalZOrder)` 和 `CustomCommand::init(float globalZOrder, const BlendFunc& blendFunc)`。因此对于第一种，你需要在手动设置 Blend 状态：

   ```c++
   backend::BlendDescriptor& blendDescriptor = _customCommand.getPipelineDescriptor().blendDescriptor;
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

   对于第二种初始化方式，需要指定 BlendFunc 即可，CustomCommand 初始化函数会根据 BlendFunc 设置对应的 Blend 状态。

   ```c++
   _blendFunc = BlendFunc::ALPHA_PREMULTIPLIED;
   _customCommand.init(_globalZOrder, _blendFunc);
   ```

4. 创建 backend::Buffer

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

   因为 index 数据在运行过程中并不会改变，所以在创建 index buffer 时，指定 bufferUsage 为 static，并在初始化阶段更新 index buffer。vertex buffer 数据需要动态更新，参考[更新 Vertex buffer](#更新 Vertex buffer)。

## 更新 Unifrom

```c++
cocos2d::Mat4 projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
auto& pipelineDescriptor = _customCommand.getPipelineDescriptor();
pipelineDescriptor.programState->setUniform(_mvpMatrixLocation, 
                                            projectionMat.m, 
                                            sizeof(projectionMat.m));
```

## 更新 Vertex buffer

CommandBuffer 提供了 `updateVertexBuffer` 接口用于更新顶点缓冲区数据。

```c++
_customCommand.updateVertexBuffer(_vertexData, sizeof(_vertexData));
```

如果需要更新 vertex buffer 的子块，可以使用 `CustomCommand::updateVertexBuffer(void* data, unsigned int offset, unsigned int length)` 传入偏移量即可。

## addCommand

```c++
_customCommand.init(_globalZOrder, _blendFunc);
renderer->addCommand(&_customCommand);
```