# V4 API Changes

The following is a list of major (incomplete) interface changes.

### `Remove experimental namesapce`

API change because of removing `experimental` namespace:

__CPP__

* `cocos2d::experimental::AudioEngine` -> `cocos2d::AudioEngine`
* `cocos2d::experimental::ui::WebView` -> `cocos2d::ui::WebView`
* `cocos2d::experimental::ui::VideoPlayer` -> `cocos2d::ui::WebView`
* `cocos2d::experimental::TMXLayer` -> `cocos2d::FastTMXLayer`
* `cocos2d::experimental::TMXTileMap` -> `cocos2d::FastTMXTileMap`

__Lua__

* `ccexp:AudieoEngine` -> `cc:AudieoEngine`
* `ccexp:WebView` -> `ccui:WebView`
* `ccexp:VideoPlayer` -> `ccui:VideoPlayer`
* `ccexp:TMXTileMap` -> `cc:FastTMXTileMap`
* `ccexp:TMXLayer` -> `cc:FastTMXLayer`

### `cocos2d::ActionManager`

- Remove ~~`numberOfRunningActionsInTarge`~~, use `getNumberOfRunningActionsInTarget` instead.

### `cocos2d::Animate3D`

- Remove ~~`getPlayBack`~~
- Remove ~~`setPlayBack`~~

### `cocos2d::Animation`

- Rename `addSpriteFrameWithFileName` to `addSpriteFrameWithFile`.

### `cocos2d::Animation3D`

- Remove ~~`getOrCreate`~~, use `create` instead.

### `cocos2d::AnimationCache`

- Remove ~~`purgeSharedAnimationCache`~~, use `destroyInstance` instead.
- Remove ~~`sharedAnimationCache`~~, use `getInstance` instead.
- Remove ~~`animationByName`~~, use `getAnimation` instead.
- Remove ~~`removeAnimationByName`~~, use `removeAnimation` instead.

### `cocos2d::AsyncTaskPool`

- Spell fix `destoryInstance` to `destroyInstance`

### Replace GLProgram & GLProgramState as Program & ProgramState

### Remove class `cocos2d::BatchCommand`

### New class `cocos2d::CallbackCommand`

### `cocos2d::CallFunc`

- Remove ~~`create(cocos2d::Ref *, cocos2d::SEL_CallFunc)`~~
- Remove ~~`initWithTarget`~~, use `initWithFunction` instead
- Remove ~~`setTargetCallback`~~

### `cocos2d::CallFuncN`

- Remove ~~`create(cocos2d::Ref *, cocos2d::SEL_CallFuncN)`~~
- Remove ~~`initWithTarget`~~

### `cocos2d::Camera` Refactoring
- Remove ~~`applyFrameBufferObject`~~
- Remove ~~`restore`~~
- Remove ~~`restoreFrameBufferObject`~~
- Remove ~~`restoreViewport`~~
- Remove ~~`setFrameBufferObject`~~
- Remove ~~`setViewport`~~, accessed via `Renderer`

### 新类 class `cocos2d::CaptureScreenCallbackCommand`

### `cocos2d::Clonable`

- Remove ~~`copy`~~

### `cocos2d::Configuration`

- Remove ~~`purgeConfiguration`~~, use `getInstance` instead.
- Remove ~~`sharedConfiguration`~~, use `destroyInstance` instead.
- Added `getMaxAttributes`


### `cocos2d::RenderCommand` Refactoring
### `cocos2d::TriangleCommand` Refactoring
### `cocos2d::CustomCommand` Refactoring
### `cocos2d::MeshCommand` Refactoring

### `cocos2d::Director`

- Remove ~~`sharedDirector`~~, use `getInstance` instead.
- Remove ~~`getClearColor`~~
- Remove ~~`getProjectionMatrix`~~, accessed via `Camera`
- Remove ~~`getProjectionMatrixStackSize`~~
- Remove ~~`initProjectionMatrixStack`~~
- Remove ~~`loadProjectionIdentityMatrix`~~
- Remove ~~`loadProjectionMatrix`~~
- Remove ~~`multiplyProjectionMatrix`~~
- Remove ~~`popProjectionMatrix`~~
- Remove ~~`pushProjectionMatrix`~~
- Remove ~~`setAlphaBlending`~~, accessed via `Renderer`
- Remove ~~`setDepthTest`~~, accessed via `Renderer`

### `cocos2d::DrawNode`

- Remove ~~`drawQuadraticBezier`~~

