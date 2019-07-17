# Overview

作为 `RenderCommand` 的一个私有成员，用于保存当前 `RenderCommand` 所使用的 [PrgramState](#ProgramSate)，[BlendDescriptor](#BlendDescriptor)， 以及 [VertexLayout](#VertexLayout)。

```c++
struct CC_DLL PipelineDescriptor
{
    backend::ProgramState*          programState = nullptr;
    backend::BlendDescriptor        blendDescriptor;
    backend::VertexLayout           vertexLayout;
};
```

# ProgramSate

## 创建 ProgramState

创建 `ProgramState` 对象时，需要传入顶点和片元着色器。

```c++
auto programState = new (std::nothrow) backend::ProgramState(vert, frag);

auto& pipelineDescriptor = _trianglesCommand.getPipelineDescriptor();
pipelineDescriptor.programState = programState;
```

## 设置 vertex buffer

- TrianglesCommand

  由于 TrianglesCommand batch 的机制，相邻多个 TrianglesCommand 可能会合并成一个。因此 vertex buffer 的创建不在 TrianglesCommand 里面管理，而是放在 Renderer 里通过 TriangleCommandBufferManager 自动管理。

- CustomCommand

  ```c++
  uint16_t indices[6] = { 0, 1, 2, 2, 3, 0 };
  V2F_C4B_T2F *_buffer = (V2F_C4B_T2F*)malloc(_bufferCapacity*sizeof(V2F_C4B_T2F));
  
  _customCommand.createVertexBuffer(sizeof(V2F_C4B_T2F), _bufferCapacity, CustomCommand::BufferUsage::DYNAMIC);
  _customCommand.createIndexBuffer(CustomCommand::IndexFormat::U_SHORT, sizeof(indices) / sizeof(indices[0]), CustomCommand::BufferUsage::STATIC);
  
  _customCommand.updateVertexBuffer(_buffer, _bufferCapacity*sizeof(V2F_C4B_T2F));
  _customCommand.updateIndexBuffer(indices, sizeof(indices));
  ```

## 设置 Uniform

首先通过 ProgramState 对象获取 uniform location：

```c++
auto mvpMatrixLocation = programState->getUniformLocation("u_MVPMatrix");
auto textureLocation = programState->getUniformLocation("u_texture");
```

接着根据 uniform location 设置 uniform data：

```c++
const auto& projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);

programState->setUniform(mvpMatrixLocation, projectionMat.m, sizeof(projectionMat.m));
programState->setTexture(textureLocation, 0, _texture->getBackendTexture());
```

通过 location 设置 uniform 的优势在于，不必每次都通过 uniform name 查找 location，节省 CPU 开销。

## backend

- Set Uniform Buffer

  Metal 中，vertex unifrom 和 fragment uniform 数据分别保存在 ProgramState 的 vertexUniformBuffer 及 fragmentUniformBuffer 中。

  ```c++
  // Uniform buffer is bound to index 1.
  auto vertexUniformBuffer = _programState->getVertexUniformBuffer();
  if(vertexUniformBuffer.size() > 0)
  {
    [_mtlRenderEncoder setVertexBytes:vertexUniformBuffer.data()
                               length:vertexUniformBuffer.size() 
                              atIndex:1];
  }
  
  auto fragmentUniformBuffer = _programState->getFragmentUniformBuffer();
  if(fragmentUniformBuffer.size() > 0)
  {
    [_mtlRenderEncoder setFragmentBytes:fragmentUniformBuffer.data()
                                 length:fragmentUniformBuffer.size()
                                atIndex:1];
  }
  ```

  OpenGL 中，uniform 数据分别保存在各自 location 所在的 VertexUniformInfos 中。

  ```c++
  auto& uniformInfos = _programState->getVertexUniformInfos();
  
  for(auto& iter : uniformInfos)
  {
    auto& uniformInfo = iter.uniformInfo;
    if(uniformInfo.bufferSize <= 0)
      continue;
  
    int elementCount = uniformInfo.count;
    if (uniformInfo.isArray)
    {
      CCASSERT(uniformInfo.count * uniformInfo.bufferSize >= iter.data.size(), "uniform data size mismatch!");
      elementCount = std::min(elementCount, (int)(iter.data.size() / uniformInfo.bufferSize));
    }
  
    setUniform(uniformInfo.isArray,
               uniformInfo.location,
               elementCount,
               uniformInfo.type,
               (void*)iter.data.data());
  }
          
  ```

- Set Texture

  对于 Metal， Texture 数据分别保存在 ProgramState 的 _vertexTextureInfos 和 _fragmentTextureInfos 中。

  ```c++
  const auto& bindTextureInfos = (isVertex) ? _programState->getVertexTextureInfos() : _programState->getFragmentTextureInfos();
  
  for(const auto& iter : bindTextureInfos)
  {
    //FIXME: should support texture array.
    int i = 0;
    auto location = iter.first;
    const auto& textures = iter.second.textures;
  
    if (isVertex)
    {
      [_mtlRenderEncoder setVertexTexture:getMTLTexture(textures[i])
                                  atIndex:location];
      [_mtlRenderEncoder setVertexSamplerState:getMTLSamplerState(textures[i])
                                       atIndex:location];
    }
    else
    {
      [_mtlRenderEncoder setFragmentTexture:getMTLTexture(textures[i])
                                    atIndex:location];
      [_mtlRenderEncoder setFragmentSamplerState:getMTLSamplerState(textures[i])
                                         atIndex:location];
    }
  
    ++i;
  }
  ```

  OpenGL 中，Texture 数据则保存在 ProgramState 的 _vertexTextureInfos 中。

  ```c++
  const auto& textureInfo = _programState->getVertexTextureInfos();
  for(const auto& iter : textureInfo)
  {
    const auto& textures = iter.second.textures;
    const auto& slot = iter.second.slot;
    auto location = iter.first;
  
    int i = 0;
    for (const auto& texture: textures)
    {
      applyTexture(texture, slot[i]);
      ++i;
    }
  
    auto arrayCount = slot.size();
    if (arrayCount > 1)
      glUniform1iv(location, (uint32_t)arrayCount, (GLint*)slot.data());
    else
      glUniform1i(location, slot[0]);
  }
  ```

- Set Vertex Buffer

  以 CustomCommand 为例，通过 CommandBuffer 设置 VertexBuffer。

  ```c++
  _commandBuffer->setVertexBuffer(0, customCommand->getVertexBuffer());
  ```

  对于 Metal，vertex buffer 总是绑定到 index 0：

  ```c++
  // Vertex buffer is bound in index 0.
  [_mtlRenderEncoder setVertexBuffer:static_cast<BufferMTL*>(buffer)->getMTLBuffer()
                              offset:0
                             atIndex:0];
  ```

  对于 OpenGL，通过 VBO，关联顶点属性数据：

  ```c++
  // Bind vertex buffers and set the attributes.
  int i = 0;
  const auto& attributeInfos = program->getAttributeInfos();
  const auto& vertexLayouts = getVertexLayouts();
  for (const auto& vertexBuffer : _vertexBuffers)
  {
    if (! vertexBuffer)
      continue;
    if (i >= attributeInfos.size())
      break;
  
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer->getHandler());
  
    const auto& attributeInfo = attributeInfos[i];
    const auto &layouts = vertexLayouts->at(i);
    for (const auto& attribute : attributeInfo)
    {
      const auto &layoutInfo = layouts.getAttributes().at(attribute.name);
      glEnableVertexAttribArray(attribute.location);
      glVertexAttribPointer(attribute.location,
                            UtilsGL::getGLAttributeSize(layoutInfo.format),
                            UtilsGL::toGLAttributeType(layoutInfo.format),
                            layoutInfo.needToBeNormallized,
                            layouts.getStride(),
                            (GLvoid*)layoutInfo.offset);
    }
  
    ++i;
  }
  ```

  # BlendDescriptor

- 设置 Blend 函数

  ```c++
  backend::BlendDescriptor& blendDescriptor = _trianglesCommand.getPipelineDescriptor().blendDescriptor;
  blendDescriptor.blendEnabled = true;
  BlendFunc blendFunc; 
  if (! _texture || ! _texture->hasPremultipliedAlpha())
  {
    blendFunc = BlendFunc::ALPHA_NON_PREMULTIPLIED;
  }
  else
  {
    blendFunc = BlendFunc::ALPHA_PREMULTIPLIED;
  }
  auto& blendDescriptor = _pipelineDescriptor.blendDescriptor;
  blendDescriptor.blendEnabled = true;
  blendDescriptor.sourceRGBBlendFactor = blendFunc.src;
  blendDescriptor.sourceAlphaBlendFactor = blendFunc.src;
  blendDescriptor.destinationRGBBlendFactor = blendFunc.dst;
  blendDescriptor.destinationAlphaBlendFactor = blendFunc.dst;
  ```

- 创建 Blend 对象

  ```c++
  auto blendState = device->createBlendState(pipelineDescriptor.blendDescriptor);
  ```

- 设置 Blend 对象到 Pipeline

  ```c++
  backend::RenderPipelineDescriptor renderPipelineDescriptor;
  renderPipelineDescriptor.programState = ...
    ...
  renderPipelineDescriptor.blendState = blendState;
  ```

- Apply BlendState

  对于 Metal，blend 状态的设置最终是在 `RenderPipelineMTL::setBlendState` 函数中：

  ```c++
  colorAttachmentDescriptor.blendingEnabled = _blendDescriptorMTL.blendEnabled;
  colorAttachmentDescriptor.writeMask = _blendDescriptorMTL.writeMask;
  
  colorAttachmentDescriptor.rgbBlendOperation = _blendDescriptorMTL.rgbBlendOperation;
  colorAttachmentDescriptor.alphaBlendOperation = _blendDescriptorMTL.alphaBlendOperation;
  
  colorAttachmentDescriptor.sourceRGBBlendFactor = _blendDescriptorMTL.sourceRGBBlendFactor;
  colorAttachmentDescriptor.destinationRGBBlendFactor = _blendDescriptorMTL.destinationRGBBlendFactor;
  colorAttachmentDescriptor.sourceAlphaBlendFactor = _blendDescriptorMTL.sourceAlphaBlendFactor;
  colorAttachmentDescriptor.destinationAlphaBlendFactor = _blendDescriptorMTL.destinationAlphaBlendFactor;
  ```

  对于 OpenGL，blend 状态的设置则在 `BlendStateGL::apply` 里：

  ```c++
  if (_blendEnabled)
  {
    glEnable(GL_BLEND);
    glBlendEquationSeparate(_rgbBlendOperation, _alphaBlendOperation);
    glBlendFuncSeparate(_sourceRGBBlendFactor,
                        _destinationRGBBlendFactor,
                        _sourceAlphaBlendFactor,
                        _destinationAlphaBlendFactor);
  }
  else
    glDisable(GL_BLEND);
  ```

# VertexLayout

- 记录每个顶点属性在 vertex buffer 中的 layout。

  ```c++
  //set vertexLayout according to V3F_C4B_T2F structure
  auto& vertexLayout = _trianglesCommand.getPipelineDescriptor().vertexLayout;
  const auto& attributeInfo = _programState->getProgram()->getActiveAttributes();
  auto iter = attributeInfo.find("a_position");
  if(iter != attributeInfo.end())
  {
    vertexLayout.setAttribute("a_position", iter->second.location, backend::VertexFormat::FLOAT3, 0, false);
  }
  
  iter = attributeInfo.find("a_texCoord");
  if(iter != attributeInfo.end())
  {
    vertexLayout.setAttribute("a_texCoord", iter->second.location, backend::VertexFormat::FLOAT2, offsetof(V3F_C4B_T2F, texCoords), false);
  }
  
  iter = attributeInfo.find("a_color");
  if(iter != attributeInfo.end())
  {
    vertexLayout.setAttribute("a_color", iter->second.location, backend::VertexFormat::UBYTE4, offsetof(V3F_C4B_T2F, colors), true);
  }
  
  vertexLayout.setLayout(sizeof(V3F_C4B_T2F), backend::VertexStepMode::VERTEX);
  ```

- Apply VertexLayout

  在 Metal 中，vertex layout 通过 `RenderPipelineMTL::setVertexLayout` 设到 MTLRenderPipelineDescriptor。

  ```c++
  const auto& vertexLayouts = *descriptor.vertexLayouts;
  int vertexIndex = 0;
  for (const auto& vertexLayout : vertexLayouts)
  {
    if (!vertexLayout.isValid())
      continue;
  
    mtlDescriptor.vertexDescriptor.layouts[vertexIndex].stride = vertexLayout.getStride();
    mtlDescriptor.vertexDescriptor.layouts[vertexIndex].stepFunction = toMTLVertexStepFunction(vertexLayout.getVertexStepMode());
  
    const auto& attributes = vertexLayout.getAttributes();
    for (const auto& it : attributes)
    {
      auto attribute = it.second;
      mtlDescriptor.vertexDescriptor.attributes[attribute.index].format = toMTLVertexFormat(attribute.format, attribute.needToBeNormallized);
      mtlDescriptor.vertexDescriptor.attributes[attribute.index].offset = attribute.offset;
      // Buffer index will always be 0;
      mtlDescriptor.vertexDescriptor.attributes[attribute.index].bufferIndex = 0;
    }
  
    ++vertexIndex;
  }
  ```

  在 OpenGL 中，需要先更新 CommandBuffer 的 vertexLayout：

  ```c++
  _commandBuffer->updateVertexLayouts(renderPipelineDescriptor.vertexLayouts);
  ```

  然后在 `CommandBufferGL::bindVertexBuffer` 根据 vertexLayout 绑定顶点属性数据。

  ```c++
  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer->getHandler());
  
  glEnableVertexAttribArray(attribute.location);
  glVertexAttribPointer(attribute.location,
                        UtilsGL::getGLAttributeSize(layoutInfo.format),
                        UtilsGL::toGLAttributeType(layoutInfo.format),
                        layoutInfo.needToBeNormallized,
                        layouts.getStride(),
                        (GLvoid*)layoutInfo.offset);
  ```