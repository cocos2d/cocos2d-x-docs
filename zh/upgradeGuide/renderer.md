# Overview

与V3相比，V4版本下的 Renderer 变化主要体现在以下三大部分：[初始化](#初始化)，[渲染](#渲染)，[全局状态设置](#全局状态设置)。

# 初始化

## 初始化 Triple Buffering

与 OpenGL 状态机机制不同的是，在一帧开始绘制之前，Metal 通过 CommandQueue 创建 CommandBuffer，由 RenderCommandEncoder 将一条条 GPU 指令添加到 CommandBuffer中，最终在结束该帧绘制时，通过提交 CommandBuffer 的方式，通知 GPU 执行。

对于需要频繁更新 Buffer 的渲染情景， 可能存在 CPU 执行比 GPU 快，导致上一帧提交的 CommandBuffer 还未被 GPU 执行完，下一帧 CPU 就已经更新了 Buffer 数据。针对这种情况，Renderer 中实现了 triple buffering 机制。

```c++
//对于复杂的场景，预分配的 Buffer 大小可能不够 TriangleCommand batch，通过 TriangleCommandBufferManager 可以实现动态扩展
_triangleCommandBufferManager.init(); 
_vertexBuffer = _triangleCommandBufferManager.getVertexBuffer();
_indexBuffer = _triangleCommandBufferManager.getIndexBuffer();
```

## 创建 CommandBuffer

与 GPU 渲染相关的状态，都是通过 CommandBuffer 设置到 GPU 渲染管线中。

```c++
auto device = backend::Device::getInstance();
_commandBuffer = device->newCommandBuffer();
```

# 渲染

## 清屏

在每帧绘制之前设置清屏操作，通过 ClearFlag 指定需要清除的缓冲区。

```c++
Color4F color(0.f, 0.f, 0.f, 0.f);
renderer->clear(ClearFlag::COLOR, //只清除颜色缓冲区
                color, //clear color value
                1,     //clear depth value
                0, 		 //clear stencil value
                _globalZOrder);
```

需要注意的是，如果需要清除 off-screen 缓冲区，需要事先设置 [RenderTarget](#RenderToTexture)。

```c++
auto renderer = Director::getInstance()->getRenderer();
_beforeClearAttachmentCommand.func = [=]() -> void {
  _oldColorAttachment = renderer->getColorAttachment();
  renderer->setRenderTarget(RenderTargetFlag::COLOR, _texture2D, nullptr, nullptr);
};
renderer->addCommand(&_beforeClearAttachmentCommand);

Color4F color(0.f, 0.f, 0.f, 0.f);
renderer->clear(ClearFlag::COLOR, color, 1, 0, _globalZOrder);

_afterClearAttachmentCommand.func = [=]() -> void {
  renderer->setRenderTarget(RenderTargetFlag::COLOR, _oldColorAttachment, nullptr, nullptr);
};
renderer->addCommand(&_afterClearAttachmentCommand);
```

### beginFrame

标记一帧的开始。

对于Metal，

1. 每帧会创建一个 MTLCommandBuffer，并加入到 MTLCommandQueue 队列中。
2. 更新 tripple buffering。

### beginRenderPass

每个 RenderCommand 对应一个 RenderPass，beginRenderPass表示 RenderPass 的开始，用于设置渲染管线状态，如设置 attachment，设置 viewport，设置 depth/stencil 状态等。当结束RenderPass的，需要调用 [endRenderPass](#endRenderPass)。

### endRenderPass

释放资源。

### endFrame

结束一帧的绘制，清空缓存状态。

## 截屏

```c++
CaptureScreenCallbackCommand _captureScreenCommand;
_captureScreenCommand.init(_globalZOrder);
_captureScreenCommand.func = std::bind(onCaptureScreen, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3);
renderer->addCommand(&_captureScreenCommand);
```

# 全局状态设置

常见的设置包括：viewport， scissor Rectangle，depth，stencil，renderTarget等。

- viewport

  ```c++
  Size size = director->getWinSizeInPixels();
  renderer->setViewPort(0, 0, size.width, size.height);
  ```

- scissor

  ```c++
  auto glview = Director::getInstance()->getOpenGLView();
  glview->setScissorInPoints(clippingRect.origin.x,
                             clippingRect.origin.y,
                             clippingRect.size.width,
                             clippingRect.size.height);
  ```

- set depth

  ```c++
  renderer->setDepthTest(true); //开启深度测试
  renderer->setDepthWrite(true);//允许更新深度缓冲区
  renderer->setDepthCompareFunction(backend::CompareFunction::LESS); //设置深度比较函数
  ```

- set stencil

  ```c++
  renderer->setStencilTest(true);
  renderer->setStencilWriteMask(0x1);
  renderer->setStencilCompareFunction(backend::CompareFunction::NEVER,
                                      0x1, 
                                      0x1);
  renderer->setStencilOperation(backend::StencilOperation::REPLACE,
          backend::StencilOperation::KEEP,
          backend::StencilOperation::KEEP);
  ```

- RenderToTexture

  ```c++
  Renderer::setRenderTarget(RenderTargetFlag flags, 
                            Texture2D* colorAttachment,
                            Texture2D* depthAttachment,
                            Texture2D* stencilAttachment)
  ```

  

  当未指定 color/depth/stencil attachment texture 时，采用系统默认提供的 attachment texture，否则使用用户指定的 attachment texture。需要注意的是，当 texture 用作 render target 时，需要指定 textureUsage 为 RENDER_TARGET。

  ```c++
  backend::TextureDescriptor descriptor;
  descriptor.width = _width;
  descriptor.height = _height;
  descriptor.textureUsage = TextureUsage::RENDER_TARGET;
  descriptor.textureFormat = PixelFormat::RGBA8888;
  auto texture = backend::Device::getInstance()->newTexture(descriptor);
  
  _texture2D = new (std::nothrow) Texture2D();
  _texture2D->initWithBackendTexture(texture);
  _texture2D->setRenderTarget(true);
  texture->release();
  
  _renderTargetFlags = RenderTargetFlag::COLOR;
  
  auto renderer = Director::getInstance()->getRenderer();
  _beforeClearAttachmentCommand.func = [=]() -> void {
    _oldColorAttachment = renderer->getColorAttachment();
    renderer->setRenderTarget(RenderTargetFlag::COLOR, _texture2D, nullptr, nullptr);
  };
  renderer->addCommand(&_beforeClearAttachmentCommand);
  
  Color4F color(0.f, 0.f, 0.f, 0.f);
  renderer->clear(ClearFlag::COLOR, color, 1, 0, _globalZOrder);
  
  _afterClearAttachmentCommand.func = [=]() -> void {
    renderer->setRenderTarget(RenderTargetFlag::COLOR, _oldColorAttachment, nullptr, nullptr);
  };
  renderer->addCommand(&_afterClearAttachmentCommand);
  ```

