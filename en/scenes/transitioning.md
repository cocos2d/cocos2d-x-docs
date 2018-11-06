## Transitioning between Scenes
You might need to move between `Scene` objects in your game. Perhaps starting a
new game, changing levels or even ending your game. Cocos2d-x provides a number
of ways to do __scene transitions__.

### Ways to transition between Scenes
There are many ways to transition through your __scenes__. Each has specific
functionality. Let's go through them. Given:

```cpp
auto myScene = Scene::create();
```

__runWithScene()__ - use this for the first scene only. This is the way to start
your games first `Scene`.

```cpp
Director::getInstance()->runWithScene(myScene);
```

__replaceScene()__ - replace a scene outright.

```cpp
Director::getInstance()->replaceScene(myScene);
```

__pushScene()__ - suspends the execution of the running scene, pushing it on the
stack of suspended scenes. Only call this if there is a running scene.

```cpp
Director::getInstance()->pushScene(myScene);
```

__popScene()__ - This scene will replace the running one. The running scene will
be deleted. Only call this if there is a running scene.

```cpp
Director::getInstance()->popScene(myScene);
```

### Transition Scenes with effects
You can add visual effects to your `Scene` transitions

```cpp
auto myScene = Scene::create();

// Transition Fade
Director::getInstance()->replaceScene(TransitionFade::create(0.5, myScene, Color3B(0,255,255)));

// FlipX
Director::getInstance()->replaceScene(TransitionFlipX::create(2, myScene));

// Transition Slide In
Director::getInstance()->replaceScene(TransitionSlideInT::create(1, myScene) );
```
