## Pausing, stopping, resuming music and sound effects
After you start to play music and sound effects you might need to pause,
stop or resume after certain operations. This can be done easily.

### Pause
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

### Stop
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

### Resume
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
