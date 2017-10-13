JavaScript Remote Debugging by Firefox
======================================

Cocos2d-x JSB is a good way to build 2d games. It's easier and takes less time than using C++. However, before version 3.0 alpha1 you could not debug JSB project as you could C++. It's annoying that we could do nothing when the issues first appeared. Now, however, we have a solution that allows you to debug JSB projects just like C++, it's convenient and efficient.

### Requirement

* Cocos2d-x Version 3.0 alpha1
* Firefox   Version 24 and above

**Debugging Environment** (This debugging solution is also applicable to other environments)

* Mac OS X 10.9
* Xcode 5.02

### Preparation

1. Open the Firefox and input **about:config** in the address bar in order to change some options.

2. You have to change three options as follow:

Preference Name                  | Status   | Type    | Value 
---------------------------------|----------|---------|-------
devtools.debugger.remote-enabled | user set | boolean | true
devtools.debugger.remote-host    | user set | string  | 127.0.0.1
devtools.debugger.remote-port    | user set | string  | 5086

### Go to your project's code

Before you can debug a JSB project through these means, you have to add some code to your project. Add following lines of code in **AppDelegate.cpp**:

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
    
    // These codes should be added in here
#if defined(COCOS2D_DEBUG) && (COCOS2D_DEBUG > 0)
    sc->enableDebugger();   // Enable debugger here
#endif

   ...
}
```

### Time to check out the JSB remote-debugger

There are three steps you must undertake before achieving your goal. This method is based on Firefox's Web Developer Tools, so you have to connect to your project with Firefox.

#### Run your project

The first thing you have to do is run your project in Xcode. Then you can connect Firefox to it. Here we take **WatermelonWithMe** as example to show you how to debug your JSB project. You can open the project in this path **cocos2d-x-3.0alpha1/build/cocos2d_samples.xcodeproj**, and select the project to run as follow:

![selectedProject.png](res/selectedProject.png)

![runningProject.png](res/runningProject.png)


#### Connect Firefox to your project

As you are running the project in Xcode, connect Firefox to it by selecting **Tools->Web Developer->Connect...**

![selectOption.png](res/selectOption.png)

Then you'll see following:

![selectConnect.png](res/selectConnect.png)

Click **Connect**, and select **Hello Cocos2d-X JSB**

![connecting.png](res/connecting.png)

![chooseProject.png](res/chooseProject.png)

Now you can use the debugger to debug your JSB project. 

![debugger.png](res/debugger.png)

### Debug your Project

There are two ways you can debug your JSB project by these means: by setting BreakPoints and using Step Over.

#### Set Breakpoints

Select the JavaScript file that you are going to debug, then set breakpoints just as you would do with C++. Press **F8** to start debugging, you'll see some information about the variables and arguments as follows:

![breakpoint.png](res/breakpoint.png)

#### Step Over

Sometimes you need to step through a loop or a method in order to find the issue, so in these circumstances you want to use **Step Over**. Luckily JSB remote-debugger provide this functionality, which can help you find bugs easier.

![stepover.png](res/stepover.png)

#### Step In

Although we have yet to implement **Step In**, we can set breakpoints in a loop or method to achieve the same goal.
