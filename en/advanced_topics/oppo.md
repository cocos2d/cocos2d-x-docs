## Optimizations for OPPO devices

__Cocos2d-x__ has a few optimizations for __OPPO__ devices. These optimizations will only work on __OPPO__ devices. 

### OPPO API reference
The __public__ API calls specific to __OPPO__ device are defined as:

```cpp
class CC_DLL DataManager
{
public:
    static void setProcessID(int pid);
    static void setFrameSize(int width, int height);
    static void onSceneLoaderBegin();
    static void onSceneLoaderEnd();
    static void onShaderLoaderBegin();
    static void onShaderLoaderEnd();
};
```
>  __DataManager::setProcessID();__ - 

>  __DataManager::setFrameSize();__ - sets a buffer size of __width * height__.

>  __DataManager::onSceneLoaderBegin();__ - if called when a `Scene` is loaded, the OPPO device may provide more resources to the app. This depends upon the devices capabilities.

>  __DataManager::onSceneLoaderEnd();__ - if called when a `Scene` is ending, the OPPO device may provide more resources to the app. This depends upon the devices capabilities.

>  __DataManager::onShaderLoaderBegin();__ - if called when a `Shader` is loaded, the OPPO device may provide more resources to the app. This depends upon the devices capabilities.

>  __DataManager::onShaderLoaderEnd();__ - if called when a `Shader` is ending, the OPPO device may provide more resources to the app. This depends upon the devices capabilities.

