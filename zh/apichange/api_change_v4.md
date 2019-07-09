# V3 到 V4 API 变更

### class `cocos2d::ActionManager`

- REMOVE: `numberOfRunningActionsInTarge`, use `getNumberOfRunningActionsInTarget`instead. 

### class `cocos2d::Animate3D`

- REMOVE: `getPlayBack`
- REMOVE: `setPlayBack`

### class `cocos2d::Animation`

- RENAME: `addSpriteFrameWithFileName` TO  `addSpriteFrameWithFile`

### class `cocos2d::Animation3D`

- REMOVE: `getOrCreate`, use `create` instead.

### class `cocos2d::AnimationCache`

- REMOVE: `purgeSharedAnimationCache`, use `destroyInstance` instead.
- REMOVE: `sharedAnimationCache`, use `getInstance` instead.
- REMOVE: `animationByName`, use `getAnimation` instead.
- REMOVE: `removeAnimationByName`, use `removeAnimation` instead.

### class `cocos2d::AsyncTaskPool`

- FIX TYPO: `destoryInstance` TO `destroyInstance`

### NEW class `cocos2d::backend::Program`

### REPLACE GLProgram & GLProgramState with Program & ProgramState

### REMOVE class `cocos2d::BatchCommand`

### NEW class `cocos2d::CallbackCommand`

### class `cocos2d::CallFunc`

- REMOVE: `create(cocos2d::Ref *, cocos2d::SEL_CallFunc)`
- REMOVE: `initWithTarget`
- REMOVE: `setTargetCallback`

### class `cocos2d::CallFuncN`

- REMOVE: `create(cocos2d::Ref *, cocos2d::SEL_CallFuncN)`
- REMOVE: `initWithTarget`

### class `cocos2d::Camera`
- REMOVE: `applyFrameBufferObject`
- REMOVE: `restore`
- REMOVE: `applyFrameBufferObject`
- REMOVE: `restoreFrameBufferObject`
- REMOVE: `restoreViewport`
- REMOVE: `setFrameBufferObject`
- REMOVE: `setViewport`

### NEW class `cocos2d::CaptureScreenCallbackCommand`

### class `cocos2d::Clonable`

- REMOVE: `copy`

### class `cocos2d::Configuration`

- REMOVE: `purgeConfiguration`
- REMOVE: `sharedConfiguration`
- REMOVE: `getInfoAsMap`
- NEW: `getMaxAttributes`


### class `cocos2d::CustomCommand` reform

### class `cocos2d::Director`

- REMOVE: `sharedDirector`, use `getInstance` instead.
- REMOVE: `getClearColor`
- REMOVE: `getProjectionMatrix`, access through `Camera`
- REMOVE: `getProjectionMatrixStackSize`
- REMOVE: `initProjectionMatrixStack`
- REMOVE: `loadProjectionIdentityMatrix`
- REMOVE: `loadProjectionMatrix`
- REMOVE: `multiplyProjectionMatrix`
- REMOVE: `popProjectionMatrix`
- REMOVE: `pushProjectionMatrix`
- REMOVE: `setAlphaBlending`, access though `Renderer`
- REMOVE: `setDepthTest`, access though `Renderer`

### class `cocos2d::DrawNode`

- REMOVE: `drawQuadraticBezier`

### REMOVE: class `cocos2d::experimental::FrameBuffer`
### REMOVE: class `cocos2d::experimental::RenderTargetBase`
### REMOVE: class `cocos2d::experimental::RenderTargetDepthStencil`
### REMOVE: class `cocos2d::experimental::RenderTargetRenderBuffer`

### class `cocos2d::FileUtils`

- REMOVE: `purgeFileUtils`, use `destroyInstance` instead.
- REMOVE: `sharedFileUtils`, use `getInstance` instead.
- REMOVE: `getFileData`, use `getDataFromFile` instead.

### class `cocos2d::Follow`

- FIX TYPO: `setBoudarySet` to `setBoundarySet`

### class `cocos2d::Font`

