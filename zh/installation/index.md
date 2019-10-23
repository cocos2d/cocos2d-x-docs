# 环境搭建

## 简介

阅读本章，你能学习到 Cocos2d-x 在各个平台的环境搭建方法，_环境搭建以成功编译运行官方测试项目 `cpp-tests` 为目标_。

搭建完成，你可以通过 `cpp-tests` 学习引擎的各个功能。

## 环境要求

#### v4.0
---
#### MacOS
* OpenGL
  * 模拟器 - macOS 10.13+, Xcode 10+, CMake 3.1+
  * 真机 - macOS 10.13+, Xcode 10+, CMake 3.1+
* Metal
  * 模拟器 - macOS 10.15+, Xcode 11+, CMake 3.15+
  * 真机 - macOS 10.14+, Xcode 10+, CMake 3.15+
* Python 2.7.5+, __建议 Python 2,7.10__, __而不是 Python 3+__

#### Linux
* Ubuntu 16.04
* CMake 3.1+ (使用 __apt install__ 获取最新版本)
* Python 2.7.5+, __P建议 ython 2,7.10, __而不是 Python 3+__

#### Windows
* Windows 7+
* VS 2017+
* CMake 3.1+
* Python 2.7.5+, __P建议 ython 2,7.10, __而不是 Python 3+__

#### Android
* Python 2.7.5+, __P建议 ython 2,7.10, __而不是 Python 3+__
* NDK r91c+ (使用 r19c 测试过) __在 Android Studio 里叫 **19.2.xx**__
* Android Studio 3.4+(使用 3.0 测试过)
* CMake 3.1+

## 修改历史
* 10/22/1019 - slackmoehrle - 增加 v4 初始化需求