### Remove class `cocos2d::experimental::FrameBuffer`
### Remove class `cocos2d::experimental::RenderTargetBase`
### Remove class `cocos2d::experimental::RenderTargetDepthStencil`
### Remove class `cocos2d::experimental::RenderTargetRenderBuffer`

### `cocos2d::FileUtils`

- Remove ~~`purgeFileUtils`~~, use `destroyInstance` instead.
- Remove ~~`sharedFileUtils`~~, use `getInstance` instead.
- Remove ~~`getFileData`~~, use `getDataFromFile` instead.

### `cocos2d::Follow`

- Spell fix `setBoudarySet` to `setBoundarySet`

### `cocos2d::Font`

- Remove ~~`getHorizontalKerningForTextUTF16`~~

### `cocos2d::GLView`

- Remove ~~`getVR`~~
- Remove ~~`pollInputEvents`~~
- Remove ~~`setCursor`~~
- Remove ~~`setDefaultCursor`~~
- Remove ~~`setVR`~~

### `cocos2d::Grid3D`

- Remove ~~`originalVertex`~~, use `getOriginalVertex` instead.
- Remove ~~`vertex`~~, use `getVertex` instead.

### `cocos2d::GridBase`

- Remove ~~`create(const cocos2d::Size &, cocos2d::Texture2D *, bool)`~~
- Remove ~~`create(const cocos2d::Size &)`~~

### `cocos2d::Image`

- Rename `getRenderFormat` to `getPixelFormat`.
- Remove ~~`isPremultipliedAlpha`~~, use `hasPremultipliedAlpha` instead.
- Rename `premultiplyAlpha` to `premultipliedAlpha`.
- Remove ~~`reversePremultipliedAlpha`~~

### `cocos2d::IMEDispatcher`

- Remove ~~`isAnyDelegateAttachedWithIME`~~

### Remove class `cocos2d::IndexBuffer`

### `cocos2d::Label`

- Remove ~~`create(const std::string &, const std::string &, float, const cocos2d::Size &, cocos2d::TextHAlignment, cocos2d::TextVAlignment)`~~
- Remove ~~`getCommonLineHeight`~~, use `getLineHeight` instead.
- Remove ~~`getFontDefinition`~~.
- Remove ~~`setFontDefinition`~~.
- Added `setProgramState`

### `cocos2d::Layer`

- Remove ~~`ccTouchBegan`~~, use `onTouchBegan` instead.
- Remove ~~`ccTouchCancelled`~~, use `onTouchCancelled` instead.
- Remove ~~`ccTouchEnded`~~, use `onTouchEnded` instead.
- Remove ~~`ccTouchesBegan`~~, use `onTouchesBegan` instead.
- Remove ~~`ccTouchesCancelled`~~, use `onTouchesCancelled` instead.
- Remove ~~`ccTouchesEnded`~~, use `onTouchesEnded` instead.
- Remove ~~`ccTouchesMoved`~~, use `onTouchesMoved` instead.
- Remove ~~`ccTouchMoved`~~, use `onTouchMoved` instead.
- Remove ~~`didAccelerate`~~
- Remove ~~`isAccelerometerEnabled`~~
- Remove ~~`isKeyboardEnabled`~~
- Remove ~~`isKeypadEnabled`~~
- Remove ~~`isSwallowsTouches`~~
- Remove ~~`isTouchEnabled`~~
- Remove ~~`keyBackClicked`~~, use `onKeyReleased` instead.
- Remove ~~`keyMenuClicked`~~, use `onKeyReleased` instead.
- Remove ~~`keyPressed`~~, use `onKeyPressed` instead.
- Remove ~~`keyReleased`~~, use `onKeyReleased` instead.
- Remove ~~`registerWithTouchDispatcher`~~
- Remove ~~`setAccelerometerEnabled`~~
- Remove ~~`setAccelerometerInterval`~~
- Remove ~~`setKeyboardEnabled`~~
- Remove ~~`setKeypadEnabled`~~
- Remove ~~`setSwallowsTouches`~~
- Remove ~~`setTouchEnabled`~~
- Remove ~~`setTouchMode`~~

### Remove class `cocos2d::LabelBMFont`

### Remove class `cocos2d::LabelTTF`

### `cocos2d::Material`

- Rename `createWithGLStateProgram` to `createWithProgramState`.
- Added `createWithProgramState`
- Added `getRenderState`
- Added `getStateBlock`
- Added `setStateBlock`


### `cocos2d::MenuItem`

