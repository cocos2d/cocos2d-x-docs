# cocos 命令

Cocos2d-x 带有一个命令行工具：__`cocos`__ 这是一个跨平台的工具，你可以用它创建项目、运行项目、发布项目。命令行工具适用于所有 Cocos2d-x 支持的平台，包括：iOS、Android、Mac、Linux、Windows、Web。不用 IDE，只用命令行，你就能完成所有的工作！

## 工具配置

运行引擎源码根目录的 _setup.py_，这个脚本会配置一些环境变量，并将 cocos 命令添加到系统路径中。注意运行本脚本需要系统安装 2.x（不是 3.x）版本的 Python。

```sh
# Option 1
> ./setup.py

# Option 2
> python setup.py
```

在 macOS 系统为了确保字符编码格式的正确，最好在 _~/.bash_profile_ 文件中增加下面两行：

```sh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

修改之后，记得执行 _source ~/.bash_profile_ 或着重启终端，这样新增的环境变量才会生效。

### 测试

为了确保 cocos 命令行工具已经添加到环境变量，可以正常使用。请先运行 `cocos -v`：

```sh
> cocos -v
Python 2.7.10
cocos2d-x-3.16
Cocos Console 2.3
```

如果有类似上面的输出，就证明了已经配置好，如果提示找不到命令，就需要检查一下环境变量是否设置正确。如果有配置，试着运行一下 _source ~/.bash_profile_ 使配置文件生效。

_命令行工具在这个目录 _cocos2d-x-3.16/tools/cocos2d-console/bin_

### 项目创建

使用 __`cocos new`__ 命令创建新项目，命令格式如下：

```sh
cocos new <game name> -p <package identifier> -l <language> -d <location>
```

示例：

```sh
cocos new MyGame -p com.MyCompany.MyGame -l cpp -d ~/MyCompany

cocos new MyGame -p com.MyCompany.MyGame -l lua -d ~/MyCompany

cocos new MyGame -p com.MyCompany.MyGame -l js -d ~/MyCompany
```

上面的几个例子，项目都是使用的 Cocos2d-x 的源码，编译的时候会将源码也编译，可能花费较长时间。为获得更快的编译速度，可以使用预编译库。使用时需要在创建项目的时候增加参数 _-t binary_。示例：

```sh
cocos new MyGame -p com.MyCompany.MyGame -l cpp -d ~/MyCompany -t binary
```

生成预编译库的方法，在 [预编译库](./prebuilt_libraries.md) 章节。

使用命令 `cocos new --help` 可以查看到更多关于项目创建的帮助信息。

## 项目编译

我们都知道，程序从源码到二进制程序，有一个编译环节。我们来看下 Cocos2d-x 是如何编译项目的，命令格式如下：

```sh
cocos compile -s <path to your project> -p <platform> -m <mode> -o <output directory>
```

示例：

```sh
cocos compile -s ~/MyCompany/MyGame -p ios -m release -o ~/MyCompany/MyGame/bin

cocos compile -s ~/MyCompany/MyGame -p android -m release -o ~/MyCompany/MyGame/bin

cocos compile -s c:\MyCompany\MyGame -p win32 -m release -o c:\MyCompany\MyGame\bin
```

这里的参数有点多，让我们来一个一个说，_-p_ 是编译的平台，_-m_ 是模式：debug 或者 release。如果没指定模式，默认 debug。此外 -s 和 -o 参数是可选的，如果操作命令的当前路径就是工程的路径，那这两个参数都可以省掉。比如已经在 _~/MyCompany/MyGame_ 目录，那编译命令可以简化为：

```sh
cocos compile . -p ios -m release
```

你也可以增加一个可选的参数 _-q_，这样执行静默操作，控制台的输出信息会比较少。示例：

```sh
cocos compile -q -s ~/MyCompany/MyGame -p ios -m release -o ~/MyCompany/MyGame/bin
```

由于命令行工具支持很多平台，因此还有一些特定平台的参数，使用它们可以进行更多的控制，比如指定 SDK 版本，确定签名信息，添加一些 Lua 相关或专用于 Web 的选项。

使用命令 `cocos compile --help` 可以查看更多关于项目编译的帮助信息。

### Android 项目编译注意事项

命令行工具是很灵活的，对于编译 Android 项目允许开发者使用特定版本的 API。比如你的系统上安装了 Android-22，你想使用它来编译，就在命令行的最后增加参数 _--ap android-api-version_。示例：

```sh
cocos compile -p android --ap android-22
```

你可以在项目的配置中，查看到目标 API 是什么版本。

## 项目运行

创建完项目后，你可以直接从命令行执行运行命令。cocos 会启动你指定平台的程序。命令行格式如下：

```sh
cocos run -s <path to your project> -p <platform>
```

示例:

```sh
cocos run -s ~/MyCompany/MyGame -p ios

cocos run -s ~/MyCompany/MyGame -p android

cocos run -s c:\MyCompany\MyGame -p win32
```

当然，你也可以指定程序以 debug 还是 release 方式运行，默认的方式是 debug。示例：

```sh
cocos run -s ~/MyCompany/MyGame -p ios -m release
```

就好像 `cocos compile` 命令那样，如果你已经在项目目录了，_-s_ 和 _-o_ 参数就不是必须的，这对 `cocos run` 命令也一样。就以上面的为例，如果已经在工程目录，命令可以简化成：

```sh
cocos run . -p ios -m release
```

在运行 _Web_ 程序时，还有可选的参数，允许你指定浏览器，例如指定 Google Chrome：

```sh
cocos run -s ~/MyCompany/MyGame -p web -b /Applications/Google\ Chrome.app

cocos run -s ~/MyCompany/MyGame -p web -b C:\Program Files\Google\Chrome\Application\chrome.exe

cocos run -s ~/MyCompany/MyGame -p web -b /usr/local/bin/chrome
```

你还可以指定 IP 地址和端口，更多关于项目运行的使用帮助，请运行 `cocos run --help` 命令。

## 项目发布

cocos 通过提供一系列项目发布的命令实现了简单的发布机制。这些命令，就像上面介绍的命令一样，通过一些参数指定需要的操作。命令格式如下：

```sh
cocos deploy -s <path to your project> -p <platform> -m <mode>
```

示例：

```sh
cocos deploy -s ~/MyCompany/MyGame -p ios -m release

cocos deploy -s ~/MyCompany/MyGame -p android -m release

cocos deploy -s c:\MyCompany\MyGame -p win32 -m release
```

你可以增加参数 _-q_，执行静默操作，这样控制台的输出信息会比较少。示例：

```sh
cocos deploy -q -s ~/MyCompany/MyGame -p ios -m release
```

运行 `cocos deploy --help`，可以查看更多关于项目发布的帮助信息。
