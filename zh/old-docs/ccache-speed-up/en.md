#How to use CCache to speed up cocos2d-x android compilation
CCache is a compiler cache for C/C++. It speeds up recompilation by caching the result of previous compilations and detecting when the same compilation is being done again. We can use this tool to speed up cocos2d-x android compilation. My cocos2d-x on android compilation is reduced from 10 minutes to 0.5 minutes by CCache on Macbook Pro Retina with i7 CPU.

The following instructions applied on Mac only.


##Installation
You can use homebrew:

brew install --HEAD ccache
Or install by source:

	git clone https://github.com/jrosdahl/ccache.git
	cd ccache
	./autogen.sh
	./configure
	make
	make install
	cp /usr/local/bin/ccache /usr/bin/
*Note: the default install path is /usr/local/bin, you need to copy ccache to /usr/bin/, otherwise, ndk-build can't find it.*

If bash prompts it can not find autoheader, you need install automake:

	brew install automake
But, if bash complains it can not find brew, you need install one:

	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
make sure ccache can be found in your $PATH, run command:

	ccache
If you can not see the help message, check your installation.


##Configuration for Compilation on Android
To use CCache, you need setup some environment variables:

	vim ~/.bash_profile  
	Add following lines:

	export USE_CCACHE=1
	export NDK_CCACHE=/usr/local/bin/ccache
Then run command:

	ccache -M 10G
This command will set max cache size to 10G, If your mac have a large hard disk, you can set the cache size to 50G.

Then, find your NDK path, if you forget where you put it, try the following command:

which ndk-build
This is the result on my mbp:

	/developer/android/android-ndk-r9b/ndk-build
So my NDK_ROOT is:

/developer/android/android-ndk-r9b
Open file: $NDK_ROOT/build/core/default-build-commands.mk

find the following section，Add ccache as shown:

```
ifneq ($(findstring ccc-analyzer,$(CC)),)
TARGET_CC       = $(CC)
else
TARGET_CC       = ccache $(TOOLCHAIN_PREFIX)gcc    #Add ccache support
endif
TARGET_CFLAGS   =
TARGET_CONLYFLAGS =
ifneq ($(findstring c++-analyzer,$(CXX)),)
TARGET_CXX      = $(CXX)
else
TARGET_CXX      = ccache $(TOOLCHAIN_PREFIX)g++ #Add ccache support
endif
TARGET_CXXFLAGS = $(TARGET_CFLAGS) -fno-exceptions -fno-rtti
```
##Build Cocos2d-x Games
Switch to cocos2d-x root path, run:

	python build/android-build.py -p 10 cpp-tests 
Open another bash window, run:

	ccache -s
this command will print the ccache statistics,

    cache directory                     /Users/heliclei/.ccache
    primary config                      /Users/heliclei/.ccache/ccache.conf
    secondary config      (readonly)    /usr/local/etc/ccache.conf
    cache hit (direct)                 13588
    cache hit (preprocessed)           11145
    cache miss                          696
    called for link                        1
    called for preprocessing              14
    preprocessor error                     1
    can't use precompiled header        129
    no input file                          5
    files in cache                     32222
    cache size                           5.4 GB
    max cache size                      30.0 GB
If both cache hit & cache size are 0, that means ccache doesn't work, you need check your configuration.

##Applying on Xcode
Setting up Xcode(5.1) to use CCache is a bit trickier. I almost figured it out but failed to have any compilation speed up. If someone can have a more step on this, please let me know.

Firstly, you need add two user-defined macros to cocos2d_libs build settings

```
CC=$(SOURCE_ROOT)/../tools/xcode_ccache_wrapper
LDPLUSPLUS=$(DT_TOOLCHAIN_DIR)/usr/bin/clang++
```
then, you need create the script named xcode_ccache_wrapper under $(COCOS2dX_ROOT)/tools/:

```
#!/bin/bash
export CCACHE_CPP2=yes
export CCACHE_LOGFILE=~/Desktop/ccache.log
exec /usr/local/bin/ccache /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Qunused-arguments "$@"
```
setup completed, then build your project in xcode.
You can open ccache.log to check how ccache working.
But the problem is, xcode compile seems even slower with CCache on my MBP. Maybe it will work on other scenarios, so I leave this section here, wish someone else could figure out a better solution.