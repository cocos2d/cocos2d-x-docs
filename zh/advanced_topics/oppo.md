## 给 OPPO 手机做的优化

 > 该优化代码只在 __Cocos2d-x 3.17.2__ 及以上的版本起效，并且目前只在 __OPPO Reno__ 有效果。

 ### 具体优化方案

引擎内部在两个地方添加了优化代码：

- 场景加载
- 编译引擎内置的 shader 脚本

场景加载指的是从 `Scene` 创建到 `Scene::onEnter()` 被调用这段时间，所以加载资源的代码要放在 `Scene::onEnter()` 前，且需要在 `Scene` 创建后马上进行资源加载。

### 手动调用优化代码

程序比引擎更清楚什么时机需要更多的 CPU、GPU 资源，因此程序代码可以在需要更多资源的地方手动掉优化代码。可以在 C++ 或 Java 调用优化代码：

C++ 的调用方式

```c++
// 场景加载开始，需要更多的资源
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    DataManager::onSceneLoaderBegin();
#end if

// 场景加载结束
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    DataManager::onSceneLoaderEnd();
#end if

// 开始编译 shader 脚本
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    DataManager::onShaderLoaderBegin();
#end if

// 结束编译 shader 脚本
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    DataManager::onShaderLoaderEnd();
#end if
```

Java 的调用方式

```Java
Cocos2dxDataManager::setOptimise(String thing, float value);
```

| thing | 1 | 0 |
| ----  | -- | -- |
| load_scene| 开始加载场景 | 结束加载场景 |
| shader_compile | 开始编译 shader 脚本 | 结束编译 shader 脚本 |

V3.17.2 版本后，`value` 的类型由 `float` 变成了 `string`，这样就更灵活了。

