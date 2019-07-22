# Pipeline Descriptor Overview

As a private member of `RenderCommand`, it is used to save the [PrgramState](#ProgramSate), [BlendDescriptor](#BlendDescriptor), and [VertexLayout](#VertexLayout) used by the current `RenderCommand`.

```c++
struct CC_DLL PipelineDescriptor
{
    backend::ProgramState* programState = nullptr;
    backend::BlendDescriptor blendDescriptor;
    backend::VertexLayout vertexLayout;
};
```

# ProgramSate

## Create ProgramState

When creating a `ProgramState` object, you need to pass in the vertex and fragment shader.

```c++
auto programState = new (std::nothrow) backend::ProgramState(vert, frag);

auto& pipelineDescriptor = _trianglesCommand.getPipelineDescriptor();
pipelineDescriptor.programState = programState;
```

## Setting vertex buffer

- TrianglesCommand

  Due to the mechanism of the `TrianglesCommand` batch, multiple adjacent `TrianglesCommands` may be merged into one. The creation of vertex buffer is not managed in the `TrianglesCommand`, but is automatically managed by the `TriangleCommandBufferManager` in the `Renderer`.

- CustomCommand

  ```c++
  unt16_t indices[6] = { 0, 1, 2, 2, 3, 0 };
  V2F_C4B_T2F *_buffer = (V2F_C4B_T2F*) malloc(_bufferCapacity*sizeof(V2F_C4B_T2F));
  
  _customCommand.createVertexBuffer(sizeof(V2F_C4B_T2F), _bufferCapacity, CustomCommand::BufferUsage::DYNAMIC);
  _customCommand.createIndexBuffer(CustomCommand::IndexFormat::U_SHORT, sizeof(indices) / sizeof(indices[0]), CustomCommand::BufferUsage::STATIC);
  
  _customCommand.updateVertexBuffer(_buffer, _bufferCapacity*sizeof(V2F_C4B_T2F));
  _customCommand.updateIndexBuffer(indices, sizeof(indices));
  ```

## Setting up Uniform

First get the uniform location via the ProgramState object:

```c++
auto mvpMatrixLocation = programState->getUniformLocation("u_MVPMatrix");
auto textureLocation = programState->getUniformLocation("u_texture");
```

Then set uniform data according to uniform location:

```c++
const auto& projectionMat = Director::getInstance()->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);

programState->setUniform(mvpMatrixLocation, projectionMat.m, sizeof(projectionMat.m));
programState->setTexture(textureLocation, 0, _texture->getBackendTexture());
```

The advantage of setting uniform through location is that you don't have to look up the location through the uniform name every time, saving CPU overhead.

## backend

- Set Uniform Buffer

  In Metal, vertex unifrom and fragment uniform data are stored in programState's vertexUniformBuffer and fragmentUniformBuffer respectively.

  ```c++
  // Uniform buffer is bound to index 1.
  auto vertexUniformBuffer = _programState->getVertexUniformBuffer();
  if(vertexUniformBuffer.size() > 0)
  {
    [_mtlRenderEncoder setVertexBytes:vertexUniformBuffer.data()
                               Length:vertexUniformBuffer.size()
                              atIndex:1];
  }
  
  auto fragmentUniformBuffer = _programState->getFragmentUniformBuffer();
  if(fragmentUniformBuffer.size() > 0)
  {
    [_mtlRenderEncoder setFragmentBytes:fragmentUniformBuffer.data()
                                 Length:fragmentUniformBuffer.size()
                                atIndex:1];
  }
  ```

  In OpenGL, the uniform data is stored in VertexUniformInfos where their respective locations are located.

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

  For Metal, Texture data is stored in ProgramState's _vertexTextureInfos and _fragmentTextureInfos, respectively.

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

  In OpenGL, Texture data is stored in ProgramState's _vertexTextureInfos.

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

  Take CustomCommand as an example, set VertexBuffer through CommandBuffer.

  ```c++
  _commandBuffer->setVertexBuffer(0, customCommand->getVertexBuffer());
  ```

  For Metal, vertex buffer is always bound to index 0：

  ```c++
  // Vertex buffer is bound in index 0.
  [_mtlRenderEncoder setVertexBuffer:static_cast<BufferMTL*>(buffer)->getMTLBuffer()
                              offset:0
                             atIndex:0];
  ```

  For OpenGL, associate the vertex attribute data with VBO:

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

- Set the Blend function

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

- Create a Blend function

  ```c++
  auto blendState = device->createBlendState(pipelineDescriptor.blendDescriptor);
  ```

- Set the Blend object to the Pipeline

  ```c++
  backend::RenderPipelineDescriptor renderPipelineDescriptor;
  renderPipelineDescriptor.programState = ...
    ...
  renderPipelineDescriptor.blendState = blendState;
  ```

- Apply BlendState

  For Metal, the setting of the blend state is ultimately in the `RenderPipelineMTL::setBlendState` function:

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

  For OpenGL, the setting of the blend state is in `BlendStateGL::apply`:

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

- Record the layout of each vertex attribute in the vertex buffer.

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

  In Metal, the vertex layout is set to MTLRenderPipelineDescriptor via `RenderPipelineMTL::setVertexLayout`.

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

  In OpenGL, you need to update the vertexLayout of the CommandBuffer first:

  ```c++
  _commandBuffer->updateVertexLayouts(renderPipelineDescriptor.vertexLayouts);
  ```

  Then bind the vertex attribute data according to vertexLayout in `CommandBufferGL::bindVertexBuffer`.

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