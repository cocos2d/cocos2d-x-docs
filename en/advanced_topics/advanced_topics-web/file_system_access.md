# File System Access

In fact you can use functions in `stdio.h` to access files. But it is not convenient because of:

* You need to invoke system specific API to get full path of a file.
* Resources are packed into .apk file on Android after installing.
* Want to load a resource(such as a picture) based on resolution automatically.

`FileUtils` is created to resolve these issues.

## FileUtils

FileUitls is a helper class to access files under `Resources`. Of course, now it addes more functions for other purpose. I will mention it in followling.

Funtions in `FileUtils` can be devided into three categaries:

* functions to read data from a file, such as `getDataFromFile()`
* functions to manage a file, such as `isFileExist()`
* others

### How to find a file

By default engine will find files from `Resources` unless you pass an absolute file path. Of course, you can use `setSearchPaths` and `addSearchPath` to add more search paths and change the search sequence.

Suppose there is a file named `picture.png` in `Resources`. Then you can create a Sprite like this:

```c++
auto sprite = Sprite::create("picture.png");
``` 

In order to do multi-resolution adaption, application may use more than one resolution resources. Suppose there is two resolution resources, and the folder structure looks like:

```
--Resources
       |
       --iphone
       |    |
       |    --picture.png
       |    ...
       |
       --ipad
          |
          --picture.png 
          ...   
```

And you want to use correct resources based on resolution. For example, you want to use resources in `ipad` on iPad and use resources in `iphone` on iPhone. Then you can use `FileUtils::setSearchPath()` to set search paths. Engine will search a file according the search paths set by `FileUtils::setSearchPath()`, and the search sequence is the same as the sequence setted:

```c++
vector<std::string> searchPaths;

if device is ipad:
    searchPaths.push_back("ipad");
if device is iphone:
    searchPaths.pushback("iphone");
    
FileUtils::getInstance()->setSearchPaths(searchPaths);
```

If search paths are set, and you want to add more search paths dynamically, you can do it like this:

```c++
FileUitls::getInstance()->addSearchPath("mySearchPath");
```

### Functions to read file content

There are some functions to read data from a file. These functions will read different type of files and will return different data types:

```
| function name          | return type          | support path type               |
| getStringFromFile      | std::string          | relative path and absolute path |
| getDataFromFile        | cocos2d::Data        | relative path and absolute path |
| getFileDataFromZip     | unsigned char*       | absolute path                   |
| getValueMapFromFile    | cocos2d::ValueMap    | relative path and absolute path |
| getValueVectorFromFile | cocos2d::ValueVector | relative path and absolute path |
```

### Functions to manage files or deirectories

There are some functions to manage a file or a directory:

```
| function name         | support path type               |
| isFileExist           | relative path and absolute path |
| isDirectoryExist      | relative path and absolute path |
| createDirectory       | absolute path                   |
| removeDirectory       | absolute path                   |
| removeFile            | absolute path                   |
| renameFile            | absolute path                   |
| getFileSize           | relative path and absolute path |
```