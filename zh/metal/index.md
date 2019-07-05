# Overview

在 WWDC 2014 上，Apple 为游戏开发者推出了新的图形技术 [Metal](https://developer.apple.com/documentation/metal?language=objc)。Metal 是一种用 C++ 编写的 low-level API。 它代表了 Apple 最新的图形 API 设计。与 OpenGL 不同的是，Metal 不像 OpenGL 那样是跨平台的，它是根据 Apple 最新硬件架构专门设计的 API，因此它能够为 3D 图形提高最多10倍的渲染性能。由于 Apple 声称将弃用 OpenGL，为此 V4 对 Renderer 做了适配，对于 Apple 平台，使用 Metal api 进行渲染，否则，沿用原 OpenGL ES api 渲染。

# 改动点

## Director

1. 移除了以下接口

   ```c++
   CC_DEPRECATED_ATTRIBUTE static Director* sharedDirector();
   void setAlphaBlending(bool on);
   void setDepthTest(bool on);
   void pushProjectionMatrix(size_t index);
   void popProjectionMatrix(size_t index);
   void loadProjectionIdentityMatrix(size_t index);
   void loadProjectionMatrix(const Mat4& mat, size_t index);
   void multiplyProjectionMatrix(const Mat4& mat, size_t index);
   const Mat4& getProjectionMatrix(size_t index) const;
   void initProjectionMatrixStack(size_t stackCount);
   size_t getProjectionMatrixStackSize();
   ```

2. 移除了 `void setDepthTest(bool on)` 接口，通过 `Director::getInstance()->getRenderer()->setDepthTest(true) ` 设置。

## [Renderer](renderer.md)

在 Renderer 下添加了 backend 层，其中与 Metal 相关的适配文件统统放在了 metal 文件夹下，与 OpenGL ES 渲染相关的文件都放在 opengl 文件夹。原则上，除了 metal 和 opengl 这两个文件夹下的源码之外，不允许直接使用任何平台下的图形 API。

```
renderer
│   CCxxx.h    
│   CCxxx.cpp
|   ...
└───backend
│   │   file011.h
│   │   file011.cpp
│   │   ...
│   └───metal
│       │   filexxxMTL.h
│       │   filexxxMTL.mm
│       │   ...
│   └───opengl
│       │   filexxxGL.h
│       │   filexxxGL.cpp
│       │   ...
└───shaders
│   │   xxx.vert
│   │   xxx.frag
│   │   ...
│   CMakeLists.txt
```

# [ProgramState](pipelineDescriptor.md)

Metal 使用 [MSL](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf?language=objc#//apple_ref/doc/uid/TP40014364) 作为 shader 开发语言。为了支持 OpenGL ES shader 运行在 Metal 框架上，V4 采用 [glsl-optimizer](https://github.com/cocos2d/glsl-optimizer) 将 OpenGL ES shader 转换成 Metal MSL shader。

ShaderCache 和 ProgramCache 分别负责 [Shader](device.md) 和 [Program](device.md) 创建以及复用。

[ProgramState](pipelineDescriptor.md) 创建 Program，分配 uniform buffer，存储 uniform 数据。存储 texture 信息。

顶点数据则存储在 [Buffer](device.md) 中，使用教程参考 [设置VertexBuffer](pipelineDescriptor.md) 和 [VertexLayout](pipelineDescriptor.md)。 

## Texture2D

1. 移除 `Texture2D::PixelFormat`，统一使用 Types.h 下的 `backend::PixelFormat`。

2. 移除源码中使用 opengl es api 情况。

3. 移除了 convertXXX，统一使用 CCTextureUtils.h 下的 convertXXX 接口。

4. 移除了以下接口

   ```c++
   CC_DEPRECATED_ATTRIBUTE const char* stringForFormat() const;
   CC_DEPRECATED_ATTRIBUTE unsigned int bitsPerPixelForFormat() const;
   CC_DEPRECATED_ATTRIBUTE unsigned int bitsPerPixelForFormat(Texture2D::PixelFormat format) const;
   GLuint getName() const;
   void setGLProgram(GLProgram* program);
   GLProgram* getGLProgram() const;
   ```

5. 新增了如下接口，用于设置 render texture。

   ```c++
   bool initWithBackendTexture(backend::TextureBackend* texture);
   void setRenderTarget(bool renderTarget);
   inline bool isRenderTarget() const;
   ```

6. 移除了 opengl texture object（`GLuint _name` ），改用 `backend::Texture2DBackend* _texture` 作为纹理对象。





