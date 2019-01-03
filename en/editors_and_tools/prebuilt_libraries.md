## Creating And Using Prebuilt Libraries
Cocos2d-x, like any large scale project, is made up of many hundreds of source files. You can examine the inner-workings or __peer under the hood__ of Cocos2d-x through these source files. You can modify these files as you wish. This freedom comes at a cost, however. No, not as in money, but something much more valuable! __Compiling time!!__. Every time a source file is changed, the __compiler__ must recompile all files that are part of the projects. __Compiling__ a project costs developers time. Compiling many, many times a day adds up even more time. Fortunately, there is an easily solution. Use __prebuilt__, also called __static__ libraries. This process wraps up all the source files in a project into a single __library__ that you can use to compile and link againt in your projects. Since the compiler knows that this library has not changed between compilers, there is no need to re-compile it. This is the same as saying: "I won't touch the engine, just build on top if it". Your compile times will go down from several minutes to perhaps less than one minute.

### Generating The Prebuilt Libraries For Use
Prebuilt libraries are available on *iOS*, *macOS*, *Android* and *Win32*

In-order to use the prebuilt libraries in your projects you need to compile them. This assumes that you already haave a working Cocos2d-x installation. If you do not, please refer to our [installation guides](../installation/).

```sh

```

The build process can take between several minutes and several hours, depending upon your hardware and software setup. Once complete the prebuilt libraries are located in: __prebuilt/__, inside your Cocos2d-x root directory. You can easily __symlink__ to these projects, thus allowing these libraries to be used amongst several projects at once, or you can copy them to individual projects or another location that better suits your needs.

### Using The Prebuilt Libraries In Your Projects
Using the prebuilt libraries in your projects is easy. Simply add the libraries you need into your project and set your __header__ and __include__ search paths. Doing this depends upon the enviroment you are using. The paths you need to add are:

__Header Search Paths:__
```sh
# Project level
/path_to_cocos2d-x/cocos2d-x/
/path_to_cocos2d-x/cocos2d-x/cocos
/path_to_cocos2d-x/cocos2d-x/cocos/base /path_to_cocos2d-x/cocos2d-x/cocos/physics /path_to_cocos2d-x/cocos2d-x/cocos/math
/path_to_cocos2d-x/cocos2d-x/cocos/2d
/path_to_cocos2d-x/cocos2d-x/cocos/ui /path_to_cocos2d-x/cocos2d-x/cocos/network /path_to_cocos2d-x/cocos2d-x/cocos/audio/include /path_to_cocos2d-x/cocos2d-x/cocos/editor-support /path_to_cocos2d-x/cocos2d-x/extensions
/path_to_cocos2d-x/cocos2d-x/external /path_to_cocos2d-x/cocos2d-x/external/chipmunk/include/chipmunk

# Target level
/path_to_cocos2d-x/cocos2d-x/cocos/platform/ios /path_to_cocos2d-x/cocos2d-x/cocos/platform/ios/Simulation
```

__Include Search Paths:__
```sh
/path_to_cocos2d-x/cocos2d-x/prebuilt/ios
```
