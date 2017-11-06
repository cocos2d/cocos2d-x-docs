<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## How to optimize the graphics performance of your Cocos2d-x games

### Golden rules
#### Know the bottlenecks and optimize the bottlenecks.
When doing optimization, we should always stick to this rule. Only 20% code in your system contribute to the 80% performance issue.

#### Always use tools to profile the bottleneck, don't guess randomly.
There are many tools available now for profiling the graphics performance.
Though we are optimize the performance of Android games, but Xcode could also be helpful to debugging.

- Xcode: https://github.com/rstrahl/rudistrahl.me/blob/master/entries/Debugging-OpenGL-ES-With-Xcode-Profile-Tools.md
and the official document: https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ToolsOverview/ToolsOverview.html

There are three major mobile GPU vendors nowadays and they provide decent graphics profiling tools:

- For ARM Mali GPU: http://malideveloper.arm.com/resources/tools/mali-graphics-debugger/
- For Imagination PowerVR GPU: https://community.imgtec.com/developers/powervr/tools/pvrtune/
- For Qualcomm Adreno GPU: https://developer.qualcomm.com/software/adreno-gpu-profiler

Use these tools when you suffer from graphics issues. **But not at the first beginning, usually the bottleneck resides on CPU.**

#### Know your target device and your game engine
Know the CPU/GPU family of your target device  which is important when sometimes the performance issues
only occurs on certain kind of devices. And you will find they share the same kind of GPU(ARM or PowerVR or Mali).

Know the limitations of your currently used game engine is also important. If you know how your engine organize the graphics command,
how your engine do batch drawing. You could avoid many common pitfalls during coding.

#### The principle of "Good enough".
(“If the viewer cannot tell the difference between differently rendered images always use the cheaper implementation".)
As we know a PNG with RGBA444 pixel format has lower graphics quality than the one with RGBA888 pixel format.
But if we can't tell the difference between the two, we should stick to RGBA4444 pixel format.
The RGBA444 format use less memory and it will less likely to cause the memory issue and bandwidth issue.

It is the same goes for the audio sample rate.

### Common Bottlenecks
As a rules of thumb, your game will suffer CPU bottlenecks easily than graphics bottlenecks.

#### The CPU is often limited by the number of draw calls and the heavy compute operations in your game loop
Try to minimize the total draw calls of your game. We should use batch draw as much as possible.
Cocos2d-x 3.x has auto batch support, but it needs some effort to make it work.

Also try avoid IO operations when players are playing your game. Try to preload your spritesheets, audios, TTF fonts etc.

Also don't do heavy compute operations in your game loop which means don't let the heavy operations called 60 times per frame.

Never!

#### The GPU is often limited by the overdraw(fillrate) and bandwidth.
If you are creating a 2D game and you don't write complex shaders, you might won't suffer GPU issues.
But the overdraw problem still has trouble and it will slow your graphics performance with too much bandwidth consumption.

Though modern mobile GPU have TBDR(Tiled-based Defered Rendering) architecture, but only PowerVR's HSR(Hidden Surface Removal)
could reduce the overdraw problem significantly. Other GPU vendors only implement a TBDR + early-z testing, it only reduce the overdraw
problem when you submit your opaque geometry with the order(font to back). And Cocos2d-x always submit rendering commands ordered from back to front.
Because in 2D, we might have many transparency images and only in this order the blending effect is correct.

Note: By using poly triangles, we could improve the fillrate.  Please refer to this article for more information:
https://www.codeandweb.com/texturepacker/tutorials/cocos2d-x-performance-optimization

But don't worry too much of this issue, it doesn't perform too bad in practice.

### Simple checklist to make your Cocos2d-x game faster
1.  Always use batch drawing. Package sprite images in the same layer into a large atlas(Texture packer could help).
2.  As rule of thumb, try to keep your draw call below 50. In other words, try to minimize your draw call number.
3.  Prefer 16bit(RGBA4444+dithering) over raw 32bit(RGBA8888) textures.
4.  Use compressed textures: In iOS use PVRTC texture. In Android platform, use ETC1. but ETC1 doesn't has alpha,
you might need to write a custom shader and provide a separate ETC1 image for the alpha channel.
5.  Don't use system font as your game score counter. It's slow. Try to use TTF or BMFont, BMfont is better.
6.  Try to preload audio and other game objects before usage.
7. Use armeabi-v7a to build Android native code and it will enable neon instructors which is very fast.
8. Bake the lighting rather than using the dynamic light.
9. Avoid using complex pixel shaders.
10. Avoid using **discard** and alpha test in your pixel shader, it will break the HSR(Hidden surface removal). Only use it when necessary.
