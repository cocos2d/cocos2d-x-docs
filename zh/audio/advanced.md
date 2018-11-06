# 高级声音功能

## 配置

移动设备上的游戏会遇到一些特殊的情景，比如游戏应用被切换至后台又切换回前台，正在玩游戏的时候电话来了，电话打完继续玩游戏，这些你在进行声音控制的时候都得考虑。

幸运的是，游戏引擎在设计的时候已经考虑到这些情景了，注意在 _AppDelegate.cpp_ 中，有这样几个方法：

```cpp
// This function will be called when the app is inactive. When comes a phone call,
// it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    Director::getInstance()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    Director::getInstance()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
```

看到了那些被注释的行吗？如果你有使用 `SimpleAudioEngine` 在游戏中播放声音，记得取消这些注释。当这些被注释的代码生效，你的游戏就能应对刚才提到的场景。

## 预加载

加载音乐和音效通常是个耗时间的过程，为了防止由加载产生的延时导致实际播放与游戏播放不协调的现象，在播放音乐和音效前，可以预加载音乐文件。

```cpp
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// pre-loading background music and effects. You could pre-load
// effects, perhaps on app startup so they are already loaded
// when you want to use them.
audio->preloadBackgroundMusic("myMusic1.mp3");
audio->preloadBackgroundMusic("myMusic2.mp3");

audio->preloadEffect("myEffect1.mp3");
audio->preloadEffect("myEffect2.mp3");

// unload a sound from cache. If you are finished with a sound and
// you wont use it anymore in your game. unload it to free up
// resources.
audio->unloadEffect("myEffect1.mp3");
```

## 音量控制

可以像下面这样，通过代码控制音乐和音效的音量：


```cpp
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// setting the volume specifying value as a float
audio->setEffectsVolume(5.0f);
```
