## Camera
__Camera__ objects are an important aspect of 3D development. Since a 3D world is not flat you need to use a `Camera` to look at it and navigate around it. Just like when you are watching a movie and the scene pans to the left or right. This same concept is applied when using a `Camera` object. The `Camera` object inherits from `Node` and therefore supports most of the same `Action` objects. There are two types of `Camera` objects: __perspective camera__ and __orthographic camera__.

The __perspective camera__ is used to see objects having a near to far effect. A
__perspective camera__ view might look like this:

![](3d-img/PerspectiveCamera.png)

As you can see with a __perspective camera__, objects in the _near_ are larger and
objects in the __far__ are smaller.

The __orthogonal camera__ is used to see objects as large distance. You can think
about it as converting a 3D world to a 2D representation. An __orthogonal camera__
view might look like this:

![](3d-img/OrthographicCamera.png)

As you can see with an __orthogonal camera__, objects are the same size regardless
of how far away from the `Camera` object they are. __Mini Maps__ in games are
commonly rendered with an __orthogonal camera__. Another example would be a top -
down view, perhaps in a dungeon style game.

### Camera Use
Don't worry! `Camera` objects may sound complicated but Cocos2d-x makes them easy.
When using 3D you don't have to do anything special to create a `Camera` object.
Each `Scene` automatically creates a default camera, based on the projection
properties of the `Director` object. If you need more than one camera, you can
use the following code to create one:

```cpp
auto s = Director::getInstance()->getWinSize();
auto camera = Camera::createPerspective(60, (GLfloat)s.width/s.height, 1, 1000);

// set parameters for camera
camera->setPosition3D(Vec3(0, 100, 100));
camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));

addChild(camera); //add camera to the scene
```

### Creating orthogonal camera
The default `Camera` is a __perspective camera__. If you want to create an
__orthogonal camera__, it's easy to do by calling:

```cpp
Camera::createOrthographic();
```

Example:

```cpp
auto s = Director::getInstance()->getWinSize();
auto camera = Camera::createOrthographic(s.width, s.height, 1, 1000);
```

### Hiding objects from the camera
Sometimes you don't want to have all objects visible in a `Camera` view. Hiding
an object from one camera is very easy. Use __setCameraMask(CameraFlag)__ on the
`Node` and __setCameraFlag(CameraFlag)__ on the `Camera`. Example:

```cpp
//Camera
camera->setCameraFlag(CameraFlag::USER1);

//Node
node->setCameraMask(CameraFlag::USER1);
```
