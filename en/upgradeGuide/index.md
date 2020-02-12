# Overview
At WWDC 2014, Apple introduced a new graphics technology, [Metal](https://developer.apple.com/documentation/metal?language=objc), for game developers. Metal is a low-level API written in C++. It represents Apple's latest graphics API design. Unlike OpenGL, Metal is not cross-platform. It is an API designed specifically for Apple's latest hardware architecture, so it can boost rendering performance by up to 10x for 3D graphics. Since Apple will deprecate OpenGL, __Cocos2d-x v4__ adopts __Metal__ for it's rendering engine on Apple platforms. __V4__ only works on those devices that support __Metal for iOS/macOS platforms__. [Metal supported devices](https://en.wikipedia.org/wiki/Metal_(API)#Supported_GPUs)

# How to run

- Mac: use `cocos` command or CMake
- iOS: use CMake to generate Xcode project, then run
- Android: use `cocos` command or `Android Studio`
- Windows: use `cocos` command or CMake
- Linux: use `cocos` command or CMake

A [CMake](../installation/CMake-Guide.md) tutorial is available.

About How to [migrate](migration.md).

For more detailed interface changes, please refer to [API Reference](../apichange/api_change_v4.md).

## Director

1. Removed the following interfaces

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

2. Removed the `void setDepthTest(bool on)` interface, set by `Director::getInstance()->getRenderer()->setDepthTest(true) `.

## Renderer

The backend layer has been added under Renderer, where the metal-related adaptation files are placed under the Metal folder, and the files related to OpenGL ES rendering are placed in the opengl folder. In principle, the graphics API under any platform is not allowed to be used directly except for the source code under the two folders metal and OpenGL.

```
Renderer
│ CCxxx.h
│ CCxxx.cpp
| ...
└───backend
│ │ file011.h
│ │ file011.cpp
│ │ ...
│ └───metal
│ │ filexxxMTL.h
│ │ filexxxMTL.mm
│ │ ...
│ └───opengl
│ │ filexxxGL.h
│ │ filexxxGL.cpp
│ │ ...
└───shaders
│ │ xxx.vert
│ │ xxx.frag
│ │ ...
│ CMakeLists.txt
```

## Shader and Program
Added `GLProgramState`, `GLProgram`, and `backend::ProgramState`. [Example 1](spriteTutorial.md), [Example 2](customCommandTutorial.md) demonstrates how to create and use `backend::ProgramState`.

Metal uses [MSL](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf?language=objc#//apple_ref/doc/uid/TP40014364) as the shader development language. To support the OpenGL ES shader running on the Metal framework, V4 uses [glsl-optimizer](https://github.com/cocos2d/glsl-optimizer) to convert the OpenGL ES shader to a Metal MSL shader.

V4 moves the shader file originally stored in `renderer/` path with `ccShader_` to the `renderer/shaders/` path, except that the shader file name is slightly modified (deleted `ccShader_`), The uniform and texture are explicitly declared in the shader file, not the attributes, uniform and texutre names predefined in `GLProgram`.

## Texture2D

1. Remove `Texture2D::PixelFormat` and use `backend::PixelFormat` under Types.h.

2. Remove the use of the OpenGL ES API from the source code.

3. Removed convertXXX to use the convertXXX interface under CCTextureUtils.h.

4. Removed the following interface

   ```c++
   CC_DEPRECATED_ATTRIBUTE const char* stringForFormat() const;
   CC_DEPRECATED_ATTRIBUTE unsigned int bitsPerPixelForFormat() const;
   CC_DEPRECATED_ATTRIBUTE unsigned int bitsPerPixelForFormat(Texture2D::PixelFormat format) const;
   GLuint getName() const;
   void setGLProgram(GLProgram* program);
   GLProgram* getGLProgram() const;
   ```

5. Added the following interface to set the render texture.

   ```c++
   bool initWithBackendTexture(backend::TextureBackend* texture);
   void setRenderTarget(bool renderTarget);
   inline bool isRenderTarget() const;
   ```

6. Remove the OpenGL texture object(`GLuint _name`) and use `backend::Texture2DBackend* _texture` as the texture object.
