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

## SQLite
If your needs are more advanced than a simple key/value pair you can evaluate using a database to store and manipulate your game data. __SQLite__ is a very popular and commonly used relational database. You can read more about __SQLite__ on the [__SQLite website__](https://sqlite.org/index.html).

### Setting up SQLite
Download the [__SQLite__](https://sqlite.org/download.html) bundle that works for your needs. There are both _source code_ and _pre-compiled binary_ releases. If you use the _source code_ release you can simply drop __sqlite.h__ and __sqlite.c__ into your source tree and use __include__ to bring in __SQLite__. If you use _pre-compiled binaries_ you will need to add this as part of your _library search paths_.

### Creating a database
There are a few ways to create a new __SQLite__ database. 

#### Shipping a default database
If you download the [__SQLite CLI__](https://sqlite.org/cli.html) you can use the command-line to interact with __SQLite__ and all of it's functionality. If you choose this approach you will need to ship your database with you game as you are not creating it in code. This method allows you to use less _SQL code_ up front, making your coding a bit less. However, you will still need to use _SQL code_ when your game needs to interact with the database.

#### Programatically creating a database
If you don't wish to ship a default/pre-populated database you can always create a new database on the first launch of the game and then check if the database exists on each subsequent launch. This approach means more code. We will cover this approach in the next sections.

### Working with SQLite programatically
There are several working pieces that are needed to interact with any database, not just __SQlite__. Let's take a look at what they are:

  > __a connection to the database:__ You can either maintain a persistent database connection while you game is running or open and close the connection as needed. If you maintain a persistent database connection, if the dataase connection gets lost you will need to handle these type of error and re-connect (this is unlikely with __SQLite__). If you open and close as needed you always have a connection but if multiple parts of your game are doing this at the same time you may experience locking issues or database corruption.
  
  > __a database to work with:__ either ship one with your game or create one programatically on the first launch. In either case you will need to have a database to work with.

  > __populating the database with default values:__ either shipping a pre-populated database with your game or creating the default values on first launch.

  > __checking values from the database:__ reading data from the database to make decisions in your game.

  > __updating the database as values change:__ as values change, storing them for fuure use (as your game dictates)

  > __closing the database connection when it is not in use:__ 

#### 

