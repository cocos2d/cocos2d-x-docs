# Overview

用于创建渲染管线中需要用到的一些资源，如 buffer，texture 的创建。可通过 DeviceInfo 查询设备的 implement limits。

# How to use

## Shader

```c++
auto vertexShaderModule = newShaderModule(backend::ShaderStage::VERTEX, shaderSource);
auto fragmenShaderModule = newShaderModule(backend::ShaderStage::FRAGMENT, shaderSource);
```

`newShaderModule` 是 Device 的一个 protected 接口，由 ShaderCache 维护 ShaderModule 的创建和复用。

```c++
auto vertexShader = ShaderCache::newVertexShaderModule(vertexShaderSource);
auto fragmentShader = ShaderCache::newFragmentShaderModule(fragmentShaderSource);
```

## Program

```c++
auto program = backend::Device::getInstance()->newProgram(vertexShaderSource,
                                                          fragmentShaderSource);
```

`newProgram` 是 Device 的一个 protected 接口，由 ProgramCache 维护 Program 的创建和复用。

```c++
auto program = backend::ProgramCache::getInstance()->newProgram(vertexShaderSource, 
                                                                fragmentShaderSource);
```

## Buffer

```c++
auto device = backend::Device::getInstance();
_indexBuffer = device->newBuffer(indexBufferSize, 
                                 backend::BufferType::INDEX, 
                                 backend::BufferUsage::STATIC);
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

用于查询驱动支持的特性，如获取支持最大的 attribute 数量，查询是否支持纹理压缩格式等。

```c++
int maxAttributes = Configuration::getInstance()->getMaxAttributes(); 
bool isSupportsETC1 = Configuration::getInstance()->supportsETC();
```





