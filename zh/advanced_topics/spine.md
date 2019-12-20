# 升级 Spine 


### 参考步骤

从官方仓库克隆 spine-runtime 源码

```bash
git clone https://github.com/EsotericSoftware/spine-runtimes.git
cd spine-runtimes
git checkout 3.8
```

移除 Cocos2d-x 中现有的 `spine` 源码 

```bash
rm -rf cocos2d-x/cocos/editor-support/spine/*
```

拷贝最新的`spine` 源码

```bash
cp spine-runtimes/spine-cpp/spine-cpp/include/spine/* \
    cocos2d-x/cocos/editor-support/spine/
cp spine-runtimes/spine-cpp/spine-cpp/src/spine/* \
    cocos2d-x/cocos/editor-support/spine/
cp -r spine-runtimes/spine-cocos2dx/src/spine/* \
    cocos2d-x/cocos/editor-support/spine/
```

编辑 `cocos2d-x/cocos/editor-support/spine/CMakeLists.txt`

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

完成上述步骤后就可以尝试编译了. 