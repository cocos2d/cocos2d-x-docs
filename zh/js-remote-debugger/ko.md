파이어폭스로 자바스크립트 원격 디버깅하기
======================================

Cocos2d-x JSB는 2D 게임을 만들기에 좋은 방법입니다. C++로 게임을 개발하는 것보다 쉽게 시간도 절약하며 개발할 수 있습니다. 그러나 3.0 alpha1 버전 이전에는 JSB 프로젝트를 C++처럼 디버그할 수 없었습니다. 그래서 문제가 발생했을 때 마땅히 할 수 있는 일이 없어 대응하기가 쉽지 않았습니다. 그러나 이제 편안하고 효과적으로 JSB 프로젝트를 C++처럼 디버깅할 수 있는 해결책을 소개하려고 합니다.

### 필요사항

* Cocos2d-x 버전 3.0 alpha1
* Firefox 버전 24 이상

**디버깅 환경** (다른 환경에서도 동작할 수 있습니다.)

* Mac OS X 10.9
* Xcode 5.02

### 준비

1. Firefox를 실행하고 주소창에 **about:config**를 입력해서 몇개의 옵션을 수정합니다.

2. 다음과 같이 옵션을 수정해주세요:

 설정 이름                       | 상태        | 유형    | 값 
---------------------------------|-------------|---------|----------
devtools.debugger.remote-enabled | 사용자 설정 | 불린값  | true
devtools.debugger.remote-host    | 사용자 설정 | 문자열  | 127.0.0.1
devtools.debugger.remote-port    | 사용자 설정 | 문자열  | 5086

### 프로젝트 코드 수정하기

JSB 프로젝트를 디버깅하기 전에 당신의 프로젝트에 다음 함수가 유효한지 확인해봐야 합니다. **AppDelegate.cpp**의 코드를 살펴봅시다:

```
bool AppDelegate::applicationDidFinishLaunching()
{
    ...
    
    ScriptingCore* sc = ScriptingCore::getInstance();
    sc->addRegisterCallback(register_all_cocos2dx);
    sc->addRegisterCallback(register_all_cocos2dx_extension);
    sc->addRegisterCallback(register_cocos2dx_js_extensions);
    sc->addRegisterCallback(jsb_register_chipmunk);
    sc->addRegisterCallback(register_all_cocos2dx_extension_manual);
    sc->addRegisterCallback(register_CCBuilderReader);
    sc->addRegisterCallback(jsb_register_system);
    sc->addRegisterCallback(JSB_register_opengl);
    
    sc->start();
    
    // 이 코드를 여기에 추가해주세요.
#if defined(COCOS2D_DEBUG) && (COCOS2D_DEBUG > 0)
    sc->enableDebugger();   // Enable debugger here
#endif

   ...
}
```

### JSB 원격 디버거 확인하기

원격 디버거를 제대로 사용하기 위해서는 앞으로 3단계의 절차를 거쳐야합니다. 이 디버깅 메소드는 파이어폭스의 웹 개발 도구에 기반합니다. 그러므로 당신의 프로젝트를 파이어폭스에 연결해야 합니다.

#### 프로젝트 실행하기

먼저 Xcode에서 당신의 프로젝트를 실행합니다. 그러면 이제 파이어폭스에 프로젝트를 연결할 수 있게 됩니다. 여기서는 샘플로서 **WatermelonWithMe** 를 통해서 JSB 프로젝트를 디버깅하는 방법을 보여드리겠습니다. 프로젝트의 **cocos2d-x-3.0alpha1/build/cocos2d_samples.xcodeproj** 경로 상에 위치한 파일을 엽니다. 그러면 다음과 같이 프로젝트를 선택해서 실행합니다.

![selectedProject.png](res/selectedProject.png)

![runningProject.png](res/runningProject.png)


#### 파이어폭스와 프로젝트 연결하기

Xcode에서 프로젝트를 실행했다면 파이어폭스와 연결하기 위해서 **도구(Tools) > 웹 개발 도구 > 연결...**을 선택합니다.

![selectOption.png](res/selectOption.png)

그러면 다음과 같은 화면을 확인하실 수 있습니다:

![selectConnect.png](res/selectConnect.png)

**연결(Connect)**를 클릭하시고 **Hello Cocos2d-X JSB**를 선택합니다.

![connecting.png](res/connecting.png)

![chooseProject.png](res/chooseProject.png)

이제 당신의 JSB 프로젝트를 디버거를 통해 디버깅할 수 있습니다. 

![debugger.png](res/debugger.png)

### 프로젝트 디버그하기

JSB 프로젝트를 디버그하기 위한 중단점(Breakpoints)과 스텝오버(Step Over)의 두가지 방법이 있습니다.

#### 중단점 설정하기

디버그를 진행할 js 파일을 선택하고 C++을 사용할 때처럼 중단점을 설정합니다. **F8**을 누르면 디버그가 시작되고 변수(Variables)와 인수(Argumnets)에 대한 정보를 볼 수 있습니다:

![breakpoint.png](res/breakpoint.png)

#### 스텝오버 사용하기

때때로 문제점을 찾기 위해서 루프나 메소드를 건너뛸 필요가 있습니다. 그럴 때는 **스텝오버(Step Over)** 디버깅을 사용하면 됩니다. 다행히도 JSB 원격 디버거는 함수를 제공하기 때문에 쉽게 버그를 찾을 수 있습니다.

![stepover.png](res/stepover.png)

#### 스텝인(Step In)에 관해서

원격 디버거에서 **스텝인**을 지원하지는 않습니다. 그러나 루프나 메소드에서 중단점을 사용하면 원하는 결과를 얻을 수 있습니다.
