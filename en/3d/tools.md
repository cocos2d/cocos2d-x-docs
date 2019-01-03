## 3D Software Packages

### 3D Editors
3D editors are collections of tools that you use to build your 3D graphics. There
are both commercial and free tools available. These are the most popular editors:

* [Blender (Free)](http://www.blender.org/)
* [3DS Max](http://www.autodesk.com/products/3ds-max/overview)
* [Cinema4D](http://www.maxon.net/products/)
* [Maya](http://www.autodesk.com/products/maya/overview)

Most 3D editors usually save files in a common collection of formats for easy
use within other editors as well as a standard way for game engines to import
your files for use.

### Cocos2d-x Provided Tools
Cocos2d-x provides tools to help with converting your 3D models to formats that
Cocos2d-x uses to provide access to all aspects of your 3D files.

#### fbx-conv command-line tool
__fbx-conv__ allows the conversion of an FBX file into the Cocos2d-x proprietary
formats. FBX is the most popular 3D file format and is being supported by all
the major editors. __fbx-conv__ exports to __.c3b__ by default. It is simple to use
with just a few parameters:

```sh
fbx-conv [-a|-b|-t] FBXFile
```

The possible switches are:

* -?: show help
* -a: export both text and binary format
* -b: export binary format
* -t: export text format

Example:

```sh
fbx-conv -a boss.FBX
```

There are a few things to note about __fbx-conv__:
* The model needs to have a material that contains at least one texture
* it only supports skeletal animation.
* it only supports one skeleton object no multiple skeleton support yet.
* You can create a 3d scene by exporting multiple static model
* The maximum amount of vertices or indices a mesh is 32767

## 3D File Formats
Cocos2d-x currently supports two 3d file formats:

* [Wavefront Object](http:////en.wikipedia.org/wiki/Wavefront_.obj_file) files:
__.obj__ files
* Cocos2d-x 3d ad-hoc format:__c3t__, __c3b__ files.

The __Wavefront__ file format is supported because it has been widely adopted by
3D editors and it is extremely easy to parse. It is, however, limited and
doesn't support advanced features like animations.

On the other hand, __c3t__ and __c3b__ are Cocos2d-x proprietary file formats that
were created to allow animations, materials and other advanced 3d features.
The suffix __t__ means __text__, while the suffix __b__ means __binary__. Developers
must use __c3b__ for production because it is more efficient. In case you want to
debug the file and track its changes in Git or any other version control system,
you should __c3t__ instead. Also, `Animation3D` objects can be created with __c3b__
or __c3t__ files as it is not possible to animate __obj__ files.
