## Advanced audio functionality

### Setup
It is easy to get started using the `SimpleAudioEngine` API. There are
considerations to keep in mind when using audio in your game. Mostly
when operating on mobile devices such as phones and tablets. What happens when
you multi-task on your phone and are switching between apps? Or when a phone
call comes in? You need to handle these exceptions in your game. Fortunately, we
help you here.

In `AppDelegate.cpp`, notice the following methods:

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

Notice the commented out lines for `SimpleAudioEngine`? Make sure to uncomment these lines out if you are using audio for background sounds and sound effects.

### Pre-loading sound
When your game starts you might want to pre-load the music and effects so they
are ready when you need them.

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

### Volume
You can increase and decrease the volume of your sounds and music programmatically.

```cpp
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;

auto audio = SimpleAudioEngine::getInstance();

// setting the volume specifying value as a float
audio->setEffectsVolume(5.0f);
```
