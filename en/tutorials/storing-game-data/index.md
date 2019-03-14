# Storing Game Data
In most every game there are probably items that need to be stored and re-read in again between game play. This could be player information, stats, leaderboards, level progress and so much more. As always there are many ways a developer can choose to store this data. Each approach has advantages and disadvantages. In this tutorial we will explore storing game data with `UserDefault` and `SQLite`.

## UserDefault
`UserDefault` is simple __key/value pair__ data structure. It is a __global singleton__ that can be accessed at any time, much like the __Director__. `UserDefault` is always present, even if you never invoke it. It is just empty. The first time you add a __key/value pair__ an instance is created.

### Accessing UserDefault
Accessing `UserDefault` is as simple as:

```cpp
cocos2d::UserDefault::getInstance()->someFunction();
```

However, if you plan to access `UserDefault` more than once, it is best to grab the instance once and then use it versus accessing it each and every time you need it. Example:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setIntegerForKey("score", 10);
```

### Adding values to UserDefault
Adding __key/value pairs__ to `UserDefault` is easy:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setIntegerForKey("score", 10);
userdefaults->setFloatForKey("some_float", 2.3f);
userdefaults->setDoubleForKey("some_double", 2.4);
userdefaults->setBoolForKey("some_bool", true);
```

### Changing values in UserDefault
It may be necessary to change a __key/value pair__ in `UserDefault`. Perhaps you are storing the players score and it needs to be updated. This is achieved by simply setting the value a second time. Example:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setStringForKey("message", "Hello Again");
```

### Deleting values to UserDefault
Deleting __key/value pairs__ from `UserDefault` is also easy:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->deleteValueForKey("message");
userdefaults->deleteValueForKey("score");
userdefaults->deleteValueForKey("some_float");
userdefaults->deleteValueForKey("some_double");
userdefaults->deleteValueForKey("some_bool");
```

### Resetting UserDefault
If you wish to clear out `UserDefault` completely and start from scratch you can simple call:

```cpp
cocos2d::UserDefault::getInstance()->flush();
```

### Assigning UserDefault value to Labels
You probably will want to use values stored in `UserDefault` and assign them to `Label` objects for the players to see. You can achieve this with just a few lines of code. Example:

```cpp
char strTemp[256] = "";
    
std::string ret = UserDefault::getInstance()->getStringForKey("message");
sprintf(strTemp, "string is %s", ret.c_str());
some_label->setString(strTemp);
```

