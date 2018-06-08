## Basic Cocos2d-x Concepts
This chapter assumes you've just gotten started with Cocos2d-x, and are ready to
start working on the game of your dreams. Don't worry, it will be fun!

Let's get started!

Cocos2d-x is a cross-platform game engine. A game engine is a piece of software
that provides common functionality that all games need. You might have heard this referred to as an API or framework but in this guide, we'll be calling it a
__game engine__.

__Game engines__ include many components that when used together will help speed up development time, and often perform better than homemade engines. A game engine is usually comprised of some or all of the following components: *a renderer*, *2d/3d graphics*, *collision detection*, *a physics engine*, *sound*, *controller support*, *animations* and *more*. To be sure we are all on the same page, we should review common game terminology:

* __Director:__ You can think of the `Director` the same way you think about a
_movie director_. The `Director` controls every aspect of your game. What is shown on the screen, what sounds are played, what happens with player input, and much more.

* __Scene:__ A `Scene` is a container that holds `Sprites`, `Labels`, `Nodes` and other objects that your game needs. A `Scene` is responsible for running game logic and rendering the content on a per-frame basis.

* __Sprite:__ A `Sprite` is a 2D image that can be animated or transformed by changing its properties. Most all games will have multiple `Sprite` objects ranging from the hero, an enemy or a boss.

* __Scene Graph:__ The __scene graph__ is a data structure that arranges a graphical scene, into a tree structure. This tree structure is what is used to render objects onscreen in a specific order.

* __Renderer:__ In an oversimplified definition the _renderer_ is responsible for taking everything you want on the screen and getting it there, technically. No need to delve into this further at this time.

* __Events:__ What do you do when the player moves around? What about touch events or keyboard input? These all trigger _events_ that can be acted upon as needed.

* __Audio:__ Perhaps your game has background music and or sound effects. There
needs to be a way to hear them!

* __UI Components:__ Things like `Button`, `Label`, `ScrollView`, etc. Items that help you layout your game and related interfaces.

* __Physics Engine:__ The physics engine is responsible for emulating the laws of physics realistically within the application.

__Game engines__ usually support multiple platforms thus making it easy to develop your game and then deploy it to multiple platforms without much overhead at all. Since __Cocos2d-x__ is a __game engine__, it provides a simplified API for developing cross-platform mobile and desktop games. By encapsulating the power inside an easy to use API, you can focus on developing your games and worry less about the implementation of the technical underpinnings. Cocos2d-x will take care of as much or as little of the heavy lifting as you want.

__Cocos2d-x__ provides `Scene`, `Transition`, `Sprite`, `Menu`, `Sprite3D`, `Audio` objects and much more. Everything you need to create your games are included.
