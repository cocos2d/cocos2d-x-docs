# 声音控制

开始播放音乐和音效后，你可能需要对它们进行一些控制，比如暂停、停止、恢复。这很容易完成，下面介绍：

## 暂停

{% codetabs name="C++", type="cpp" -%}
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// pause background music.
audio->pauseBackgroundMusic();

// pause a sound effect.
audio->pauseEffect();

// pause all sound effects.
audio->pauseAllEffects();
{%- endcodetabs %}

## 停止

{% codetabs name="C++", type="cpp" -%}
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// stop background music.
audio->stopBackgroundMusic();

// stop a sound effect.
audio->stopEffect();

// stops all running sound effects.
audio->stopAllEffects();
{%- endcodetabs %}

## 恢复

{% codetabs name="C++", type="cpp" -%}
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// resume background music.
audio->resumeBackgroundMusic();

// resume a sound effect.
audio->resumeEffect();

// resume all sound effects.
audio->resumeAllEffects();
{%- endcodetabs %}
