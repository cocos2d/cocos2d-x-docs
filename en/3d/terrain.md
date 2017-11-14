## Terrain
`Terrain` is an important component in 3D game. A texture is used to stand for the
height map. And up to 4 textures can be used to blend the details of the terrain,
grass, road, and so on.

### HeightMap
`HeightMap` objects are the core of the terrain. Different from the common image
the height map represents the height of vertices. It determines the terrain's
geometry shape.

### DetailMap
`DetailMap` objects are a list of textures determining the details of the terrain,
up to four textures can be used.

### AlphaMap
`AlphaMap` objects are an image whose data is the blend weights of __detail maps__.
The blending result is the final terrain's appearance.

### LOD policy
`Terrain` uses an optimization technique called __Level Of Detail__ or __LOD__.
This is a rendering technique that reduces the number of __verticies__ (or triangles)
that are rendered ,for an object,  as its distance from camera increases. Users
can set the distance to the `Camera` by calling the
__Terrain::setLODDistance(float lod1, float lod2, float lod3)__ method.

Neighboring chunks of `Terrain` objects, which have different __LOD__ may cause
 the __crack__ artifacts. `Terrain` provide two functions to avoid them:

{% codetabs name="C++", type="cpp" -%}
Terrain::CrackFixedType::SKIRT

Terrain::CrackFixedType::INCREASE_LOWER
{%- endcodetabs %}

__Terrain::CrackFixedType::SKIRT__ will generate four, skirt-like meshes at each
edge of the chunk.

__Terrain::CrackFixedType::INCREASE_LOWER__ will dynamically adjust each chunks
__indices__ to seamlessly connect them.

### How to create a terrain
Creating a `Terrain` takes a few steps. Example:

The following code snippet is creating a player and place it on the terrain:

{% codetabs name="C++", type="cpp" -%}
auto player = Sprite3D::create("chapter9/orc.c3b");
player->setScale(0.08);
player->setPositionY(terrain->getHeight(player->getPositionX(),player->getPositionZ()));
{%- endcodetabs %}

![](3d-img/9_10.png)

* create all `DetailMap` objects (up to four), you need pass the `DetailMap`
objects to the __Terrain::DetailMap__ struct:

{% codetabs name="C++", type="cpp" -%}
Terrain::DetailMap r("dirt.dds");
Terrain::DetailMap g("grass.dds");
Terrain::DetailMap b("road.dds");
Terrain::DetailMap a("greenSkin.jpg");
{%- endcodetabs %}

* to create a `TerrainData` variable with __detail maps__, you need to specify
the terrain's __height map__ file path and __alpha map__ file path:

{% codetabs name="C++", type="cpp" -%}
Terrain::TerrainData data("chapter9/heightmap16.jpg","TerrainTest/alphamap.png", r, g, b, a);
{%- endcodetabs %}

* pass the `TerrainData` object to __Terrain::create__, the last parameter determines
the LOD policy (as talked about above). Example:

{% codetabs name="C++", type="cpp" -%}
_terrain = Terrain::create(data, Terrain::CrackFixedType::SKIRT);
{%- endcodetabs %}

* If you set a `Terrain` objects __camera mask__ and add it to a `Node` or a
`Scene`, be careful. When `Terrain` is added into a `Node` or a `Scene`, you can
not use __transform(translate, scale)__ on it anymore. If you do this after calling
__addChild()__, some of the terrain's methods may calculate wrong results.

### Get Terrain Height
Use the method __Terrain::getHeight(float x, float z, Vec3 * normal= nullptr)__ to
get the specified position's height. This method is very useful when you want to
put a `Sprite3D` object or any `Node` on the terrain's surface.

### Ray-Terrain intersection test
A __Ray-Terrain__ intersection test will calculate the intersection point by giving
a specified position.

__Terrain::CrackFixedType::SKIRT__ will generate four skirt-like meshes at each
chunks edge.

__Terrain::CrackFixedType::INCREASE_LOWER__ will dynamically adjust each chunks
index to seamlessly connect them.
