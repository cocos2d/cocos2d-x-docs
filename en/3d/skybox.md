## Skybox
`Skybox` is a wrapper around your entire scene that shows what the world looks
like beyond your geometry. You might use a `Skybox` to simulate infinite sky,
mountains and other phenomena.

![](3d-img/Skybox.png)

Creating a `Skybox`:

```cpp
// create a Skybox object
auto box = Skybox::create();

// set textureCube for Skybox
box->setTexture(_textureCube);

// attached to scene
_scene->addChild(box);
```
