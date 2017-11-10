# 图形性能优化

## 黄金法则

### 找出性能优化的瓶颈

系统中 20% 的代码会消耗 80% 的性能！在进行性能优化时，我们应该始终坚持这个原则。

### 使用工具分析 不随意猜测

有许多工具可用于分析图形性能，即使我们需要优化 Android 游戏的性能，也可以使用 Xcode 帮助调试。

- Xcode: [Debugging-OpenGL-ES-With-Xcode-Profile-Tools](https://github.com/rstrahl/rudistrahl.me/blob/master/entries/Debugging-OpenGL-ES-With-Xcode-Profile-Tools.md)
- 官方文档: [OpenGLES_ProgrammingGuide](https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ToolsOverview/ToolsOverview.html)

三大移动 GPU 供应商，也提供了图形分析工具

- ARM Mali GPU: [mali-graphics-debugge](http://malideveloper.arm.com/resources/tools/mali-graphics-debugger/)
- Imagination PowerVR GPU: [pvrtune](https://community.imgtec.com/developers/powervr/tools/pvrtune/)
- Qualcomm Adreno GPU: [adreno-gpu-profiler](https://developer.qualcomm.com/software/adreno-gpu-profiler)

当你遇到图形性能问题时可以使用这些工具，__但在这之前，请先确认是不是 CPU 导致的性能问题__

### 了解目标设备 了解游戏引擎

了解目标设备的 CPU/GPU 系列，当性能问题仅在某些设备上出现时，这个信息就非常重要。或许你会发现他们共用一种 GPU：ARM、PowerVR 或 Mali。然后就可以进行有针对性的分析。

了解目前使用的游戏引擎也很重要，如果你知道引擎是如何组织图形命令，如何处理绘制过程。那在编码的过程中就能避免许多常见的陷阱。

### 够用原则

如果有两种方式渲染图像，无法观察出哪个渲染的效果更好，那就选用性能消耗更低的方式。我们知道，RGBA4444 像素格式的 _PNG_ 图像质量比 RGBA8888 像素格式的要低，但是如果在游戏效果上，无法观察出哪个效果好，我们应该坚持使用 RGBA4444 的像素格式，因为它占用更少的内存，出现内存问题和带宽问题的可能性更小。

音频采样率也是一样的。

## 常见瓶颈

作为一个经验法则，游戏性能问题更容易出现在 CPU ，而不是 GPU

### CPU 性能问题

__绘制调用(draw call)__ 次数过多，游戏循环中计算量过大，都会造成 CPU 性能下降，尽量减少游戏中的总绘制调用次数，我们应该尽可能的使用批量绘制。 Cocos2d-x 有自动批量处理绘制的支持，但仍需要一些努力才能使其工作。

当玩家玩游戏时，要尽量避免 IO 操作，尽可能预加载图集、音频、TTF字体等

更不要在游戏循环中进行繁重的计算操作，因为这可能造成每帧 60 次的大量计算，性能消耗非常恐怖！

### GPU 性能问题

如果只是在开发一个 2D 游戏，也没有写复杂的着色器，那基本不会遇到 GPU 性能问题。但是过度绘制的问题仍然存在，如果过度绘制较多，将会消耗大量带宽，进而降低 GPU 性能。

尽管现在移动 GPU 具有 _TBDR(基于平铺的渲染)_ 架构，但是只有 PowerVR 的 _HSR(隐藏曲面去除)_ 可以显著减少过度绘制问题，其它 GPU 仅执行 TBDR 和早期的 z 测试，只有在提交不透明的几何图形时才能减少过渡绘制问题。

Cocos2d-x 总是按照从后向前的规则提交绘制命令，这样在 2D 中即使有许多透明图像，也能保证正确的混合效果。

## Cocos2d-x 性能提升建议

1. 始终使用批量绘图，将同一图层中的精灵图像打包成一个大的图集
1. 根据经验，尽量保持 _绘制调用(draw call)_ 次数低于 50，总之尽量减少就对了！
1. 在 原始 32 位（RGBA8888）纹理上，优先使用 16 位（RGBA4444 + 抖动）的处理方式
1. 使用压缩纹理，在 iOS 中使用 PVRTC 纹理，在 Android 平台上，使用 ETC1，但是 ETC1 没有 alpha 通道，你可能需要编写自定义着色器并为 alpha 通道提供单独的 ETC1 图像
1. 不要使用系统字体作为您的游戏得分计数器，它很慢的，尝试使用 TTF 或 BMFont，BMFont 更快
1. 尝试在使用音频和其它游戏对象前，进行预加载
1. 使用 armabi-v7a 构建 Android 工程，这会有更好的性能表现
1. 使用烘焙光照，而不是动态光照
1. 避免使用复杂的像素着色器
1. 避免在像素着色器中使用丢弃和 alpha 测试，它会影响 HSR 优化