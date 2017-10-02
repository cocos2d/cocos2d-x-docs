#声音和音效

Cocos2d-x提供了对声音和音效的支持，能够十分方便地实现音乐与音效的播放,暂停和循环功能。

##使用音效引擎

我们可以使用Cocos2d-x自带的CocosDension库来使用声音引擎。CocosDesion实现了简单易用的SimpleAudioEngine类，为了使用它，我们只需引入他的头文件即可：

```
#include "SimpleAudioEngine.h"
```

##支持平台与格式

CocosDesion支持的音乐格式如下：

| 平台  |支持的常见文件格式| 备注  |
|-------|-------------------|------|
|Android|mp3, mid, oggg, wav|可以播放android.media.MediaPlayer所支持的所有格式|
|iOS    |aac, caf, mp3, m4a, wav|可以播放AVAudioPlayer所支持的所有格式|
|Windows|mid, mp3, wav| 无|

CocosDesion支持的音效格式如下：

| 平台  |支持的常见文件格式| 备注  |
|-------|-------------------|------|
|Android| oggg, wav|对wav的支持不完美|
|iOS    | caf, m4a|可以播放Cocos2d-iPhone CocosDesion所支持的所有格式|
|Windows| mid, wav| 无|

###预加载

加载音乐和音效通常是个耗时间的过程，因此为了防止由加载产生的延时导致实际播放与游戏播放不协调的现象。在播放音效和音乐前，需要预加载音乐文件。

通常我们会在进入场景前调用以下两个方法来预加载文件：

```
void SimpleAudioEngine::preloadBackgroundMusic(const char* pszFilePath);

void SimpleAudioEngine::preloadEffect(const char* pszFilePath);
```

因为SimpleAudioEngine与许多Cocos2d-x的部件一样，是一个单例类。所以当我们使用以上两个接口时，可以使用以下代码访问其实例：

```
SimpleAudioEngine::getInstance()->preloadBackgroundMusic( MUSIC_FILE );

SimpleAudioEngine::getInstance()->preloadEffect( EFFECT_FILE );
```

###播放与停止

音频引擎提供了播放与停止的接口，以下介绍相应接口和使用方法：

```
virtual void playBackgroundMusic(const char* pszFilePath, bool bLoop = false); //播放背景音乐，bLoop表示是否要循环播放
virtual unsigned int playEffect(const char* pszFilePath, bool bLoop = false,
                                    float pitch = 1.0f, float pan = 0.0f, float gain = 1.0f); //播放音效，bLoop表示是否要循环播放
virtual void stopBackgroundMusic(bool bReleaseData = false); //停止背景音乐
virtual void stopEffect(unsigned int nSoundId); //停止指定音效，nSoundId为音效编号
virtual void stopAllEffects(); //停止所有音效
```

使用方法：

```
SimpleAudioEngine::getInstance()->playBackgroundMusic(MUSIC_FILE, true); //播放背景音乐
SimpleAudioEngine::getInstance()->stopBackgroundMusic(); //停止背景音乐
SimpleAudioEngine::getInstance()->stopEffect(_soundId); //停止音效
```

###暂停和恢复

当游戏进入后台时，通常需要暂停播放音乐，当游戏恢复前台运行时，再继续播放音乐。以下介绍几个相关接口以及用法：

```
virtual void pauseBackgroundMusic(); //暂停背景音乐
virtual void pauseEffect(unsigned int nSoundId); //暂停指定音效，nSoundId为音效编号
virtual void pauseAllEffects(); //暂停所以音效
virtual void resumeBackgroundMusic(); //恢复背景音乐
virtual void resumeEffect(unsigned int nSoundId); //恢复指定音效，nSoundId为音效编号
virtual void resumeAllEffects(); //恢复所有音效
```

使用方法：

```
SimpleAudioEngine::getInstance()->pauseEffect(_soundId); //暂停编号为_soundId的音效
SimpleAudioEngine::getInstance()->resumeEffect(_soundId); //恢复编号为_soundId的音效
SimpleAudioEngine::getInstance()->pauseAllEffects(); //暂停所有音效
SimpleAudioEngine::getInstance()->resumeAllEffects(); //恢复所有音效
```

###其他成员

除了以上介绍的方法外，Cocos2d-x还提供了便捷的控制方法与属性：

```
virtual void setBackgroundMusicVolume(float volume); //设置背景音乐音量
virtual void setEffectsVolume(float volume); //设置音效音量
virtual void rewindBackgroundMusic(); //重新播放背景音乐
virtual bool isBackgroundMusicPlaying(); //返回一个值，表示是否在播放背景音乐
```