## Basic Cocos2d-x Concepts
This chapter assumes you've just gotten started with __Cocos2d-x__, and are ready to start working on the game of your dreams. Don't worry, it will be fun!

Let's get started!

__Cocos2d-x__ is a __cross-platform game engine__. A __game engine__ is a piece of software that provides common functionality that all games need. You might have heard this referred to as an API or framework but in this guide, we'll be calling it a __game engine__.

__Game engines__ include many components that when used together will help speed up development time, and often perform better than homemade engines. A __game engine__ is usually comprised of some or all of the following components: **a renderer**, **2d/3d graphics**, **collision detection**, **a physics engine**, **sound**, **controller support**, **animations**, **sequences** and **more**. To be sure we are all on the same page, we should review common game terminology:

  * __Director:__ You can think of the `Director` the same way you think about a _movie director_. The `Director` controls every aspect of your game. What is shown on the screen, what sounds are played, what happens with player input, and much more.

  * __Scene:__ A `Scene` is a container that holds `Sprites`, `Labels`, `Nodes` and other objects that your game needs. A `Scene` is responsible for running game logic and rendering the content on a per-frame basis.

  * __Sprite:__ A `Sprite` is a 2D image that can be animated or transformed by changing its properties. Most all games will have multiple `Sprite` objects ranging from the hero, an enemy or a level boss.

  * __Scene Graph:__ The __scene graph__ is a data structure that arranges a graphical scene, into a tree structure. This tree structure is what is used to render objects onscreen in a specific order.

  * __Renderer:__ In an oversimplified definition the **renderer** is responsible for taking everything you want on the screen and getting it there, technically. No need to delve into this further at this time.

  * __Events:__ What do you do when the player moves around? What about touch events or keyboard input? These all trigger **events** that can be acted upon as needed.

  * __Audio:__ Perhaps your game has background music and or sound effects. There needs to be a way to hear them!

  * __UI Components:__ Things like `Button`, `Label`, `ScrollView`, etc. Items that help you layout your game and related interfaces.

  * __Physics Engine:__ The physics engine is responsible for emulating the laws of physics realistically within the application.

__Game engines__ usually support multiple platforms thus making it easy to develop your game and then deploy it to multiple platforms without much overhead at all. Since __Cocos2d-x__ is a __game engine__, it provides a simplified API for developing cross-platform mobile and desktop games. By encapsulating the power inside an easy to use API, you can focus on developing your games and worry less about the implementation of the technical underpinnings. __Cocos2d-x__ will take care of as much or as little of the heavy lifting as you want.

__Cocos2d-x__ provides `Scene`, `Transition`, `Sprite`, `Menu`, `Sprite3D`, `Audio` objects and much more (our __API Reference__ and `cpp-tests` will be your best friends!). Everything you need to create your games is included.

### Let's Build A Game - Step 1
Going step-by-step is the best way to make a game. Break the game down into pieces and tackle them one at a time, tieing them together as needed. To get started, please review our [installation docs](../installation) and our [command-line tools docs](../editors_and_tools).

Ensure that you have __Cocos2d-x__ installed and you have created a new project to begin development with. __Hint:__ `cocos new  FirstGame -l cpp -p com.mycompany.mygame -d Games/.` or similar is what you will end up running. Once you have this step done, keep on reading...

[Let's get started learning concepts and building a game!](getting_started.md)