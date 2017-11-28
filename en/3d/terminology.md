## Terminology
When using 3D, there are some commonly used terms that you should be familiar with:

* __Mesh__ - vertices that construct a shape and texture with which you are
rendering.

* __Model__ - an object that can be rendered. It is a collection of meshes. In our
engine `Sprite3D`.

* __Texture__ - All surfaces and vertices of a 3D model can be mapped to a texture.
In most cases you will have multiple textures per model, unwrapped in a texture
atlas.

* __Camera__ - Since a 3D world is not flat, you need to set a camera to look at
it. You get different scenes with different camera parameters.

* __Light__ - Lightening is applied to make scenes look realistic. To make an object
look real, the color should change according to the light. When you face the light
it is bright and the opposite is dark. _Lightening_ an object means computing the
object's color according to the light.

<!-- content to be added later -->

<!---
BillBoard provides several create methods, as follows:
```
static BillBoard * create (Mode mode = Mode :: VIEW_POINT_ORIENTED);
static BillBoard * create (const std :: string & filename, Mode mode = Mode :: VIEW_POINT_ORIENTED);
static BillBoard * create (const std :: string & filename, const Rect & rect, Mode mode = Mode :: VIEW_POINT_ORIENTED);
static BillBoard * createWithTexture (Texture2D * texture, Mode mode = Mode :: VIEW_POINT_ORIENTED);
Mode is BillBoard facing mode, currently supports two faces, one is facing the camera's origin (the default mode), and the other one is facing the camera XOY plane, as follows:

enum class Mode
{
VIEW_POINT_ORIENTED, // orient to the camera
VIEW_PLANE_ORIENTED // orient to the XOY plane of camera
};
```
Cocos2d-x from the BillBoard increase in the Renderer class to introduce a transparent
render queue, in order to ensure proper rendering of transparent objects, the queue
after the other rendering render queue, and the queue at the specified Order values ​​
are sorted in descending . In BillBoard's rendering, BillBoard passed to clear the
queue itself -Z value in the camera coordinate system (farther away from the camera
body The higher the value) size, and then be able to achieve the correct rendering
of BillBoard's. If you need a custom rendering of transparent objects can consider
using the queue, the queue to add way as follows:

_quadCommand.init (_zDepthInView, _texture-> getName (), getGLProgramState (), _blendFunc, & _quad, 1, _billboardTransform);
renderer-> addCommandToTransparentQueue (& _ quadCommand);
BillBoard more details see the use of the methods and examples of BillBoardTest
with cpptests


### Coordinate transformation
`Camera` provide helpers to transform coordinates from screen space to world
space. Example:
```cpp
void unproject (const Size & viewport, Vec3 * src, Vec3 * dst) const;
```
Here viewport is _viewport size_, use `src` as screen coordinates, the z axis of
the `src` indicates clipping plane distance information, -1 means the near
clipping plane, 1 means far clipping plane. The `dst` parameter will return
world space coordinates.


 ## Ray
`Ray` is super useful in 3D game. You can use `Ray` to achieve things like picking up
an object in 3D or detect collision in 3D.

Illustration:

![](3d-img/Ray.png)

### Creating a Ray

You need two vectors to create a `Ray`, one is the origin, the other is the
direction. Example:
```cpp
Ray ray (Vec3 (0,0,0), Vec3 (0,0,1));
```
This will create a `Ray` originated from (0,0,0) in the direction of the positive
Z axis.

With this `Ray`, you can call the function with space intersects AABB box or any
box OBB collision, the code is as follows:
```cpp
Ray ray (Vec3 (0,0,0), Vec3 (0,0,1));
AABB aabb (Vec (-1, -1, -1), Vec (1,1,1));
if (ray .intersects (aabb))
{
	// ray intersects with AABB
}
else
{
	// ray does not intersect with the AABB
}
```

## AABB
`AABB` mean axis aligned bounding box, a 3D AABB is a simple six-sided, each side
is parallel to a coordinate plane. It would look like this:

![](3d-img/AABB.png)

AABB properties:

Two vertices is particularly important: Pmin = [Xmin Ymin Zmin], Pmax = [Xmax Ymax Zmax].
Other points on the box are met

Xmin <= X <= Xmax Ymin <= Y <= Ymax Zmin <= Z <= Zmax

### AABB use
`AABB` is usually used in the game to do some non-precision collision detection,
AABB concept without direction, only Pmin and Pmax points, you can build an AABB
box through these two points, the code is as follows:
```cpp
AABB aabb (Vec (-1, -1, -1), Vec (1,1,1));
```
If you want to detect whether two AABB collision can call
bool intersects (const AABB & aabb) const function, for example, we create two
AABB bounding box collision detection and then the code is as follows:

AABB a (Vec (-1, -1, -1), Vec (1,1,1)); AABB b (Vec (0,0,0), Vec (2,2,2));
if (a .intersect (b)) {// collision} else {// not collide}

AABB collision detection is done with two points Pmin and Pmax compare AABB
collision detection so fast.

In addition, citing several AABB commonly used functions, as follows:
```cpp
void getCorners (Vec3 * dst) const; // get the world coordinate AABB 8 vertices

bool containPoint (const Vec3 & point) const; // detect whether a point is
contained in a box inside the AABB

void merge (const AABB & box); // merge two AABB box

void updateMinMax (const Vec3 * point, ssize_t num); // update Pmin or Pmax

void transform (const Mat4 & mat); // transform operation on the AABB Box
```
## OBB
`OBB` (Oriented Bounding Box, there is the bounding box) is a close rectangular
object, but the object of the box can be rotated. OBB than AABB bounding sphere
and is closer to the object, can significantly reduce the number of the surrounded
body. It would look like this:

![](3d-img/OBB.png)

### OBB nature

OOBB bounding boxes are directional, we use three mutually perpendicular vectors
to describe the OBB bounding box of the local coordinate system, these three
vectors are _xAxis, _yAxis, _zAxis, with _extents vector to describe the OBB
bounding box in each on the axial length.

### OBB use

You can AABB structure OBB, the code is as follows:
```cpp
AABB aabb (Vec (-1, -1, -1), Vec (1,1,1)); OBB obb ​​(aabb);
```
Or you can directly constructed by eight points

Vec3 a [] = {Vec3 (0,0,0), Vec3 (0,1,0), Vec3 (1,1,0), Vec3 (1,0,0), Vec3 (1,0,1) , Vec3 (1,1,1), Vec3 (0,1,1), Vec3 (0,0,1)}; OBB obb ​​(a, 8);

If you want to detect whether two OBB collision can call
bool intersects (const OBB & aabb) const function,
for example, then we create two OBB collision detection code below

AABB aabbSrc (Vec (-1, -1, -1), Vec (1,1,1)); AABB aabbDes (Vec (0,0,0), Vec (2,2,2)); OBB obbSrc (aabbSrc); OBB obbDes (aabbDes); if (obbSrc.intersect (obbDes)) {// collision} else {// not collide}

In addition, citing several OBB commonly used functions, as follows:

void getCorners (Vec3 * dst) const; // get the world coordinate OBB 8 vertices

bool containPoint (const Vec3 & point) const; // detect whether a point is
contained in a box inside OBB

void transform (const Mat4 & mat); // transform on OBB box

## Mesh
A `Mesh` is an object that can be rendered and includes the _index cache_,
_GLProgram state set_, _texture_, _bone_, _blending equations_, _AABB_ and any
other data you might need. `Mesh` objects are usually built by an internal class
and does not require users to set up and use by the time `Sprite3D` created. For
advanced users and sometimes may not need to import by way of an external model,
but directly to build the model (such as a plane, cube, sphere, etc.) through the
vertex index data for rendering. This time we need to build the appropriate data
independently Mesh and customize rendering Command for custom drawing, it is
necessary to use a separate pair Mesh explained.

### Building a Mesh
Mesh by more create methods can create the Mesh, for example, by the most common
vertex array, normals, texture coordinates, and index the array passed to create
a quadrilateral:
```cpp
std::vector<float> positions;
std::vector<float> normals;
std::vector<float> texs;
Mesh::IndexArray indices;

positions.push_back(-5.0f);positions.push_back(-5.0f);positions.push_back(0.0f);
positions.push_back(5.0f);positions.push_back(-5.0f);positions.push_back(0.0f);
positions.push_back(5.0f);positions.push_back(5.0f);positions.push_back(0.0f);
positions.push_back(-5.0f);positions.push_back(5.0f);positions.push_back(0.0f);

texs.push_back(0.0f);texs.push_back(0.0f);
texs.push_back(1.0f);texs.push_back(0.0f);
texs.push_back(1.0f);texs.push_back(1.0f);
texs.push_back(0.0f);texs.push_back(1.0f);

indices.push_back(0);
indices.push_back(1);
indices.push_back(2);
indices.push_back(0);
indices.push_back(2);
indices.push_back(3);

auto mesh = Mesh::create(positions, normals, texs, indices);
mesh->setTexture("quad.png");
```
How to render the construct Mesh? When all the information is rendered after we
finished building Mesh already have, but also need the appropriate data into the
rendering pipeline to render, so you can consider building a custom class derived
from Node, overloading the Draw method, and building a MeshCommand in the Draw
method and pass relevant data into the Mesh render queue, eventually rendering.
For example custom class Draw method can add the following code:
```cpp
auto programstate = mesh->getGLProgramState();
auto& meshCommand = mesh->getMeshCommand();
GLuint textureID = mesh->getTexture() ? mesh->getTexture()->getName() : 0;
meshCommand.init(_globalZOrder
, textureID
, programstate
, _blend
, mesh->getVertexBuffer()
, mesh->getIndexBuffer()
, mesh->getPrimitiveType()
, mesh->getIndexFormat()
, mesh->getIndexCount()
, transform);
renderer->addCommand(&meshCommand);
```
The results:

![](3d-img/quad.png)
--->