- REMOVE: `getHorizontalKerningForTextUTF16`

### class `cocos2d::GLView`

- REMOVE: `getVR`
- REMOVE: `pollInputEvents`
- REMOVE: `setCursor`
- REMOVE: `setDefaultCursor`
- REMOVE: `setVR`

### class `cocos2d::Grid3D`

- REMOVE: `originalVertex`, use `getOriginalVertex` instead
- REMOVE: `vertex`, use `getVertex` instead

### class `cocos2d::GridBase`

- REMOVE: `create(const cocos2d::Size &, cocos2d::Texture2D *, bool)`
- REMOVE: `create(const cocos2d::Size &)`

### class `cocos2d::Image`

- RENAME: `getRenderFormat` to `getPixelFormat`
- REMOVE: `isPremultipliedAlpha`, use `hasPremultipliedAlpha` instead.
- RENAME: `premultiplyAlpha` to `premultipliedAlpha`
- REMOVE: `reversePremultipliedAlpha`

### class `cocos2d::IMEDispatcher`

- REMOVE: `isAnyDelegateAttachedWithIME`

### REMOVE: class `cocos2d::IndexBuffer`

### class `cocos2d::Label`

- REMOVE: `getCommonLineHeight`
- REMOVE: `getFontDefinition`
- REMOVE: `setFontDefinition`
- NEW: `setProgramState`

### class `cocos2d::Layer`

- REMOVE: `ccTouchBegan`, use `onTouchBegan` instead.
- REMOVE: `ccTouchCancelled`, use `onTouchCancelled` instead.
- REMOVE: `ccTouchEnded`, use `onTouchEnded` instead.
- REMOVE: `ccTouchesBegan`, use `onTouchesBegan` instead.
- REMOVE: `ccTouchesCancelled`, use `onTouchesCancelled` instead.
- REMOVE: `ccTouchesEnded`, use `onTouchesEnded` instead.
- REMOVE: `ccTouchesMoved`, use `onTouchesMoved` instead.
- REMOVE: `ccTouchMoved`, use `onTouchMoved` instead.
- REMOVE: `didAccelerate`
- REMOVE: `isAccelerometerEnabled`
- REMOVE: `isKeyboardEnabled`
- REMOVE: `isKeypadEnabled`
- REMOVE: `isSwallowsTouches`
- REMOVE: `isTouchEnabled`
- REMOVE: `keyBackClicked`
- REMOVE: `keyMenuClicked`
- REMOVE: `keyPressed`
- REMOVE: `keyReleased`
- REMOVE: `registerWithTouchDispatcher`
- REMOVE: `setAccelerometerEnabled`
- REMOVE: `setAccelerometerInterval`
- REMOVE: `setKeyboardEnabled`
- REMOVE: `setKeypadEnabled`
- REMOVE: `setSwallowsTouches`
- REMOVE: `setTouchEnabled`
- REMOVE: `setTouchMode`

### REMOVE: class `cocos2d::LabelBMFont`

### REMOVE: class `cocos2d::LabelTTF`


### class `cocos2d::Material`

- RENAME: `createWithGLStateProgram` to `createWithProgramState`
- NEW: `createWithProgramState`
- NEW: `getRenderState`
- NEW: `getStateBlock`
- NEW: `setStateBlock`


### class `cocos2d::MenuItem`

