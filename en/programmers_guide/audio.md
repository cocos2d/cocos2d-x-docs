# Audio

Your game will surely need sound! Cocos2d-x provides an audio engine called
`SimpleAudioEngine`. It can be used to play background
music as well as sound effects through out your game play. `SimpleAudioEngine`
is a shared singleton object so you can simple call it from anywhere in your code.
When creating a sample __HelloWorld__ project we do all the setup required for you,
out of the box. It also supports a variety of formats, including __mp3__
and __Core Audio Format__

##Getting Started
The `SimpleAudioEngine` API is very easy to use.

###Play background music
Play an audio file for use as background music. This can be repeated
continuously.

{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// set the background music and continuously play it.
audio->playBackgroundMusic("mymusic.mp3", true);

// set the background music and play it just once.
audio->playBackgroundMusic("mymusic.mp3", false);
{%- endcodetabs %}

###Play a sound effect.
Play a sound effect.

{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// play a sound effect, just once.
audio->playEffect("myEffect.mp3", false, 1.0f, 1.0f, 1.0f);
{%- endcodetabs %}

###Pausing, stopping, resuming music and sound effects
After you start to play music and sound effects you might need to pause,
stop or resume after certain operations. This can be done easily.

####Pause
{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// pause background music.
audio->pauseBackgroundMusic();

// pause a sound effect.
audio->pauseEffect();

// pause all sound effects.
audio->pauseAllEffects();
{%- endcodetabs %}

####Stop
{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// stop background music.
audio->stopBackgroundMusic();

// stop a sound effect.
audio->stopEffect();

// stops all running sound effects.
audio->stopAllEffects();
{%- endcodetabs %}

####Resume
{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// resume background music.
audio->resumeBackgroundMusic();

// resume a sound effect.
audio->resumeEffect();

// resume all sound effects.
audio->resumeAllEffects();
{%- endcodetabs %}

##Advanced audio functionality

###Setup
It is easy to get started using the `SimpleAudioEngine` API. There are
considerations to keep in mind when using audio in your game. Mostly
when operating on mobile devices such as phones and tablets. What happens when
you multi-task on your phone and are switching between apps? Or when a phone
call comes in? You need to handle these exceptions in your game. Fortunately, we
help you here.

In `AppDelegate.cpp`, notice the following methods:

{% codetabs name="C++", type="cpp" -%}
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
{%- endcodetabs %}

Notice the commented out lines for `SimpleAudioEngine`? Make sure to uncomment these
lines out if you are using audio for background sounds and sound effects.

###Pre-loading sound
When your game starts you might want to pre-load the music and effects so they
are ready when you need them.

{% codetabs name="C++", type="cpp" -%}
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
{%- endcodetabs %}

###Volume
You can increase and decrease the volume of your sounds and music programmatically.

{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// setting the volume specifying value as a float
audio->setEffectsVolume(5.0f);
{%- endcodetabs %}
