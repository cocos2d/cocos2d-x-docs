# Upgrade Spine 


### Steps

Clone source code of `spine-runtimes`

```bash
git clone https://github.com/EsotericSoftware/spine-runtimes.git
cd spine-runtimes
git checkout 3.8
```

Remove spine source code located in `cocos2d-x`

```bash
rm -rf cocos2d-x/cocos/editor-support/spine/*
```

Update to recent spine code

```bash
cp spine-runtimes/spine-cpp/spine-cpp/include/spine/* \
    cocos2d-x/cocos/editor-support/spine/
cp spine-runtimes/spine-cpp/spine-cpp/src/spine/* \
    cocos2d-x/cocos/editor-support/spine/
cp -r spine-runtimes/spine-cocos2dx/src/spine/* \
    cocos2d-x/cocos/editor-support/spine/
```

Edit `cocos2d-x/cocos/editor-support/spine/CMakeLists.txt`

```cmake
file(GLOB_RECURSE COCOS_SPINE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/*.cpp
    ${CMAKE_CURRENT_LIST_DIR}/**/*.cpp
)

file(GLOB_RECURSE COCOS_SPINE_HEADER
    ${CMAKE_CURRENT_LIST_DIR}/*.h
    ${CMAKE_CURRENT_LIST_DIR}/**/*.h
)
```

