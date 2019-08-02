# Renderer

Compared with V3, the Renderer changes in V4 are mainly reflected in the following three parts: [Initialization](#Initialization), [Rendering](#Rendering), [Global State Setting](#Global State Setting).

# Initialization

## Initialization Triple Buffering

Unlike the OpenGL state machine mechanism, before a frame starts drawing, Metal creates a CommandBuffer through the CommandQueue, and the RenderCommandEncoder adds a GPU instruction to the CommandBuffer. Finally, when the frame is drawn, the GPU is notified by submitting the CommandBuffer. carried out.

For rendering scenarios where Buffers need to be updated frequently, there may be CPU execution faster than the GPU, causing the CommandBuffer submitted in the previous frame to be unexecuted by the GPU, and the next frame CPU has updated the Buffer data. In this case, the triple buffering mechanism is implemented in Renderer.

```c++
// For complex scenes, the pre-allocated Buffer size may not be enough. TriangleCommand 
// batch, dynamic expansion through TriangleCommandBufferManager
_triangleCommandBufferManager.init(); 
_vertexBuffer = _triangleCommandBufferManager.getVertexBuffer();
_indexBuffer = _triangleCommandBufferManager.getIndexBuffer();
```

## Create CommandBuffer

The state associated with GPU rendering is set to the GPU rendering pipeline via CommandBuffer.

```c++
auto device = backend::Device::getInstance();
_commandBuffer = device->newCommandBuffer();
```

# Rendering

## 清屏

Set the clear screen operation before each frame is drawn, and specify the buffer to be cleared by ClearFlag.

```c++
Color4F color(0.f, 0.f, 0.f, 0.f);
renderer->clear(ClearFlag::COLOR, //只清除颜色缓冲区
                color, //clear color value
                1,     //clear depth value
                0, 		 //clear stencil value
                _globalZOrder);
```

  Note: if you need to clear the off-screen buffer, you need to set [RenderTarget](#RenderToTexture) in advance.

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

Mark the beginning of a frame.

For Metal,

1. An MTLCommandBuffer is created for each frame and added to the MTLCommandQueue queue.
2. Update tripple buffering.

### beginRenderPass

Each RenderCommand corresponds to a RenderPass, and beginRenderPass represents the start of RenderPass, which is used to set the rendering pipeline state, such as setting attachment, setting viewport, setting depth/stencil state, and so on. When ending RenderPass, you need to call [endRenderPass](#endRenderPass).

### endRenderPass

Release resources.

### endFrame

End the drawing of one frame and clear the cache state.

## Screen capture

```c++
CaptureScreenCallbackCommand _captureScreenCommand;
_captureScreenCommand.init(_globalZOrder);
_captureScreenCommand.func = std::bind(onCaptureScreen, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3);
renderer->addCommand(&_captureScreenCommand);
```

# Global status setting

Common settings include: viewport, scissor Rectangle, depth, stencil, renderTarget, and more.

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

  

  When the color/depth/stencil attachment texture is not specified, the attachment texture provided by the system is used by default, otherwise the user-specified attachment texture is used. Note that when texture is used as a render target, you need to specify textureUsage to be RENDER_TARGET.

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
