# 音乐和音效

你的游戏肯定会需要音乐和音效！Cocos2d-x 提供了一个 __`SimpleAudioEngine`__ 类支持游戏内的音乐和音效。它可以被用来增加背景音乐，控制游戏音效。

`SimpleAudioEngine` 是一个共享的单例对象，你可以在代码中的任何地方通过很简单的方式获取到。以下，我们会尽可能的为你展示它的各种使用方法。先来了解一下支持的文件格式。

支持的音乐格式：

| 平台  |支持的常见文件格式| 备注  |
|-------|-------------------|------|
|Android|mp3, mid, oggg, wav|可以播放android.media.MediaPlayer所支持的所有格式|
|iOS    |aac, caf, mp3, m4a, wav|可以播放AVAudioPlayer所支持的所有格式|
|Windows|mid, mp3, wav| 无|

支持的音效格式：

| 平台  |支持的常见文件格式| 备注  |
|-------|-------------------|------|
|Android| oggg, wav|对wav的支持不完美|
|iOS    | caf, m4a|可以播放Cocos2d-iPhone CocosDesion所支持的所有格式|
|Windows| mid, wav| 无|