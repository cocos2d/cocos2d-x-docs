# Introduction to New Renderer

## Overview
This article is mainly an overview of Cocos2d-x v3.x rendering pipeline from a developer's view. It is not a substitution of the original [roadmap](https://docs.google.com/document/d/17zjC55vbP_PYTftTZEuvqXuMb9PbYNxRFu0EGTULPK8/edit) provided by the core engine team.

**Note:** It will not cover most of the implementation details of the new rendering pipeline. If you want to contribute, please refer to the roadmap documentation.

At first, let's take a look at the vision of the new rendering pipeline.

## The Vision
The Cocos2d-x v3.x new rendering pipeline aims at improving the rendering performance by leveraging the modern multi-core CPUs so popular nowadays on most modern mobile devices.

At the meanwhile, the API style of Cocos2d-x v3.x is compatible with the v2.x which the current Cocos2d-x users will feel very comfortable with.

## The Goal
The high level goal of the new features and improvement can be summarized as the following:

- Decouple the scene graph from the renderer
- Viewing frustum Geometry culling
- Rendering on a separate thread
- Automatic batching
- (Node based) Customizable rendering
- Optimized for 2D, but suitable for 3D as well

## The Roadmap
Currently, since Cocos2d-x v3.0beta, renderer has being decoupled from the Scene Graph and it also supports auto-batching and auto-culling.

The complete Roadmap of the rendering can be found [here](https://docs.google.com/document/d/17zjC55vbP_PYTftTZEuvqXuMb9PbYNxRFu0EGTULPK8/edit#heading=h.dii2kgdfqgcp).

## Overview of the new rendering architecture
As we mentioned above, the actual rendering API goes into a new separate thread where a **RenderQueue** has been provided to issue call OpenGL commands directly to the graphic card.

Here is the illustration picture:

![architecture](./res/architexture.png)

The process of scene graph is running in a front-end thread while generating various **Command**. Each Command will be sent to the CommandQueue waited to be processed(such as sorting, rearrange etc.) in a separate back-end thread.

The internal format of each Command is out of scope in the documentation, please refer to the roadmap documentation.

If you want to extend Cocos2d-x engine v3.x. For example, if you want to define a Sprite with some customize drawing code. You can't put them into the old **draw()** function any longer.

You should be familiar with the corresponding **Command** and construct the Command on demand in the **draw()** function.

For more information, you can take a look at [DrawNode](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/2d/CCDrawNode.cpp) built-in with Cocos2d-x v3.0beta.

## Summary
Since the new rendering pipeline of Cocos2d-x v3.x is still young. It needs more time and patient to be mature. We are eager to hear your invaluable suggestions and comments of any kinds and definitely welcome to contribute by sending us pull request via [github](https://github.com/cocos2d/cocos2d-x).

