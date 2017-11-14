## Cocos command-line tool

### What is the `cocos` command-line tool?
Cocos2d-x comes with a command-line tool called __cocos__. It is a cross-platform tool that allows you to create new Cocos2d-x applications as well as __run__ them and __deploy__ them. __cocos__ works for all cocos2d-x supported platforms, which include: __ios__, __android__, __mac__, __linux__, __win32__, __wp8_1__, __wp10__ and __web__. You don't need to use an IDE unless you want to. It has many options, so let's go through them grouped by function.

### Setting up `cocos`
it is a good idea to run __<cocos2d-x root>/setup.py__ to properly setup your
__PATH__. Doing so ensures that you can run Cocos2d-x and its related tools. Example:
```sh
# Option 1
> ./setup.py

# Option 2
> python setup.py
```

On macOS, it is also a good idea to add a few lines to your __~/.bash_profile__ to ensure your character encoding is set to __UTF-8__. Example:
```sh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```
After adding these lines, it is necessary to run __source ~/.bash_profile__ or
restart your shell.

### Testing your path for `cocos`
It is necessary for __cocos__ to be in your path or to specify the complete path
to it when using it. An easy test:
```sh
> cocos -v
```

If you see output like __1.2__ you are all set. If you see anything else you need to either add the location to your __PATH__.

On __macOS__ run __source ~/.bash_profile__ after updating your __PATH__ or
specify the full path to __<cocos2d-x root>\tools\cocos2d-console\bin__.

### Creating a new project
To create a new project you use the __cocos new__ command. The command is formatted as:
```sh
cocos new <game name> -p <package identifier> -l <language> -d <location>
```

Examples:
```sh
cocos new MyGame -p com.MyCompany.MyGame -l cpp -d ~/MyCompany

cocos new MyGame -p com.MyCompany.MyGame -l lua -d ~/MyCompany

cocos new MyGame -p com.MyCompany.MyGame -l js -d ~/MyCompany
```

In the above examples, a new project is created using the Cocos2d-x source code.
If you want to create a new project using the pre-built libraries you need to pass an additional flag of __-t binary__. Example:
```sh
cocos new MyGame -p com.MyCompany.MyGame -l cpp -d ~/MyCompany -t binary
```

If you haven't generated the pre-built libraries, please see the section below on doing so.

You can run __cocos new --help__ to see even more options as well as platform
specific options.

### Compiling a project
As you make changes to your code it is necessary to compile it. We all know this
has to happen, let's go through it. The command is formatted as:
```sh
cocos compile -s <path to your project> -p <platform> -m <mode> -o <output directory>
```

Examples:
```sh
cocos compile -s ~/MyCompany/MyGame -p ios -m release -o ~/MyCompany/MyGame/bin

cocos compile -s ~/MyCompany/MyGame -p android -m release -o ~/MyCompany/MyGame/bin

cocos compile -s c:\MyCompany\MyGame -p win32 -m release -o c:\MyCompany\MyGame\bin
```

There is a lot going on here so let's go over the finer points. __-p__ is the __platform__ you are compiling for. __-m__ is mode, __debug__ or __release__ with the default being __debug__ if this parameter is not specified.

Also, it is important to know that the __-s__ and __-o__ parameters are optional as well as long as you are already in your project's working directory. Taking the example above if you are already in __~/MyCompany/MyGame__ then the __cocos compile__ command can be shortened:
```sh
cocos compile . -p ios -m release
```

You can also specify an optional parameter __-q__ for __quiet__. This lessens the output that is outputted to the console. Taking an example from above:
```sh
cocos compile -q -s ~/MyCompany/MyGame -p ios -m release -o ~/MyCompany/MyGame/bin
```

As __cocos__ supports a lot of platforms there are also platform specific options which allow you to fine tune targeting specific SDK versions, signing code, lua options as well as web specific options. You can run __cocos compile --help__ to see all available options broken down by platform.

