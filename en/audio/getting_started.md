## Getting Started
Your game will surely need sound! Cocos2d-x provides an audio engine called
`SimpleAudioEngine`. It can be used to play background music as well as sound effects through out your game play. `SimpleAudioEngine` is a shared singleton object so you can simple call it from anywhere in your code. When creating a sample __HelloWorld__ project we do all the setup required for you, out of the box.

### Supported music formats

| Platform | Supported File Formats | Notes |
| ------- | ------------------- | ------ |
| Android | .mp3, .mid, .ogg, .wav | All formats supported by __android.media.MediaPlayer__ can be played |
| iOS | .aac, .caf, .mp3, .m4a, .wav | All formats supported by __AVAudioPlayer__ can be played |
| Windows | .mid, .mp3, .wav | none |

### Supported audio formats:

| Platform | Common Supported File Formats | Notes |
| ------- | ------------------- | ------ |
| Android | .ogg, .wav | Wav support is not perfect |
| iOS | .caf, .m4a | Can play all formats supported by Cocos2d-iPhone CocosDesion |
| Windows | .mid, .wav | none |