- REMOVE: `create(cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `initWithTarget`
- REMOVE: `MenuItemAtlasFont`

### class `cocos2d::MenuItemAtlasFont`

- REMOVE: `create(const std::string &, const std::string &, int, int, char, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `initWithString`

### class `cocos2d::MenuItemFont`

- REMOVE: `create(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `fontName`, use `getFontName` instead
- REMOVE: `fontSize`, use `getFontSize` instead
- REMOVE: `fontNameObj`, use `getFontNameObj` instead
- REMOVE: `fontSizeObj`, use `getFontSizeObj` instead
- REMOVE: `initWithString(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### class `cocos2d::MenuItemImage`

- REMOVE: `create(const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `create(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `initWithNormalImage(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### class `cocos2d::MenuItemImage`

- REMOVE: `create(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `initWithLabel(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### class `cocos2d::MenuItemSprite`

- REMOVE: `create(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `create(cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`
- REMOVE: `initWithNormalSprite(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`

### class `cocos2d::MenuItemToggle`

- REMOVE: `createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, ...)`
- REMOVE: `createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, const Vector<cocos2d::MenuItem *> &)`
- REMOVE: `initWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, __va_list_tag *)`
- REMOVE: `selectedItem()`, use `getSelectedItem` instead.

### class `cocos2d::Mesh`

- REMOVE: `create(const std::vector<float> &, int, const cocos2d::Mesh::IndexArray &, int, const std::vector<MeshVertexAttrib> &, int)`
- RENAME: `getGLProgramState` TO `getProgramState` 
- RENAME: `setGLProgramState` TO `setProgramState`
- REMOVE: `getMeshCommand`
- NEW: `setVertexLayout`

### class `cocos2d::Node`

- REMOVE: `boundingBox`, used `getBoundingBox`
- RENAME: `getGLProgram` TO `getProgramState`
- REMOVE: `getGLProgramState`
- REMOVE: `getGLServerState`
- REMOVE: `getRotationX`
- REMOVE: `getRotationY`
- REMOVE: `getShaderProgram`
- REMOVE: `getVertexZ`
- REMOVE: `getZOrder`
- REMOVE: `ignoreAnchorPointForPosition`, use `isIgnoreAnchorPointForPosition`
- REMOVE: `nodeToParentTransform`, use `getNodeToParentTransform`
- REMOVE: `nodeToWorldTransform`, use `getNodeToWorldTransform`
- REMOVE: `numberOfRunningActions`, use `getNumberOfRunningActions`
- REMOVE: `parentToNodeTransform`, use `getParentToNodeTransform`
- REMOVE: `pauseSchedulerAndActions`
- RENAME: `setGLProgram` TO `setProgramState`
- REMOVE: `setGLProgramState`
- REMOVE: `setGLServerState`
- REMOVE: `setRotationX`
- REMOVE: `setRotationY`
- REMOVE: `setShaderProgram`
- REMOVE: `setVertexZ`
- REMOVE: `setZOrder`
- REMOVE: `unscheduleAllSelectors`
- REMOVE: `worldToNodeTransform`, use `getWorldToNodeTransform`

### class `cocos2d::ParticleSystem`

- REMOVE: `getOpacityModifyRGB`

### class `cocos2d::ParticleSystemQuad`

- REMOVE: `postStep`

### CHANGE: rewrite class `cocos2d::Pass`

### class `cocos2d::PhysicsShape`

- FIX TYPO: `getPolyonCenter` TO `getPolygonCenter`
- FIX TYPO: `getTriaglesCount` TO `getTrianglesCount`

### class `cocos2d::PoolManager`

- REMOVE: `purgePoolManager`, use `destroyInstance` instead. 
- REMOVE: `sharedPoolManager`, use `getInstance` instead.

### REMOVE: class `cocos2d::PrimitiveCommand`

### class `cocos2d::Profiler`

- REMOVE: `sharedProfiler`, use `getInstance` instead.

### class `cocos2d::ProgressTimer`

- REMOVE: `setReverseProgress`, use `setReverseDirection` instead.

### CHANGE: REWRITE cocos2d::Renderer

- REMOVE: `clear`
- NEW: `clear(cocos2d::ClearFlag, const cocos2d::Color4F &, float, unsigned int, float)`
- NEW: `getClearDepth`
- NEW: `getClearFlag`
- NEW: `getClearStencil`
- NEW: `getColorAttachment`
- NEW: `getCullMode`
- NEW: `getDepthAttachment`
- NEW: `getDepthCompareFunction`
- NEW: `getDepthTest`
- NEW: `getDepthWrite`
- REMOVE: `getGroupCommandManager`
- REMOVE: `initGLView`
- NEW: `getRenderTargetFlag`
- NEW: `getScissorRect`
- NEW: `getScissorTest`
- NEW: `getStencilAttachment`
- NEW: `getStencilCompareFunction`
- NEW: `getStencilDepthPassOperation`
- NEW: `getStencilFailureOperation`
- NEW: `getStencilPassDepthFailureOperation`
- NEW: `getStencilReadMask`
- NEW: `getStencilReferenceValue`
- NEW: `getStencilTest`
- NEW: `getStencilWriteMask`
- NEW: `getViewport`
- NEW: `getWinding`
- NEW: `init`
- REMOVE: `setClearColor`
- NEW: `setCullMode`
- NEW: `setDepthCompareFunction`
- NEW: `setDepthWrite`
- NEW: `setRenderTarget`
- NEW: `setScissorRect`
- NEW: `setScissorTest`
- NEW: `setStencilCompareFunction`
- NEW: `setStencilOperation`
- NEW: `setStencilTest`
- NEW: `setStencilWriteMask`
- NEW: `setViewPort`
- NEW: `setWinding`

### class `cocos2d::RenderTexture`

- REMOVE: `newCCImage`
- REMOVE: `newImage(bool)`
- NEW: `newImage(std::function<void (Image *)>, bool)`
- REMOVE: `saveToFileAsNonPMA`

### class `cocos2d::Scene`

- REMOVE: `onEnter`

### class `cocos2d::Scheduler`

- REMOVE: `isScheduledForTarget`
- REMOVE: `scheduleSelector`
- REMOVE: `unscheduleSelector`
- REMOVE: `unscheduleUpdateForTarget`

### class `cocos2d::ScriptEngineManager`

- REMOVE: `purgeSharedManager`, use `destroyInstance` instead.
- REMOVE: `sharedManager`, use `getInstance` instead.

### class `cocos2d::Sprite`

- REMOVE: `displayFrame`
- REMOVE: `getDisplayFrame`
- NEW: `getProgramState`
- FIX TYPO: `setStrechEnabled` TO `setStretchEnabled`
- NEW: `setVertexLayout`
- NEW: `updateShaders`

### class `cocos2d::Sprite3D`

- REMOVE: `getSkin`
- NEW: `setProgramState`
- NEW: `setVertexLayout`
- REMOVE: `setGLProgramState` 
- REMOVE: `setGLProgram` 

### class `cocos2d::Sprite3DMaterial`

- RENAME: `createWithGLStateProgram` TO `createWithProgramState`

### class `cocos2d::SpriteFrameCache`

- REMOVE: `purgeSharedSpriteFrameCache`, use `destroyInstance` instead
- REMOVE: `sharedSpriteFrameCache`, use `getInstance` instead
- REMOVE: `spriteFrameByName`, use `getSpriteFrameByName` instead

### class `cocos2d::Technique`

- RENAME: `createWithGLProgramState` TO `createWithProgramState`
- NEW: `getStateBlock`
- NEW: `setMaterial`

### class `cocos2d::Texture2D`

- RENAME: `defaultAlphaPixelFormat()` TO `getDefaultAlphaPixelFormat`
- REMOVE: `bitsPerPixelForFormat()`, use `getBitsPerPixelForFormat` instead.
- CHANGE: `drawAtPoint(const cocos2d::Vec2 &, float)`
- CHANGE: `drawInRect(const cocos2d::Rect &, float)`
- NEW: `getBackendTexture()`
- REMOVE: `getDescription()`
- REMOVE: `getGLProgram()`
- REMOVE: `getName()`
- REMOVE: `initWithData(const void *, ssize_t, Texture2D::PixelFormat, int, int, const cocos2d::Size &)`
- REMOVE: `initWithImage(cocos2d::Image *, cocos2d::Texture2D::PixelFormat)`
- NEW: `initWithBackendTexture(backend::TextureBackend *)`
- NEW: `initWithData(const void *, ssize_t, backend::PixelFormat, backend::PixelFormat, int, int, const cocos2d::Size &)`
- NEW: `initWithData(const void *, ssize_t, backend::PixelFormat, int, int, const cocos2d::Size &)`
- NEW: `initWithImage(cocos2d::Image *, backend::PixelFormat)`
- REMOVE: `initWithMipmaps(cocos2d::MipmapInfo *, int, Texture2D::PixelFormat, int, int)`
- NEW: `initWithMipmaps(cocos2d::MipmapInfo *, int, backend::PixelFormat, backend::PixelFormat, int, int)`
- REMOVE: `releaseGLTexture()`
- NEW: `isRenderTarget()`
- REMOVE: `setGLProgram(cocos2d::GLProgram *)`
- NEW: `setRenderTarget(bool)`
- REMOVE: `stringForFormat()`, use `getStringForFormat` instead.

### class `cocos2d::TextureAtlas`

- REMOVE: `drawNumberOfQuads`
- REMOVE: `drawQuads`
- NEW: getIndices
- REMOVE: `listenRendererRecreated`

### class `cocos2d::TextureCache`

- REMOVE: `destroyInstance`
- REMOVE: `getInstance`
- REMOVE: `purgeSharedTextureCache`
- REMOVE: `reloadAllTextures`
- REMOVE: `sharedTextureCache`
- REMOVE: `addUIImage`
- REMOVE: `textureForKey`


### class `cocos2d::TextureCube`

- NEW: `getBackendTexture`

### class `cocos2d::TiledGrid3D`

- REMOVE: `originalTile`, use `getOriginalTile` instead.
- REMOVE: `tile`, use `getTile` instead.

### class `cocos2d::TileMapAtlas`

- REMOVE: `tileAt`, use `getTileAt` instead.

### class `cocos2d::TMXLayer`

- REMOVE: `positionAt`, use `getPositionAt` instead.
- REMOVE: `propertyNamed`, use `getProperty` instead.
- REMOVE: `tileAt`, use `getTileAt` instead.
- REMOVE: `tileGIDAt`, use `getTileGIDAt` instead.


### class `cocos2d::TMXMapInfo`

- REMOVE: `formatWithTMXFile`
- REMOVE: `formatWithXML`
- REMOVE: `getStoringCharacters`

### class `cocos2d::TMXObjectGroup`

- REMOVE: `objectNamed`, use `getObject` instead.
- REMOVE: `propertyNamed`, use `getProperty` instead.

### class `cocos2d::TMXTiledMap`

- REMOVE: `layerNamed`, use `getLayer` instead.
- REMOVE: `objectGroupNamed`, use `getObjectGroup` instead.
- REMOVE: `propertiesForGID`, use `getPropertiesForGID` instead.
- REMOVE: `propertyNamed`, use `getProperty` instead.

### REMOVE: class `cocos2d::UniformValue`

### class `cocos2d::UserDefault`

- REMOVE: `purgeSharedUserDefault`, use `destroyInstance` instead.
- REMOVE: `sharedUserDefault`, use `getInstance` instead.

### class `cocos2d::ZipUtils`

- REMOVE: `ccInflateCCZBuffer`, use `inflateCCZBuffer` instead.
- REMOVE: `ccInflateCCZFile`, use `inflateCCZFile` instead.
- REMOVE: `ccInflateGZipFile`, use `inflateGZipFile` instead.
- REMOVE: `ccInflateMemory`, use `inflateMemory` instead.
- REMOVE: `ccInflateMemoryWithHint`, use `inflateMemoryWithHint` instead.
- REMOVE: `ccIsCCZBuffer`, use `isCCZBuffer` instead.
- REMOVE: `ccIsCCZFile`, use `isCCZFile` instead.
- REMOVE: `ccIsGZipBuffer`, use `isGZipBuffer` instead.
- REMOVE: `ccIsGZipFile`, use `isGZipFile` instead.
- REMOVE: `ccSetPvrEncryptionKey`, use `setPvrEncryptionKey` instead.
- REMOVE: `ccSetPvrEncryptionKeyPart`, use `setPvrEncryptionKeyPart` instead.