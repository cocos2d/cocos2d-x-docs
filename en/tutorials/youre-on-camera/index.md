# Smile, you're on camera!
Yes, exactly like that! Just like using a camera to shoot your friends having fun at a party, you can use similar concepts to what you already intuitively know, to add __camera__ functionality to your game. Why could a camera be important? It gives dimension to a 2D game and is required for 3D games. You couldn't have a true 3D game without a camera (although you can fake to a certain extent with art). In a 2D game a camera could add functionality like a __mini-map__.

## The basics of using a camera
There are a few basic points to know when getting started using a `Camera` object. 
  - There are 2 types of cameras: __perspective__ camera and __orthographic__ camera. __Perspective camera__ can be thought of as how we see every day objects...near and far. __Orthographic camera__ can be thought of as a flat, top down view to a `Scene`.
  - Every `Scene` automatically creates a default camera, based on the projection properties of the `Director` object.

For more detailed information, please review the [camera documentation](https://docs.cocos2d-x.org/cocos2d-x/en/3d/camera.html).

## Getting Started

### Creating a demo project
The easiest thing to do is to run `cocos new CameraDemo -l cpp -d .` to create a new __Cocos__ project. We can re-use the default __HelloWorldScene__ class to get us started.  

### Housekeeping
First, to be sure, let's create a few variables to help us with screen size and then quickly navigate around the screen as needed. Example, using __origin__ and __visibleSize__ that are already defined in the default class:

```cpp
cocos2d::Vec2 centerPosition = cocos2d::Vec2(visibleSize.width / 2.f, visibleSize.height / 2.f);
cocos2d::Vec2 leftPosition = cocos2d::Vec2(visibleSize.width / 4.f, visibleSize.height / 2.f);
cocos2d::Vec2 rightPosition = cocos2d::Vec2((visibleSize.width / 2.f + visibleSize.width / 4.f), 
    visibleSize.height / 2.f);
```

Second, let's create a few `Sprite` objects to use in our `Scene`. Maybe just two:

```cpp
/* Creatingthe sprites */
/* Sprite 1 */
	auto alien1 = Sprite::create("Blue_Front1.png");
	alien1->setPosition(leftPosition);
	this->addChild(alien1);

/* Sprite 2 */
	auto alien2 = Sprite::create("White_Front1.png");
	alien2->setPosition(rightPosition);
	this->addChild(alien2);
```

### Creating a camera
You can create as many `Camera` objects as you need although it is wise to use care and consider the task at hand before creating many `Camera` objects to handle tasks other methods are better suited to handle.