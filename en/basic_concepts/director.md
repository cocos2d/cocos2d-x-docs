## Director
__Cocos2d-x__ uses the concept of a **Director**, just like in a movie! The `Director` object controls the flow of operations and tells the necessary recipient what to do. Think of yourself as the _Executive Producer_ and you tell the `Director` what to do! One common `Director` task is to control `Scene` replacements and transitions. The `Director` is a shared singleton (effectively, there's only one instance of the class at a time) object that you can call from anywhere in your
code.

Here is an example of a typical game flow. The `Director` takes care of transitioning through this as your game criteria decides:

![](basic_concepts-img/scenes.png "")

You are the director of your game. You decide what happens, when and how. Take charge!

### How do I get the **Director's** attention?
To interact with the `Director` you need to call on it. There are a few ways to do this:
```cpp
// get the director and then use it
auto director = cocos2d::Director::getInstance();
director->runWithScene(scene);

// get the director for each operation (not recommended for repeated requests)
auto s = cocos2d::Director::getInstance()->getWinSize();
```

### What things can the **Director** do?
The `Director` has many responsibilities and even more possibilities. As mentioned above, the `Director` controls the show. Here are some useful things the `Director` can do without breaking a sweat:

  > __Scenes:__ change scenes, change scenes with a transition effects, etc
  ```cpp
  director->runWithScene(scene); // use when starting your game

  director->replaceScene(scene2); // use when changing from the running scene to another scene
  ```

  > __Pause/Resume:__ pause your game (if you are using physics there are more steps)
  ```cpp
  // stop animations
  cocos2d::Director::getInstance()->stopAnimation();
  
  // resume animations
  cocos2d::Director::getInstance()->startAnimation();
  ```
  > __Get internal info:__ get/set properties of your game. Consult the API Reference for more functionality.
  ```cpp
   // turn on display FPS
  cocos2d::Director::GetInstance()->setDisplayStats(true);

  // set FPS. the default value is 1.0/60 if you don't call this
  cocos2d::Director::GetInstance()->setAnimationInterval(1.0f / 60);

  // set content scale factor
  cocos2d::Director::GetInstance()->setContentScaleFactor(....);
  ```

### Let's Build A Game - Step 3
In the previous step we explored the `AppDelegate` class and what it does. In the next chapter we will explore **Scenes**. Before we get to that, we should do a bit of house-keeping.

#### Resources
Every game will have at least a few resources. These could be *fonts*, *sounds effects*, *music* or *sprites*. In this sample game we are first going to use simple shapes until our game is playable. Much later on we can use real art work.

Moving on...

[Scenes](scene.md)