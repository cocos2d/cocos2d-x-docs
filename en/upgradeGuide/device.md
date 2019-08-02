# Device

This is used to create some resources that need to be used in the rendering pipeline, such as buffer and texture creation. The device's implement limits can be queried via DeviceInfo.

# How to use

## Shader

```c++
auto vertexShaderModule = newShaderModule(backend::ShaderStage::VERTEX, shaderSource);
auto fragmenShaderModule = newShaderModule(backend::ShaderStage::FRAGMENT, shaderSource);
```

`newShaderModule` is a protected interface to Device that maintains and reuses ShaderModules by ShaderCache.

```c++
auto vertexShader = ShaderCache::newVertexShaderModule(vertexShaderSource);
auto fragmentShader = ShaderCache::newFragmentShaderModule(fragmentShaderSource);
```

## Program

```c++
auto program = backend::Device::getInstance()->newProgram(vertexShaderSource,
                                                          fragmentShaderSource);
```

`newProgram` is a protected interface of Device that is created and reused by ProgramCache.

```c++
auto program = backend::ProgramCache::getInstance()->newProgram(vertexShaderSource,
                                                                fragmentShaderSource);
```

## Buffer

```c++
auto device = backend::Device::getInstance();
_indexBuffer = device->newBuffer(indexBufferSize,
                                 Backend::BufferType::INDEX,
                                 Backend::BufferUsage::STATIC);
_indexBuffer->updateData(&_indices[0], indexBufferSize);
```

## Texture

```c++
backend::TextureDescriptor descriptor;
descriptor.width = width;
descriptor.height = height;
descriptor.textureFormat = backend::PixelFormat::RGBA8888;

auto backendTexture = backend::Device::getInstance()->newTexture(descriptor);
backendTexture->updateData(textureData, width, height, level);
```

## BlendState

```c++
auto& blendDescriptor = _pipelineDescriptor.blendDescriptor;
blendDescriptor.blendEnabled = true;
blendDescriptor.sourceRGBBlendFactor = backend::BlendFactor::SRC_ALPHA;
blendDescriptor.sourceAlphaBlendFactor = backend::BlendFactor::SRC_ALPHA;;
blendDescriptor.destinationRGBBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;
blendDescriptor.destinationAlphaBlendFactor = backend::BlendFactor::ONE_MINUS_SRC_ALPHA;

auto blendState = device->createBlendState(blendDescriptor);
```

## DepthStencilState

```c++
auto renderer = Director::getInstance()->getRenderer();
renderer->setDepthTest(true);
renderer->setDepthWrite(true);
renderer->setDepthCompareFunction(backend::CompareFunction::LESS_EQUAL);

auto depthStencilState = device->createDepthStencilState(_depthStencilDescriptor);
_commandBuffer->setDepthStencilState(depthStencilState);
```

## RenderPipeline

```c++
backend::RenderPipelineDescriptor renderPipelineDescriptor;
renderPipelineDescriptor.programState = ...
  ...
 auto renderPipeline = device->newRenderPipeline(renderPipelineDescriptor);
_commandBuffer->setRenderPipeline(renderPipeline);
```

## getDeviceInfo

Features used for query driver support, such as obtaining the maximum number of attributes supported, whether the query supports texture compression formats, etc.

```c++
int maxAttributes = Configuration::getInstance()->getMaxAttributes();
bool isSupportsETC1 = Configuration::getInstance()->supportsETC();
```