- Remove ~~`create(cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`initWithTarget`~~

### `cocos2d::MenuItemAtlasFont`

- Remove ~~`create(const std::string &, const std::string &, int, int, char, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`initWithString`~~

### `cocos2d::MenuItemFont`

- Remove ~~`create(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`fontName`~~, use `getFontName` instead.
- Remove ~~`fontSize`~~, use `getFontSize` instead.
- Remove ~~`fontNameObj`~~, use `getFontNameObj` instead.
- Remove ~~`fontSizeObj`~~, use `getFontSizeObj` instead.
- Remove ~~`initWithString(const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~

### `cocos2d::MenuItemImage`

- Remove ~~`create(const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`create(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`initWithNormalImage(const std::string &, const std::string &, const std::string &, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~

### `cocos2d::MenuItemLabel`

- Remove ~~`create(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`initWithLabel(cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~

### `cocos2d::MenuItemSprite`

- Remove ~~`create(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`create(cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~
- Remove ~~`initWithNormalSprite(cocos2d::Node *, cocos2d::Node *, cocos2d::Node *, cocos2d::Ref *, cocos2d::SEL_MenuHandler)`~~

### `cocos2d::MenuItemToggle`

- Remove ~~`createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, ..)`~~
- Remove ~~`createWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, const Vector<cocos2d::MenuItem *> &)`~~
- Remove ~~`initWithTarget(cocos2d::Ref *, cocos2d::SEL_MenuHandler, cocos2d::MenuItem *, __va_list_tag *)`~~
- Remove ~~`selectedItem()`~~, use `getSelectedItem` instead.

### `cocos2d::Mesh`

- Remove ~~`create(const std::vector<float> &, int, const cocos2d::Mesh::IndexArray &, int, const std::vector<MeshVertexAttrib> &, int)`~~
- Rename `getGLProgramState` to `getProgramState`.
- Rename `setGLProgramState` to `setProgramState`.
- Remove ~~`getMeshCommand`~~
- Added `setVertexLayout`

### `cocos2d::Node`

- Remove ~~`boundingBox`~~, use `getBoundingBox` instead.
- Remove ~~`getGLProgram`~~
- Rename ~~`getGLProgramState` to `getProgramState`.
- Remove ~~`getGLServerState`~~
- Remove ~~`getRotationX`~~, use `getRotationSkewX` instead
- Remove ~~`getRotationY`~~, use `getRotationSkewY` instead
- Remove ~~`getShaderProgram`~~
- Remove ~~`getVertexZ`~~, use `getPositionZ` instead
- Remove ~~`getZOrder`~~, use `getLocalZOrder` instead
- Remove ~~`ignoreAnchorPointForPosition`~~, using `isIgnoreAnchorPointForPosition`
- Remove ~~`nodeToParentTransform`~~, use `getNodeToParentTransform` instead
- Remove ~~`nodeToWorldTransform`~~, use `getNodeToWorldTransform` instead
- Remove ~~`numberOfRunningActions`~~, use `getNumberOfRunningActions` instead
- Remove ~~`parentToNodeTransform`~~, use `getParentToNodeTransform` instead
- Remove ~~`pauseSchedulerAndActions`~~
- Rename ~~`setGLProgramState` to `setProgramState`.
- Remove ~~`setGLProgram`~~
- Remove ~~`setGLServerState`~~
- Remove ~~`setRotationX`~~, use `setRotationSkewX` instead
- Remove ~~`setRotationY`~~, use `setRotationSkewY` instead
- Remove ~~`setShaderProgram`~~
- Remove ~~`setVertexZ`~~, use `setPositionZ` instead
- Remove ~~`setZOrder`~~, use `setLocalZOrder` instead
- Remove ~~`unscheduleAllSelectors`~~
- Remove ~~`worldToNodeTransform`~~, using `getWorldToNodeTransform`

### `cocos2d::ParticleSystem`

- Remove ~~`getOpacityModifyRGB`~~

### `cocos2d::ParticleSystemQuad`

- Remove ~~`postStep`~~

### `cocos2d::Pass` Refactoring

### `cocos2d::PhysicsShape`

- Spell fix `getPolyonCenter` for `getPolygonCenter`
- Spell fix `getTriaglesCount` for `getTrianglesCount`

### `cocos2d::PoolManager`

- Remove ~~`purgePoolManager`~~, use `destroyInstance` instead.
- Remove ~~`sharedPoolManager`~~, use `getInstance` instead.

### Remove class `cocos2d::PrimitiveCommand`

### `cocos2d::Profiler`

- Remove ~~`sharedProfiler`~~, use `getInstance` instead.

### `cocos2d::ProgressTimer`

- Remove ~~`setReverseProgress`~~, use `setReverseDirection` instead.

### Reimplementing cocos2d::Renderer

- Remove ~~`clear`~~
- Added `clear(cocos2d::ClearFlag, const cocos2d::Color4F &, float, unsigned int, float)`
- Added `getClearDepth`
- Added `getClearFlag`
- Added `getClearStencil`
- Added `getColorAttachment`
- Added `getCullMode`
- Added `getDepthAttachment`
- Added `getDepthCompareFunction`
- Added `getDepthTest`
- Added `getDepthWrite`
- Remove ~~`getGroupCommandManager`~~
- Remove ~~`initGLView`~~
- Added `getRenderTargetFlag`
- Added `getScissorRect`
- Added `getScissorTest`
- Added `getStencilAttachment`
- Added `getStencilCompareFunction`
- Added `getStencilDepthPassOperation`
- Added `getStencilFailureOperation`
- Added `getStencilPassDepthFailureOperation`
- Added `getStencilReadMask`
- Added `getStencilReferenceValue`
- Added `getStencilTest`
- Added `getStencilWriteMask`
- Added `getViewport`
- Added `getWinding`
- Added `init`
- Remove ~~`setClearColor`~~
- Added `setCullMode`
- Added `setDepthCompareFunction`
- Added `setDepthWrite`
- Added `setRenderTarget`
- Added `setScissorRect`
- Added `setScissorTest`
- Added `setStencilCompareFunction`
- Added `setStencilOperation`
- Added `setStencilTest`
- Added `setStencilWriteMask`
- Added `setViewPort`
- Added `setWinding`

### `cocos2d::RenderTexture`

- Remove ~~`newCCImage`~~
- Remove ~~`newImage(bool)`~~, use `newImage(std::function<void (Image *)>, bool)` instead

### `cocos2d::Scene`

- Remove ~~`onEnter`~~

### `cocos2d::Scheduler`

- Remove ~~`isScheduledForTarget`~~
- Remove ~~`scheduleSelector`~~
- Remove ~~`unscheduleSelector`~~
- Remove ~~`unscheduleUpdateForTarget`~~

### `cocos2d::ScriptEngineManager`

- Remove ~~`purgeSharedManager`~~, use `destroyInstance` instead.
- Remove ~~`sharedManager`~~, use `getInstance` instead.

### `cocos2d::Sprite`

- Remove ~~`displayFrame`~~, use `getSpriteFrame` instead
- Remove ~~`getDisplayFrame`~~, use `getSpriteFrame` instead
- Added `getProgramState`
- Spell fix `setStrechEnabled` to `setStretchEnabled`
- Added `setVertexLayout`
- Added `updateShaders`

### `cocos2d::Sprite3D`

- Remove ~~`getSkin`~~
- Added `setVertexLayout`
- Remove ~~`setGLProgramState`~~, use `setProgramState` instead
- Remove ~~`setGLProgram`~~

### `cocos2d::Sprite3DMaterial`

- Rename `createWithGLStateProgram` to `createWithProgramState`.

### `cocos2d::SpriteFrameCache`

- Remove ~~`purgeSharedSpriteFrameCache`~~, use `destroyInstance` instead.
- Remove ~~`sharedSpriteFrameCache`~~, use `getInstance` instead.
- Remove ~~`spriteFrameByName`~~, use `getSpriteFrameByName` instead.

### `cocos2d::Technique`

- Rename `createWithGLProgramState` to `createWithProgramState`.
- Added `getStateBlock`
- Added `setMaterial`

### `cocos2d::Texture2D` Refactoring

- Remove ~~`defaultAlphaPixelFormat`~~ Use `getDefaultAlphaPixelFormat` instead.
- Remove ~~`bitsPerPixelForFormat()`~~, use `getBitsPerPixelForFormat` instead.
- Signature change `drawAtPoint(const cocos2d::Vec2 &, float)`
- Signature change `drawInRect(const cocos2d::Rect &, float)`
- Added `getBackendTexture()`
- Remove ~~`getDescription()`~~
- Remove ~~`getGLProgram()`~~
- Remove ~~`getName()`~~
- Remove ~~`initWithData(const void *, ssize_t, Texture2D::PixelFormat, int, int, const cocos2d::Size &)`~~
- Remove ~~`initWithImage(cocos2d::Image *, cocos2d::Texture2D::PixelFormat)`~~
- Added `initWithBackendTexture(backend::TextureBackend *)`
- Added `initWithData(const void *, ssize_t, backend::PixelFormat, backend::PixelFormat, int, int, const cocos2d::Size &)`
- Added `initWithData(const void *, ssize_t, backend::PixelFormat, int, int, const cocos2d::Size &)`
- Added `initWithImage(cocos2d::Image *, backend::PixelFormat)`
- Remove ~~`initWithMipmaps(cocos2d::MipmapInfo *, int, Texture2D::PixelFormat, int, int)`~~
- Added `initWithMipmaps(cocos2d::MipmapInfo *, int, backend::PixelFormat, backend::PixelFormat, int, int)`
- Remove ~~`releaseGLTexture()`~~
- Added `isRenderTarget()`
- Remove ~~`setGLProgram(cocos2d::GLProgram *)`~~
- Added `setRenderTarget(bool)`
- Remove ~~`stringForFormat()`~~, use `getStringForFormat` instead.

### `cocos2d::TextureAtlas`

- Remove ~~`drawNumberOfQuads`~~
- Remove ~~`drawQuads`~~
- Added `getIndices`
- Remove ~~`listenRendererRecreated`~~

### `cocos2d::TextureCache`

- Remove ~~`destroyInstance`~~, accessed via `Director`.
- Remove ~~`getInstance`~~, accessed via `Director`.
- Remove ~~`purgeSharedTextureCache`~~
- Remove ~~`reloadAllTextures`~~
- Remove ~~`sharedTextureCache`~~
- Remove ~~`addUIImage`~~, use `addImage` instead.
- Remove ~~`textureForKey`~~, use `getTextureForKey` instead.


### `cocos2d::TextureCube`

- Added `getBackendTexture`

### `cocos2d::TiledGrid3D`

- Remove ~~`originalTile`~~, use `getOriginalTile` instead.
- Remove ~~`tile`~~, use `getTile` instead.

### `cocos2d::TileMapAtlas`

- Remove ~~`tileAt`~~, use `getTileAt` instead.

### `cocos2d::TMXLayer`

- Remove ~~`positionAt`~~, use `getPositionAt` instead.
- Remove ~~`propertyNamed`~~, use `getProperty` instead.
- Remove ~~`tileAt`~~, use `getTileAt` instead.
- Remove ~~`tileGIDAt`~~, use `getTileGIDAt` instead.


### `cocos2d::TMXMapInfo`

- Remove ~~`formatWithTMXFile`~~, use `create` instead.
- Remove ~~`formatWithXML`~~, use `createWithXML` instead.
- Remove ~~`getStoringCharacters`~~, use `isStoringCharacters` instead.

### `cocos2d::TMXObjectGroup`

- Remove ~~`objectNamed`~~, use `getObject` instead.
- Remove ~~`propertyNamed`~~, use `getProperty` instead.

### `cocos2d::TMXTiledMap`

- Remove ~~`layerNamed`~~, use `getLayer` instead.
- Remove ~~`objectGroupNamed`~~, use `getObjectGroup` instead.
- Remove ~~`propertiesForGID`~~, use `getPropertiesForGID` instead.
- Remove ~~`propertyNamed`~~, use `getProperty` instead.

### Remove class `cocos2d::UniformValue`

### `cocos2d::UserDefault`

- Remove ~~`purgeSharedUserDefault`~~, use `destroyInstance` instead.
- Remove ~~`sharedUserDefault`~~, use `getInstance` instead.

### `cocos2d::ZipUtils`

- Remove ~~`ccInflateCCZBuffer`~~, use `inflateCCZBuffer` instead.
- Remove ~~`ccInflateCCZFile`~~, use `inflateCCZFile` instead.
- Remove ~~`ccInflateGZipFile`~~, use `inflateGZipFile` instead.
- Remove ~~`ccInflateMemory`~~, use `inflateMemory` instead.
- Remove ~~`ccInflateMemoryWithHint`~~, use `inflateMemoryWithHint` instead.
- Remove ~~`ccIsCCZBuffer`~~, use `isCCZBuffer` instead.
- Remove ~~`ccIsCCZFile`~~, use `isCCZFile` instead.
- Remove ~~`ccIsGZipBuffer`~~, use `isGZipBuffer` instead.
- Remove ~~`ccIsGZipFile`~~, use `isGZipFile` instead.
- Remove ~~`ccSetPvrEncryptionKey`~~, use `setPvrEncryptionKey` instead.
- Remove ~~`ccSetPvrEncryptionKeyPart`~~, use `setPvrEncryptionKeyPart` instead.