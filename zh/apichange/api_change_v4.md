# V3 到 V4 API 变更

以下内容列举了主要的接口变更

### 类 `cocos2d::ActionManager`

- 移除 `numberOfRunningActionsInTarge`, 使用 `getNumberOfRunningActionsInTarget` 替代. 

### 类 `cocos2d::Animate3D`

- 移除 `getPlayBack`
- 移除 `setPlayBack`

### 类 `cocos2d::Animation`

- 重命名 `addSpriteFrameWithFileName` 为 `addSpriteFrameWithFile`.

### 类 `cocos2d::Animation3D`

- 移除 `getOrCreate`, 使用 `create` 替代.

### 类 `cocos2d::AnimationCache`

- 移除 `purgeSharedAnimationCache`, 使用 `destroyInstance` 替代.
- 移除 `sharedAnimationCache`, 使用 `getInstance` 替代.
- 移除 `animationByName`, 使用 `getAnimation` 替代.
- 移除 `removeAnimationByName`, 使用 `removeAnimation` 替代.

### 类 `cocos2d::AsyncTaskPool`

- 拼写修复 `destoryInstance` 为 `destroyInstance`

### 替换 GLProgram & GLProgramState 为 Program & ProgramState

### 移除 类 `cocos2d::BatchCommand`

### 新增 类 `cocos2d::CallbackCommand`

### 类 `cocos2d::CallFunc`

- 移除 `create(cocos2d::Ref *, cocos2d::SEL_CallFunc)`
- 移除 `initWithTarget`
- 移除 `setTargetCallback`

### 类 `cocos2d::CallFuncN`

- 移除 `create(cocos2d::Ref *, cocos2d::SEL_CallFuncN)`
- 移除 `initWithTarget`

### 类 `cocos2d::Camera`
- 移除 `applyFrameBufferObject`
- 移除 `restore`
- 移除 `applyFrameBufferObject`
- 移除 `restoreFrameBufferObject`
- 移除 `restoreViewport`
- 移除 `setFrameBufferObject`
- 移除 `setViewport`

### NEW 类 `cocos2d::CaptureScreenCallbackCommand`

### 类 `cocos2d::Clonable`

- 移除 `copy`

### 类 `cocos2d::Configuration`

- 移除 `purgeConfiguration`
- 移除 `sharedConfiguration`
- 移除 `getInfoAsMap`
- 新增 `getMaxAttributes`


### 类 `cocos2d::CustomCommand` reform

### 类 `cocos2d::Director`

- 移除 `sharedDirector`, 使用 `getInstance` 替代.
- 移除 `getClearColor`
- 移除 `getProjectionMatrix`, access through `Camera`
- 移除 `getProjectionMatrixStackSize`
- 移除 `initProjectionMatrixStack`
- 移除 `loadProjectionIdentityMatrix`
- 移除 `loadProjectionMatrix`
- 移除 `multiplyProjectionMatrix`
- 移除 `popProjectionMatrix`
- 移除 `pushProjectionMatrix`
- 移除 `setAlphaBlending`, access though `Renderer`
- 移除 `setDepthTest`, access though `Renderer`

### 类 `cocos2d::DrawNode`

- 移除 `drawQuadraticBezier`

### 移除 类 `cocos2d::experimental::FrameBuffer`
### 移除 类 `cocos2d::experimental::RenderTargetBase`
### 移除 类 `cocos2d::experimental::RenderTargetDepthStencil`
### 移除 类 `cocos2d::experimental::RenderTargetRenderBuffer`

### 类 `cocos2d::FileUtils`

- 移除 `purgeFileUtils`, 使用 `destroyInstance` 替代.
- 移除 `sharedFileUtils`, 使用 `getInstance` 替代.
- 移除 `getFileData`, 使用 `getDataFromFile` 替代.

### 类 `cocos2d::Follow`

- 拼写修复 `setBoudarySet` 为 `setBoundarySet`

### 类 `cocos2d::Font`

- 移除 `getHorizontalKerningForTextUTF16`

