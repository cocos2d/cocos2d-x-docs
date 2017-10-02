#调度器(scheduler)

##继承关系

![inherent](res/inherent.png)

##原理介绍

Cocos2d-x调度器为游戏提供定时事件和定时调用服务。所有Node对象都知道如何调度和取消调度事件，使用调度器有几个好处：

1. 每当Node不再可见或已从场景中移除时，调度器会停止。
2. Cocos2d-x暂停时，调度器也会停止。当Cocos2d-x重新开始时，调度器也会自动继续启动。
3. Cocos2d-x封装了一个供各种不同平台使用的调度器，使用此调度器你不用关心和跟踪你所设定的定时对象的销毁和停止，以及崩溃的风险。

##基础用法

游戏中我们经常会随时间的变化而做一些逻辑判断，如碰撞检测。为了解决以上问题，我们引入了调度器，这使得游戏能够更好的处理动态事件。Cocos2d-x提供了多种调度机制，在开发中我们通常会用到3种调度器：

1. 默认调度器:`schedulerUpdate()`
2. 自定义调度器:`schedule(SEL_SCHEDULE selector, float interval, unsigned int repeat, float delay)`
3. 单次调度器:`scheduleOnce(SEL_SCHEDULE selector, float delay)`

以下我们来对这3种调度器做简单的介绍。

###默认调度器(schedulerUpdate)

该调度器是使用Node的刷新事件update方法，该方法在每帧绘制之前都会被调用一次。由于每帧之间时间间隔较短，所以每帧刷新一次已足够完成大部分游戏过程中需要的逻辑判断。

Cocos2d-x中Node默认是没有启用update事件的，因此你需要重载update方法来执行自己的逻辑代码。

通过执行schedulerUpdate()调度器每帧执行 update方法，如果需要停止这个调度器，可以使用`unschedulerUpdate()`方法。

以下代码用来测试该调度器：

```
HelloWorldScene.h

void update(float dt) override;
```

```
HelloWorldScene.cpp

bool HelloWorld::init()
{
	...
	scheduleUpdate();
	return true;
}

void HelloWorld::update(float dt)
{
    log("update");
}
```

你会看到控制台不停输出如下信息

```
cocos2d: update
cocos2d: update
cocos2d: update
cocos2d: update
```

###自定义调度器(scheduler)

游戏开发中，在某些情况下我们可能不需要频繁的进行逻辑检测，这样可以提高游戏性能。所以Cocos2d-x还提供了自定义调度器，可以实现以一定的时间间隔连续调用某个函数。

由于引擎的调度机制，自定义时间间隔必须大于两帧的间隔，否则两帧内的多次调用会被合并成一次调用。所以自定义时间间隔应在0.1秒以上。

同样，取消该调度器可以用`unschedule(SEL_SCHEDULE selector, float delay)`。

以下代码用来测试该调度器：

```
HelloWorldScene.h

void updateCustom(float dt);
```

```
HelloWorldScene.cpp

bool HelloWorld::init()
{
	...
	schedule(schedule_selector(HelloWorld::updateCustom), 1.0f, kRepeatForever, 0);
	return true;
}

void HelloWorld::updateCustom(float dt)
{
    log("Custom");
}
```

在控制台你会看到每隔1秒输出以下信息

```
cocos2d: Custom
cocos2d: Custom
cocos2d: Custom
cocos2d: Custom
cocos2d: Custom
```

我们来看下scheduler(SEL_SCHEDULE selector, float interval, unsigned int repeat, float delay)函数里面的参数：

1. 第一个参数selector即为你要添加的事件函数
2. 第二个参数interval为事件触发时间间隔
3. 第三个参数repeat为触发一次事件后还会触发的次数，默认值为kRepeatForever，表示无限触发次数
4. 第四个参数delay表示第一次触发之前的延时

###单次调度器(schedulerOnce)

游戏中某些场合，你只想进行一次逻辑检测，Cocos2d-x同样提供了单次调度器。

该调度器只会触发一次，用`unschedule(SEL_SCHEDULE selector, float delay)`来取消该触发器。

以下代码用来测试该调度器：

```
HelloWorldScene.h

void updateOnce(float dt);
```

```
HelloWorldScene.cpp

bool HelloWorld::init()
{
	...
	scheduleOnce(schedule_selector(HelloWorld::updateOnce), 0.1f);
	return true;
}

void HelloWorld::updateOnce(float dt)
{
    log("Once");
}
```

这次在控制台你只会看到一次输出

```
cocos2d: Once
```