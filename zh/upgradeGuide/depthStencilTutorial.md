# Overview

本范例以 ClippingNode 为例，介绍如何开启，设置 depth/stencil。介绍如何使用 CustomCommand的回调函数，设置全局状态。

# 创建 ClippingNode

```c++
auto clipper = ClippingNode::create();
clipper->setAnchorPoint(Vec2::ANCHOR_BOTTOM_LEFT);
clipper->setContentSize(cocos2d::Size(w, h));
clipper->setPosition(x, y);

auto stencil = DrawNode::create();
stencil->setAnchorPoint(Vec2::ZERO);
stencil->drawSolidRect(origin, size, color);

clipper->setStencil(stencil);
```

ClippingNode 通过 StencilStateManager 管理 depth/stencil 状态设置。因此我们进入 StencilStateManager 一探究竟。

# StencilStateManager

同样，在 StencilStateManager 构造函数中，初始化 backend::PipelineDescriptor。此处不在赘述，参考[范例2](customCommandTutorial.md)。

## onBeforeVisit

在执行清空 stenicl buffer 之前，需要记录当前 stencil 状态，以便于在结束 stencil 测试之后，恢复这些状态。因此需要通过 CustomCommand 的 `setBeforeCallback` 和 `setAfterCallback` 设置回调函数。

```c++
void StencilStateManager::onBeforeVisit(float globalZOrder)
{
    _customCommand.setBeforeCallback(CC_CALLBACK_0(StencilStateManager::onBeforeDrawQuadCmd, this));
    _customCommand.setAfterCallback(CC_CALLBACK_0(StencilStateManager::onAfterDrawQuadCmd, this));

    // draw a fullscreen solid rectangle to clear the stencil buffer
    drawFullScreenQuadClearStencil(globalZOrder);
}
```

- onBeforeDrawQuadCmd

  ```c++
  void StencilStateManager::onBeforeDrawQuadCmd()
  {
      auto renderer = Director::getInstance()->getRenderer();
      updateLayerMask();
      // manually save the stencil state
      _currentStencilEnabled = renderer->getStencilTest();
      _currentStencilWriteMask = renderer->getStencilWriteMask();
      _currentStencilFunc = renderer->getStencilCompareFunction();
      _currentStencilRef = renderer->getStencilReferenceValue();
      _currentStencilReadMask = renderer->getStencilReadMask();
      _currentStencilFail = renderer->getStencilFailureOperation();
      _currentStencilPassDepthFail = renderer->getStencilPassDepthFailureOperation();
      _currentStencilPassDepthPass = renderer->getStencilDepthPassOperation();
  
      // enable stencil use
      renderer->setStencilTest(true);
  
      // all bits on the stencil buffer are readonly, except the current layer bit,
      // this means that operation like glClear or glStencilOp will be masked with this value
      renderer->setStencilWriteMask(_currentLayerMask);
  
      // manually save the depth test state
      _currentDepthWriteMask = renderer->getDepthWrite();
  
      // disable update to the depth buffer while drawing the stencil,
      // as the stencil is not meant to be rendered in the real scene,
      // it should never prevent something else to be drawn,
      // only disabling depth buffer update should do
      renderer->setDepthWrite(false);
  
      // CLEAR STENCIL BUFFER
      // manually clear the stencil buffer by drawing a fullscreen rectangle on it
      // setup the stencil test func like this:
      // for each pixel in the fullscreen rectangle
      //     never draw it into the frame buffer
      //     if not in inverted mode: set the current layer value to 0 in the stencil buffer
      //     if in inverted mode: set the current layer value to 1 in the stencil buffer
      renderer->setStencilCompareFunction(backend::CompareFunction::NEVER, 
                                          _currentLayerMask, 
                                          _currentLayerMask);
      renderer->setStencilOperation(!_inverted ? backend::StencilOperation::ZERO : backend::StencilOperation::REPLACE, 
                                    backend::StencilOperation::KEEP, 
                                    backend::StencilOperation::KEEP);
  }
  ```

- drawFullScreenQuadClearStencil

  ```c++
  // draw a fullscreen solid rectangle to clear the stencil buffer
  void StencilStateManager::drawFullScreenQuadClearStencil(float globalZOrder)
  {
      _customCommand.init(globalZOrder);
      Director::getInstance()->getRenderer()->addCommand(&_customCommand);
      _programState->setUniform(_mvpMatrixLocaiton, Mat4::IDENTITY.m, sizeof(Mat4::IDENTITY.m));
  }
  ```

- onAfterDrawQuadCmd

  ```c++
  void StencilStateManager::onAfterDrawQuadCmd()
  {
      auto renderer = Director::getInstance()->getRenderer();
      // DRAW CLIPPING STENCIL
    	// setup the stencil test func like this:
  		// for each pixel in the stencil node
  		//     never draw it into the frame buffer
  		//     if not in inverted mode: set the current layer value to 1 in the stencil buffer
  		//     if in inverted mode: set the current layer value to 0 in the stencil buffer
      renderer->setStencilCompareFunction(backend::CompareFunction::NEVER,
                                          _currentLayerMask, 
                                          _currentLayerMask);
  
      renderer->setStencilOperation(!_inverted ? backend::StencilOperation::REPLACE : backend::StencilOperation::ZERO, 
                                    backend::StencilOperation::KEEP, 
                                    backend::StencilOperation::KEEP);
  }
  ```

## onAfterDrawStencil

```c++
void StencilStateManager::onAfterDrawStencil()
{
    // restore the depth test state
    auto renderer = Director::getInstance()->getRenderer();
    renderer->setDepthWrite(_currentDepthWriteMask);
    
    ///////////////////////////////////
    // DRAW CONTENT
    
    // setup the stencil test function like this:
    // for each pixel of this node and its children
    //     if all layers less than or equals to the current are set to 1 in the stencil buffer
    //         draw the pixel and keep the current layer in the stencil buffer
    //     else
    //         do not draw the pixel but keep the current layer in the stencil buffer
    renderer->setStencilCompareFunction(backend::CompareFunction::EQUAL, 
                                        _mask_layer_le, 
                                        _mask_layer_le);

    renderer->setStencilOperation(backend::StencilOperation::KEEP,
                                  backend::StencilOperation::KEEP,
                                  backend::StencilOperation::KEEP);
}
```

## onAfterVisit

恢复 depth/stencil 状态。

```c++
void StencilStateManager::onAfterVisit()
{
    ///////////////////////////////////
    // CLEANUP
    
    // manually restore the stencil state
    auto renderer = Director::getInstance()->getRenderer();
    renderer->setStencilCompareFunction(_currentStencilFunc, 
                                        _currentStencilRef, 
                                        _currentStencilReadMask);

    renderer->setStencilOperation(_currentStencilFail, 
                                  _currentStencilPassDepthFail,
                                  _currentStencilPassDepthPass);

    renderer->setStencilWriteMask(_currentStencilWriteMask);
    if (!_currentStencilEnabled)
    {
        renderer->setStencilTest(false);
    }
    
    // we are done using this layer, decrement
    s_layer--;
}
```



