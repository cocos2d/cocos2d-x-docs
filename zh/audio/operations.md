# 声音控制

开始播放音乐和音效后，你可能需要对它们进行一些控制，比如暂停、停止、恢复。这很容易完成，下面介绍：

## 暂停

```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;

auto audioID = AudioEngine::play2d(...);

// pause music.
AudioEngine::pause(audioID);

// pause all sound effects.
AudioEngine::pauseAll();
```

## 停止

```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;

auto audioID = AudioEngine::play2d(...);

// stop music.
AudioEngine::stop(audioID);

// stops all running sound effects.
AudioEngine::stopAll();
```

## 恢复

```cpp
#include "AudioEngine.h"
using namespace cocos2d::experimental;

auto audioID = AudioEngine::play2d(...);

// resume music.
AudioEngine::resume(audioID);

// resume all sound effects.
AudioEngine::resumeAll();
```