### 类 `cocos2d::GLView`

- 移除 `getVR`
- 移除 `pollInputEvents`
- 移除 `setCursor`
- 移除 `setDefaultCursor`
- 移除 `setVR`

### 类 `cocos2d::Grid3D`

- 移除 `originalVertex`, 使用 `getOriginalVertex` 替代.
- 移除 `vertex`, 使用 `getVertex` 替代.

### 类 `cocos2d::GridBase`

- 移除 `create(const cocos2d::Size &, cocos2d::Texture2D *, bool)`
- 移除 `create(const cocos2d::Size &)`

### 类 `cocos2d::Image`

- 重命名 `getRenderFormat` 为 `getPixelFormat`.
- 移除 `isPremultipliedAlpha`, 使用 `hasPremultipliedAlpha` 替代.
- 重命名 `premultiplyAlpha` 为 `premultipliedAlpha`.
- 移除 `reversePremultipliedAlpha`

### 类 `cocos2d::IMEDispatcher`

- 移除 `isAnyDelegateAttachedWithIME`

### 移除 类 `cocos2d::IndexBuffer`

### 类 `cocos2d::Label`

- 移除 `getCommonLineHeight`
- 移除 `getFontDefinition`
- 移除 `setFontDefinition`
- 新增 `setProgramState`

### 类 `cocos2d::Layer`

- 移除 `ccTouchBegan`, 使用 `onTouchBegan` 替代.
- 移除 `ccTouchCancelled`, 使用 `onTouchCancelled` 替代.
- 移除 `ccTouchEnded`, 使用 `onTouchEnded` 替代.
- 移除 `ccTouchesBegan`, 使用 `onTouchesBegan` 替代.
- 移除 `ccTouchesCancelled`, 使用 `onTouchesCancelled` 替代.
- 移除 `ccTouchesEnded`, 使用 `onTouchesEnded` 替代.
- 移除 `ccTouchesMoved`, 使用 `onTouchesMoved` 替代.
- 移除 `ccTouchMoved`, 使用 `onTouchMoved` 替代.
- 移除 `didAccelerate`
- 移除 `isAccelerometerEnabled`
- 移除 `isKeyboardEnabled`
- 移除 `isKeypadEnabled`
- 移除 `isSwallowsTouches`
- 移除 `isTouchEnabled`
- 移除 `keyBackClicked`
- 移除 `keyMenuClicked`
- 移除 `keyPressed`
- 移除 `keyReleased`
- 移除 `registerWithTouchDispatcher`
- 移除 `setAccelerometerEnabled`
- 移除 `setAccelerometerInterval`
- 移除 `setKeyboardEnabled`
- 移除 `setKeypadEnabled`
- 移除 `setSwallowsTouches`
- 移除 `setTouchEnabled`
- 移除 `setTouchMode`

### 移除 类 `cocos2d::LabelBMFont`

### 移除 类 `cocos2d::LabelTTF`


### 类 `cocos2d::Material`

- 重命名 `createWithGLStateProgram` 为 `createWithProgramState`.
- 新增 `createWithProgramState`
- 新增 `getRenderState`
- 新增 `getStateBlock`
- 新增 `setStateBlock`


### 类 `cocos2d::MenuItem`

