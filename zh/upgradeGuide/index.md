# Overview

在 WWDC 2014 上，Apple 为游戏开发者推出了新的图形技术 [Metal](https://developer.apple.com/documentation/metal?language=objc)。Metal 是一种用 C++ 编写的 low-level API。 它代表了 Apple 最新的图形 API 设计。与 OpenGL 不同的是，Metal 不像 OpenGL 那样是跨平台的，它是根据 Apple 最新硬件架构专门设计的 API，因此它能够为 3D 图形提高最多10倍的渲染性能。由于 Apple 声称将弃用 OpenGL，为此 V4 对 Renderer 做了适配，对于 Apple 平台，使用 Metal api 进行渲染，否则，沿用原 OpenGL ES API 渲染。

# How to run

- mac: use `cocos command` or CMake
- iOS: use CMake to generate Xcode project, then run
- Android: use `cocos command` or `Android Studio`
- windows: use `cocos command` or CMake
- linux: use `cocos command` or CMake

CMake的使用教程可以参考[CMake 指南](../installation/CMake-Guide.md)。

# 改动点

更详细的接口变化，请参考[API 改动](../apichange/api_change_v4.md)。

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

## Renderer

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

# Shader 及 Program

移除了 GLProgramState 和 GLProgram，新增了 backend::ProgramState。[范例1](spriteTutorial.md)，[范例2](customCommandTutorial.md) 演示了如何创建和使用 backend::ProgramState。

Metal 使用 [MSL](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf?language=objc#//apple_ref/doc/uid/TP40014364) 作为 shader 开发语言。为了支持 OpenGL ES shader 运行在 Metal 框架上，V4 采用 [glsl-optimizer](https://github.com/cocos2d/glsl-optimizer) 将 OpenGL ES shader 转换成 Metal MSL shader。

V4 将原来存放在 `renderer/`路径下以 `"ccShader_"` 开头的 shader 文件移到 `renderer/shaders/` 路径下，除了将shader 文件名稍作修改外（删除了`ccShader_`），在 shader 文件中显式声明 uniform 和 texture，不在使用 GLProgram 中预定义的 attribute，uniform 及 texutre 名。

## Texture2D

1. 移除 `Texture2D::PixelFormat`，统一使用 Types.h 下的 `backend::PixelFormat`。

2. 移除源码中使用 OpenGL ES API 情况。

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

# **TO be continue…**