#### Android compiling could require specifying an API level.
If you are compiling for Android, the __cocos__ command is flexible and allows developers to compile using specific Android API versions. You may have __Android-22__ installed on your system (or any other version). You will want to add __--ap android-api-version__ to the end of the __cocos__ command to specify. Example:
```sh
cocos compile -p android --ap android-22
```
You can always check `project.properties` to see what api-version is being targetted. For more info, please read out [Release Notes](https://github.com/cocos2d/cocos2d-x/blob/v3/docs/RELEASE_NOTES.md#cocos-command-modification).

### Running a project
Once you have created a project you can run it right from the command-line. __cocos__ takes care of launching the environment you specify. The command is formatted as:
```sh
cocos run -s <path to your project> -p <platform>
```

Examples:
```sh
cocos run -s ~/MyCompany/MyGame -p ios

cocos run -s ~/MyCompany/MyGame -p android

cocos run -s c:\MyCompany\MyGame -p win32
```

You can also specify to run in __debug__ or __release__ mode using the optional
__-m__ parameter. Excluding this parameter defaults to __debug__.
```sh
cocos run -s ~/MyCompany/MyGame -p ios -m release
```

As with the __cocos compile__ command above, it is important to know that the
__-s__ and __-o__ parameters are optional as well as long as you are already in your project's working directory. Taking the example above if you are already in
__~/MyCompany/MyGame__ then the __cocos run__ command can be shortened:
```sh
cocos run . -p ios -m release
```

When running for the __web__ there are additional parameters that allow you to
specify what web browser you want to run in. You can also specify ip address and
port. This, again is done via command-line parameters. Examples, specifying
Google Chrome:
```
cocos run -s ~/MyCompany/MyGame -p web -b /Applications/Google\ Chrome.app

cocos run -s ~/MyCompany/MyGame -p web -b C:\Program Files\Google\Chrome\Application\chrome.exe

cocos run -s ~/MyCompany/MyGame -p web -b /usr/local/bin/chrome
```
You can run __cocos run --help__ to see all available options broken down by platform.

### Deploy a project
Once you are ready to ship your game __cocos__ provides an easy mechanism for
deploying it. Just like with the commands above you specify what want to do. The
command is formatted as:
```sh
cocos deploy -s <path to your project> -p <platform> -m <mode>
```

Examples:
```sh
cocos deploy -s ~/MyCompany/MyGame -p ios -m release

cocos deploy -s ~/MyCompany/MyGame -p android -m release

cocos deploy -s c:\MyCompany\MyGame -p win32 -m release
```

You can also specify an optional parameter __-q__ for __quiet__. This reduces the output that is logged to the console. Taking an example from above:
```sh
cocos deploy -q -s ~/MyCompany/MyGame -p ios -m release
```

You can run __cocos deploy --help__ to see all available options broken down by
platform.

### Installing additional plugins
Using the __Cocos Package Manager__ you can easily add additional functionality to your games, __SDKBOX__. There are a variety of commands to assist with this. Examples:

```sh
# list available packages
cocos package list

# show all packages imported into your project
cocos package info

# update installed packages to the latest versions
cocos package update
```

You can run __cocos package --help__ to see all available options broken down by platform.

#### Installing SDKBOX plugins
__SDKBOX__ plugins can be installed using the __Cocos Package Manager__. Example:

```sh
# install a package, in this example, Facebook
cocos package import facebook
```

### Unique command-line options
__cocos__ has a number of unique options you can use to help build your games. To see all of these options, please run __cocos --help__. Let's us talk about these optios.

| Command| Description|
| ----|----|
|__no-apk__| compile without building an apk. |
|__luacompile__| Encrypt the lua scripts in your game. This is invoked once `cocos compile` is invoked with the `-m release` argument. Developers can invoke this manually for encrypting their scripts.|
|__jscompile__| Encrypt the JavaScript scripts in your game. This is invoked once `cocos compile` is invoked with the `-m release` argument. Developers can invoke this manually for encrypting their scripts.|
|__gen-simulator__| The simulator powers the  __preview__ function in Cocos Creator. |
|__gen-templates__| is used for generating the binary templates you can use to get started on a project that uses the __pre-built libraries__. Binary templates are required by Cocos Bundle package and also Cocos Creator.