- 移除 `create(cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `initWithTarget`
- 移除 `MenuItemAtlasFont`

### 类 `cocos2d::MenuItemAtlasFont`

- 移除 `create(const std::string &, const std::string &, int, int, char, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `initWithString`

### 类 `cocos2d::MenuItemFont`

- 移除 `create(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `fontName`, 使用 `getFontName` 替代.
- 移除 `fontSize`, 使用 `getFontSize` 替代.
- 移除 `fontNameObj`, 使用 `getFontNameObj` 替代.
- 移除 `fontSizeObj`, 使用 `getFontSizeObj` 替代.
- 移除 `initWithString(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### 类 `cocos2d::MenuItemImage`

- 移除 `create(const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `create(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `initWithNormalImage(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### 类 `cocos2d::MenuItemImage`

- 移除 `create(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `initWithLabel(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### 类 `cocos2d::MenuItemSprite`

- 移除 `create(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `create(cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- 移除 `initWithNormalSprite(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### 类 `cocos2d::MenuItemToggle`

- 移除 `createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, ..)`
- 移除 `createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, const Vector<cocos2d::MenuItem *> &)`
- 移除 `initWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, __va_list_tag *)`
- 移除 `selectedItem()`, 使用 `getSelectedItem` 替代.

### 类 `cocos2d::Mesh`

- 移除 `create(const std::vector<float> &, int, const cocos2d::Mesh::IndexArray &, int, const std::vector<MeshVertexAttrib> &, int)`
- 重命名 `getGLProgramState` 为 `getProgramState`. 
- 重命名 `setGLProgramState` 为 `setProgramState`.
- 移除 `getMeshCommand`
- 新增 `setVertexLayout`

### 类 `cocos2d::Node`

- 移除 `boundingBox`, used `getBoundingBox`
- 重命名 `getGLProgram` 为 `getProgramState`.
- 移除 `getGLProgramState`
- 移除 `getGLServerState`
- 移除 `getRotationX`
- 移除 `getRotationY`
- 移除 `getShaderProgram`
- 移除 `getVertexZ`
- 移除 `getZOrder`
- 移除 `ignoreAnchorPointForPosition`, 使用 `isIgnoreAnchorPointForPosition`
- 移除 `nodeToParentTransform`, 使用 `getNodeToParentTransform`
- 移除 `nodeToWorldTransform`, 使用 `getNodeToWorldTransform`
- 移除 `numberOfRunningActions`, 使用 `getNumberOfRunningActions`
- 移除 `parentToNodeTransform`, 使用 `getParentToNodeTransform`
- 移除 `pauseSchedulerAndActions`
- 重命名 `setGLProgram` 为 `setProgramState`.
- 移除 `setGLProgramState`
- 移除 `setGLServerState`
- 移除 `setRotationX`
- 移除 `setRotationY`
- 移除 `setShaderProgram`
- 移除 `setVertexZ`
- 移除 `setZOrder`
- 移除 `unscheduleAllSelectors`
- 移除 `worldToNodeTransform`, 使用 `getWorldToNodeTransform`

### 类 `cocos2d::ParticleSystem`

- 移除 `getOpacityModifyRGB`

### 类 `cocos2d::ParticleSystemQuad`

- 移除 `postStep`

### 更新类 `cocos2d::Pass`

### 类 `cocos2d::PhysicsShape`

- 拼写修复 `getPolyonCenter` 为 `getPolygonCenter`
- 拼写修复 `getTriaglesCount` 为 `getTrianglesCount`

### 类 `cocos2d::PoolManager`

- 移除 `purgePoolManager`, 使用 `destroyInstance` 替代. 
- 移除 `sharedPoolManager`, 使用 `getInstance` 替代.

### 移除 类 `cocos2d::PrimitiveCommand`

### 类 `cocos2d::Profiler`

- 移除 `sharedProfiler`, 使用 `getInstance` 替代.

### 类 `cocos2d::ProgressTimer`

- 移除 `setReverseProgress`, 使用 `setReverseDirection` 替代.

### 重新实现 cocos2d::Renderer

- 移除 `clear`
- 新增 `clear(cocos2d::ClearFlag, const cocos2d::Color4F &, float, unsigned int, float)`
- 新增 `getClearDepth`
- 新增 `getClearFlag`
- 新增 `getClearStencil`
- 新增 `getColorAttachment`
- 新增 `getCullMode`
- 新增 `getDepthAttachment`
- 新增 `getDepthCompareFunction`
- 新增 `getDepthTest`
- 新增 `getDepthWrite`
- 移除 `getGroupCommandManager`
- 移除 `initGLView`
- 新增 `getRenderTargetFlag`
- 新增 `getScissorRect`
- 新增 `getScissorTest`
- 新增 `getStencilAttachment`
- 新增 `getStencilCompareFunction`
- 新增 `getStencilDepthPassOperation`
- 新增 `getStencilFailureOperation`
- 新增 `getStencilPassDepthFailureOperation`
- 新增 `getStencilReadMask`
- 新增 `getStencilReferenceValue`
- 新增 `getStencilTest`
- 新增 `getStencilWriteMask`
- 新增 `getViewport`
- 新增 `getWinding`
- 新增 `init`
- 移除 `setClearColor`
- 新增 `setCullMode`
- 新增 `setDepthCompareFunction`
- 新增 `setDepthWrite`
- 新增 `setRenderTarget`
- 新增 `setScissorRect`
- 新增 `setScissorTest`
- 新增 `setStencilCompareFunction`
- 新增 `setStencilOperation`
- 新增 `setStencilTest`
- 新增 `setStencilWriteMask`
- 新增 `setViewPort`
- 新增 `setWinding`

### 类 `cocos2d::RenderTexture`

- 移除 `newCCImage`
- 移除 `newImage(bool)`
- 新增 `newImage(std::function<void (Image *)>, bool)`
- 移除 `saveToFileAsNonPMA`

### 类 `cocos2d::Scene`

- 移除 `onEnter`

### 类 `cocos2d::Scheduler`

- 移除 `isScheduledForTarget`
- 移除 `scheduleSelector`
- 移除 `unscheduleSelector`
- 移除 `unscheduleUpdateForTarget`

### 类 `cocos2d::ScriptEngineManager`

- 移除 `purgeSharedManager`, 使用 `destroyInstance` 替代.
- 移除 `sharedManager`, 使用 `getInstance` 替代.

### 类 `cocos2d::Sprite`

- 移除 `displayFrame`
- 移除 `getDisplayFrame`
- 新增 `getProgramState`
- 拼写修复 `setStrechEnabled` 为 `setStretchEnabled`
- 新增 `setVertexLayout`
- 新增 `updateShaders`

### 类 `cocos2d::Sprite3D`

- 移除 `getSkin`
- 新增 `setProgramState`
- 新增 `setVertexLayout`
- 移除 `setGLProgramState` 
- 移除 `setGLProgram` 

### 类 `cocos2d::Sprite3DMaterial`

- 重命名 `createWithGLStateProgram` 为 `createWithProgramState`.

### 类 `cocos2d::SpriteFrameCache`

- 移除 `purgeSharedSpriteFrameCache`, 使用 `destroyInstance` 替代.
- 移除 `sharedSpriteFrameCache`, 使用 `getInstance` 替代.
- 移除 `spriteFrameByName`, 使用 `getSpriteFrameByName` 替代.

### 类 `cocos2d::Technique`

- 重命名 `createWithGLProgramState` 为 `createWithProgramState`.
- 新增 `getStateBlock`
- 新增 `setMaterial`

### 类 `cocos2d::Texture2D`

- 重命名 `defaultAlphaPixelFormat` 为 `getDefaultAlphaPixelFormat`.
- 移除 `bitsPerPixelForFormat()`, 使用 `getBitsPerPixelForFormat` 替代.
- 签名变更`drawAtPoint(const cocos2d::Vec2 &, float)`
- 签名变更`drawInRect(const cocos2d::Rect &, float)`
- 新增 `getBackendTexture()`
- 移除 `getDescription()`
- 移除 `getGLProgram()`
- 移除 `getName()`
- 移除 `initWithData(const void *, ssize_t, Texture2D::PixelFormat, int, int, const cocos2d::Size &)`
- 移除 `initWithImage(cocos2d::Image *, cocos2d::Texture2D::PixelFormat)`
- 新增 `initWithBackendTexture(backend::TextureBackend *)`
- 新增 `initWithData(const void *, ssize_t, backend::PixelFormat, backend::PixelFormat, int, int, const cocos2d::Size &)`
- 新增 `initWithData(const void *, ssize_t, backend::PixelFormat, int, int, const cocos2d::Size &)`
- 新增 `initWithImage(cocos2d::Image *, backend::PixelFormat)`
- 移除 `initWithMipmaps(cocos2d::MipmapInfo *, int, Texture2D::PixelFormat, int, int)`
- 新增 `initWithMipmaps(cocos2d::MipmapInfo *, int, backend::PixelFormat, backend::PixelFormat, int, int)`
- 移除 `releaseGLTexture()`
- 新增 `isRenderTarget()`
- 移除 `setGLProgram(cocos2d::GLProgram *)`
- 新增 `setRenderTarget(bool)`
- 移除 `stringForFormat()`, 使用 `getStringForFormat` 替代.

### 类 `cocos2d::TextureAtlas`

- 移除 `drawNumberOfQuads`
- 移除 `drawQuads`
- 新增 getIndices
- 移除 `listenRendererRecreated`

### 类 `cocos2d::TextureCache`

- 移除 `destroyInstance`
- 移除 `getInstance`
- 移除 `purgeSharedTextureCache`
- 移除 `reloadAllTextures`
- 移除 `sharedTextureCache`
- 移除 `addUIImage`
- 移除 `textureForKey`


### 类 `cocos2d::TextureCube`

- 新增 `getBackendTexture`

### 类 `cocos2d::TiledGrid3D`

- 移除 `originalTile`, 使用 `getOriginalTile` 替代.
- 移除 `tile`, 使用 `getTile` 替代.

### 类 `cocos2d::TileMapAtlas`

- 移除 `tileAt`, 使用 `getTileAt` 替代.

### 类 `cocos2d::TMXLayer`

- 移除 `positionAt`, 使用 `getPositionAt` 替代.
- 移除 `propertyNamed`, 使用 `getProperty` 替代.
- 移除 `tileAt`, 使用 `getTileAt` 替代.
- 移除 `tileGIDAt`, 使用 `getTileGIDAt` 替代.


### 类 `cocos2d::TMXMapInfo`

- 移除 `formatWithTMXFile`
- 移除 `formatWithXML`
- 移除 `getStoringCharacters`

### 类 `cocos2d::TMXObjectGroup`

- 移除 `objectNamed`, 使用 `getObject` 替代.
- 移除 `propertyNamed`, 使用 `getProperty` 替代.

### 类 `cocos2d::TMXTiledMap`

- 移除 `layerNamed`, 使用 `getLayer` 替代.
- 移除 `objectGroupNamed`, 使用 `getObjectGroup` 替代.
- 移除 `propertiesForGID`, 使用 `getPropertiesForGID` 替代.
- 移除 `propertyNamed`, 使用 `getProperty` 替代.

### 移除 类 `cocos2d::UniformValue`

### 类 `cocos2d::UserDefault`

- 移除 `purgeSharedUserDefault`, 使用 `destroyInstance` 替代.
- 移除 `sharedUserDefault`, 使用 `getInstance` 替代.

### 类 `cocos2d::ZipUtils`

- 移除 `ccInflateCCZBuffer`, 使用 `inflateCCZBuffer` 替代.
- 移除 `ccInflateCCZFile`, 使用 `inflateCCZFile` 替代.
- 移除 `ccInflateGZipFile`, 使用 `inflateGZipFile` 替代.
- 移除 `ccInflateMemory`, 使用 `inflateMemory` 替代.
- 移除 `ccInflateMemoryWithHint`, 使用 `inflateMemoryWithHint` 替代.
- 移除 `ccIsCCZBuffer`, 使用 `isCCZBuffer` 替代.
- 移除 `ccIsCCZFile`, 使用 `isCCZFile` 替代.
- 移除 `ccIsGZipBuffer`, 使用 `isGZipBuffer` 替代.
- 移除 `ccIsGZipFile`, 使用 `isGZipFile` 替代.
- 移除 `ccSetPvrEncryptionKey`, 使用 `setPvrEncryptionKey` 替代.
- 移除 `ccSetPvrEncryptionKeyPart`, 使用 `setPvrEncryptionKeyPart` 替代.