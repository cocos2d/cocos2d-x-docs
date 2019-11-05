## Linux

### FMOD issues
Some users report issues with __libfmod__. If you encounter issues, please reference this post: [Error while building for linux: libfmod.so.6](https://discuss.cocos2d-x.org/t/error-while-building-for-linux-libfmod-so-6/26553/31?u=doyoque)

### CMake PIE
It may be necessary to add the following line to __CMakeLists.txt__ if a __can not be used when making a PIE object;__ compiler is thrown:
```sh
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -no-pie -fexceptions -std=c++11 -Wno-deprecated-declarations -Wno-reorder")
```