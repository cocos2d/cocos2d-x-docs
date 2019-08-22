# Overview

A simple guide for how to migrate from v4 engine into v3 using cmake and xcode.

# Step by Step

1. fetch and pull latest [v4](https://github.com/cocos2d/cocos2d-x/tree/v4) branch.

2. [use cmake to generate project](https://github.com/cocos2d/cocos2d-x/blob/v4/cmake/README.md#generate-macos-project).

3. find the v4 engine project at `cocos2d-x/build/engine/cocos/core/`

4. open your v3 game project, remove the reference to v3 game engine projcet(`cocos2d_libs.xcodeproj`), then drag the v4 engine project to your game project.

5. select your project in the **PROJECT** group, then go to **Build Settings** —> **Search Paths** —> **User Header Search Paths**

   Expand the **User Header Search Paths** section, double click the **Debug** or **Release**. 

   In the appeared window, delete original v3 engine header search paths and set to currently v4 engine search paths one by one.

   ```c
   //for you reference
   your_v4_path/cocos2d-x/cocos
   your_v4_path/cocos2d-x/cocos/editor-support
   your_v4_path/cocos2d-x/extensions
   your_v4_path/cocos2d-x/external
   your_v4_path/cocos2d-x/external/chipmunk/include
   your_v4_path/cocos2d-x/external/Box2D/include
   your_v4_path/cocos2d-x/external/bullet/include
   your_v4_path/cocos2d-x/external/bullet/include/bullet
   ```

6. select your target in the **TARGETS** group, then got **Build Settings** —> **Linking** —> **Other Linker Flags**

   Expand the **Other Linker Flags** section, double click the **Debug** or **Release**. 

   In the appeared window, set the v4 needed libraries.

   ```c
   //for you reference
   your_v4_path/cocos2d-x/external/Box2D/prebuilt/ios/libbox2d.a
   your_v4_path/cocos2d-x/external/jpeg/prebuilt/ios/libjpeg.a
   your_v4_path/cocos2d-x/external/freetype2/prebuilt/ios/libfreetype.a
   your_v4_path/cocos2d-x/external/webp/prebuilt/ios/libwebp.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libLinearMath.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libBulletDynamics.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libBulletCollision.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libLinearMath.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libBulletMultiThreaded.a
   your_v4_path/cocos2d-x/external/bullet/prebuilt/ios/libMiniCL.a
   your_v4_path/cocos2d-x/external/tiff/prebuilt/ios/libtiff.a
   your_v4_path/cocos2d-x/external/websockets/prebuilt/ios/libwebsockets.a
   your_v4_path/cocos2d-x/external/uv/prebuilt/ios/libuv_a.a
   your_v4_path/cocos2d-x/external/openssl/prebuilt/ios/libssl.a
   your_v4_path/cocos2d-x/external/glsl-optimizer/prebuilt/ios/libmesa.a
   your_v4_path/cocos2d-x/external/glsl-optimizer/prebuilt/ios/libglsl_optimizer.a
   your_v4_path/cocos2d-x/external/glsl-optimizer/prebuilt/ios/libglcpp-library.a
   your_v4_path/cocos2d-x/external/png/prebuilt/ios/libpng.a
   your_v4_path/cocos2d-x/external/curl/prebuilt/ios/libcurl.a
   your_v4_path/cocos2d-x/external/openssl/prebuilt/ios/libcrypto.a
   -framework Metal
   ```

7. select your target in the **TARGETS** group, goto **Build Phases**

   - expand the **Target Dependecies** section, click the "+" button. In the appeared window, find the **cocos2d** item itn the list and click the Add button.
   - expand the **Link Binary With Libraries** section, click the "+" button. In the appeared window, add the **libcocos2d.a** and external libraries(library name start with "libext").

8. compile and run.

   

 



