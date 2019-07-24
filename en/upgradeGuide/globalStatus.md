# Global Status Overview

The only way to change the global state in V4 is through the `Renderer` object. For example, turn on the depth test. Next, we will analyze how to set the global state and fixed pipeline functions through the Renderer.

# clear attachment

Specify the buffer to be emptied by `ClearFlag`

```c++
_renderer->clear(ClearFlag::ALL, // Clear color, depth and stencil buffer.
  _clearColor, // the color value used when the color buffer is cleared
  1, // the depth value used when the depth buffer is cleared
  0, // the index used when the stencil buffer is cleared
  -10000.0); // specify the globalOrder value
```

# Depth Test

In the initialization function, set a callback function to save and restore the original global state.

```c++
void Demo::init()
{
    _customCommand.setBeforeCallback(CC_CALLBACK_0(Demo::onBeforeDraw, this));
    _customCommand.setAfterCallback(CC_CALLBACK_0(Demo::onAfterDraw, this));
}
```

- onBeforeDraw

  ```c++
  void Demo::onBeforeDraw()
  {
    auto renderer = Director::getInstance()->getRenderer();
    // manually save the global state
    _oldDepthTestEnabled = renderer->getDepthTest();
    _oldDepthWriteMask = renderer->getDepthWrite();
    _oldDepthCmpFunc = renderer->getDepthCompareFunction();
  ... // store other global state, such as cull mode.
    renderer->setDepthTest(true);
    renderer->setDepthWrite(true);
    renderer->setDepthCompareFunction(backend::CompareFunction::LESS_EQUAL);
    ... //do additional operations.
  }
  ```

- onAfterDraw

  ```c++
  void Demo::onAfterDraw()
  {
    auto renderer = Director::getInstance()->getRenderer();
    // manually restore the global state
    renderer->setDepthTest(_oldDepthTestEnabled);
    renderer->setDepthWrite(_oldDepthWriteMask);
    renderer->setDepthCompareFunction(_oldDepthCmpFunc);
    ...restore other global state
  }
  ```

# Stencil Test

As with [Depth Test](#Depth Test), set the callback function to save and restore the original global state.

```c++
void Demo::init()
{
    _customCommand.setBeforeCallback(CC_CALLBACK_0(Demo::onBeforeDraw, this));
    _customCommand.setAfterCallback(CC_CALLBACK_0(Demo::onAfterDraw, this));
}
```

- onBeforeDraw

  ```c++
  void Demo::onBeforeDraw()
  {
      auto renderer = Director::getInstance()->getRenderer();
      // manually save the stencil state
      _oldStencilEnabled = renderer->getStencilTest();
      _oldStencilWriteMask = renderer->getStencilWriteMask();
      _oldStencilFunc = renderer->getStencilCompareFunction();
      _oldStencilRef = renderer->getStencilReferenceValue();
      _oldStencilReadMask = renderer->getStencilReadMask();
      _oldStencilFail = renderer->getStencilFailureOperation();
      _oldStencilPassDepthFail = renderer->getStencilPassDepthFailureOperation();
      _oldStencilPassDepthPass = renderer->getStencilDepthPassOperation();
    ... // save other global states
  
      // set stencil states
      renderer->setStencilTest(true);
      renderer->setStencilWriteMask(_writeMask);
      renderer->setStencilCompareFunction(_compareFunction,
                                          _refValue,
                                          _readMask);
      renderer->setStencilOperation(_sfailOp,
                                    _zfailOp,
                                    _zpassOp);
  }
  ```

- onAfterDraw

  ```c++
  void StencilStateManager::onAfterVisit()
  {
      // manually restore the stencil state
      auto renderer = Director::getInstance()->getRenderer();
      renderer->setStencilCompareFunction(_oldStencilFunc,
                                          _oldStencilRef,
                                          _oldStencilReadMask);
  
      renderer->setStencilOperation(_oldFail,
                                    _oldPassDepthFail,
                                    _oldPassDepthPass);
  
      renderer->setStencilWriteMask(_oldStencilWriteMask);
      if (!_oldStencilEnabled)
      {
          renderer->setStencilTest(false);
      }
  }
  ```

# Viewport

```c++
// save current viewport
_oldViewport = renderer->getViewport(); 
renderer->setViewPort(viewport.origin.x, 
                      viewport.origin.y, 
                      viewport.size.width, 
                      viewport.size.height);
```

# Scissor

```c++
//save scissor test status
_oldScissorTest = renderer->getScissorTest();
_oldScissorRect = renderer->getScissorRect();

//set scissor test
renderer->setScissorTest(true);
renderer->setScissorRect(x, y, width, height);

//restore scissor test status
renderer->setScissorTest(_oldScissorTest);
renderer->setScissorRect(_oldScissorRect.x, 
                         _oldScissorRect.y, 
                         _oldScissorRect.width, 
                         _oldScissorRect.height);
```

# CullMode

```c++
_oldCullMode = renderer->getCullMode();
renderer->setCullMode(cullMode);
```

# Winding

```c++
_oldWinding = renderer->getWinding();
renderer->setWinding(winding);
```

# Set render target

设置用于保存和恢复 attachment 的回调函数。

```c++
void Demo::init()
{
  	_beginCallbackCommand.func = CC_CALLBACK_0(RenderTexture::onBegin, this);
    _endCallbackCommand.func = CC_CALLBACK_0(RenderTexture::onEnd, this);
}
```

- onBegin

  ```c++
  //save attachemnt status
  _oldColorAttachment = renderer->getColorAttachment();
  _oldDepthAttachment = renderer->getDepthAttachment();
  _oldStencilAttachment = renderer->getStencilAttachment();
  _oldRenderTargetFlag = renderer->getRenderTargetFlag();
  
  renderer->setRenderTarget(_renderTargetFlags, // indicate which attachment to be replaced 
                            _texture2D, 
                            _depthTexture, 
                            _stencilTexture);
  ```

- onEnd

  ```c++
  renderer->setRenderTarget(_oldRenderTargetFlag, 
                            _oldColorAttachment, 
                            _oldDepthAttachment, 
                            _oldStencilAttachment);
  ```
