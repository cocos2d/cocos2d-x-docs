# 播放背景音乐/音效

通过下面的方式，播放一个音频文件作为背景音乐或者音效，可以控制音乐是否循环播放。

```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;


// set the background music and continuously play it.
auto backgroundAudioID = AudioEngine::play2d("mymusic.mp3", true);

// set the music and play it just once.
auto soundEffectID = AudioEngine::play2d("gameeffect.mp3", false);
```

