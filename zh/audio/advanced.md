# 高级声音功能

## 配置

移动设备上的游戏会遇到一些特殊的情景，比如游戏应用被切换至后台又切换回前台，正在玩游戏的时候电话来了，电话打完继续玩游戏，这些你在进行声音控制的时候都得考虑。

幸运的是，游戏引擎在设计的时候已经考虑到这些情景了，注意在 _AppDelegate.cpp_ 中，有这样几个方法：

```cpp
// This function will be called when the app is inactive. When comes a phone call,
// it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    Director::getInstance()->stopAnimation();

    // if you use AudioEngine, it must be pause
    // AudioEngine::pauseAll();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    Director::getInstance()->startAnimation();

    // if you use AudioEngine, it must resume here
    // AudioEngine::resumeAll();
}
```

看到了那些被注释的行吗？如果你有使用 `AudioEngine` 在游戏中播放声音，记得取消这些注释。当这些被注释的代码生效，你的游戏就能应对刚才提到的场景。

## 预加载

加载音乐和音效通常是个耗时间的过程，为了防止由加载产生的延时导致实际播放与游戏播放不协调的现象，在播放音乐和音效前，可以预加载音乐文件。

```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;


// pre-loading background music and effects. You could pre-load
// effects, perhaps on app startup so they are already loaded
// when you want to use them.
AudioEngine::preload("myMusic1.mp3");
AudioEngine::preload("myMusic2.mp3");


// unload a sound from cache. If you are finished with a sound and
// you wont use it anymore in your game. unload it to free up
// resources.
AudioEngine::uncache("myEffect1.mp3");
```

通过回调, 你也可以 __`preload`__ 完成后进行一些操作

```cpp
AudioEngine::preload("myMusic1.mp3", [](bool success){
    //do some stuff 
});
```

## 音量控制

可以像下面这样，通过代码控制音乐和音效的音量：


```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;

// setting the volume specifying value as a float
// set default volume
AudioEngine::setVolume(audioID, 0.5);
```
