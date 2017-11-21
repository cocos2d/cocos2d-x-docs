# 播放背景音乐

通过下面的方式，播放一个音频文件作为背景音乐，可以控制背景音乐是否循环播放。

{% codetabs name="C++", type="cpp" -%}
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// set the background music and continuously play it.
audio->playBackgroundMusic("mymusic.mp3", true);

// set the background music and play it just once.
audio->playBackgroundMusic("mymusic.mp3", false);
{%- endcodetabs %}

## 播放音效

通过下面的方式，将一个音频文件作为音效。

{% codetabs name="C++", type="cpp" -%}
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// play a sound effect, just once.
audio->playEffect("myEffect.mp3", false, 1.0f, 1.0f, 1.0f);
{%- endcodetabs %}
