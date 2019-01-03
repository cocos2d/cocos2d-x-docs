# Tizen Installation and Setup

### Deprecated Document. Cocos2d-x V3.15 or less is the last supported version.

## Environment Requirements
* Windows, macOS or Ubuntu (a relatively recent version should suffice)
* Cocos2d-x v3.11 [https://cocos2d-x.org/download](https://cocos2d-x.org/download)
* Tizen 2.4 Rev3+ SDK [https://developer.tizen.org/development/tools/download](https://developer.tizen.org/development/tools/download)
* Java JDK for your platform (a relatively recent version should suffice)

## Prerequisites
* Download __Cocos2d-x__.
* Download __Tizen installer__.
* Download __Java JDK__ for your platform.

## Installation
* Install __Java JDK__ for your platform. You may or may not need to do this depending upon your current setup.
* Install __Tizen__ using the installer you downloaded. If you haven't downloaded it, please refer to prerequisites above.

  * Double click the __Tizen__ installer that you downloaded and follow the prompts.

    ![](Tizen-img/double_click_installer.png "")

    ![](Tizen-img/ready_to_install.png "")

    ![](Tizen-img/installing.png "")

  * Click the 'Done' button, then when prompted to run the Update Manager, click 'Yes(Y)'.

    ![](Tizen-img/prompt_update_manager.png "")

  * Select __2.4 Mobile__ and click the down-arrow at the right side to install. If you install version 2.4, the resulting TPK could also be installed on Tizen device runs 2.3 version system. The resulting TPK is back compatible for old version devices.

    ![](Tizen-img/updating_update_manager.png "")

  * After completing all steps, you should be able to launc the Tizen IDE 2.4.

    ![](Tizen-img/ide.png "")

## Running the built in tests
Just like with any platform Cocso2d-x supports, you can run our sample tests to understand the engine's functionality.
For c++ you want to look at `cpp-tests` and for Lua, `lua-tests`.

  * Launch the __Tizen IDE__
  * Select __File -> Import__

    ![](Tizen-img/ide-import-1.png "")

  * Under __General__, select __Existing Projects into Workspace__

    ![](Tizen-img/ide-import-2.png "")

  * Browse to where the __Cocos2d-x root__ is. Then select __cpp-tests__ and __libcocos2d-x__ ensuring that the path for both contains __proj.tizen__ as it is possible to import projects for Android, but we don't want to do this.

    ![](Tizen-img/ide-import-3.png "")

  * By default, a project has three configurations __Debug__, __Release__ and __Emulator__. __Debug__ and __Release__ are settings that build for hardware. __Emulator__ is for simulating a hardware device when one is not available. It is always best to test on actual hardware before deploying your app to production.

    To change either __Debug__ or __Release__, right click on the __libcocos2d-x__ project and select __Properties__. When this window opens, select __C/C++ Build -> Tizen Settings__. A few items here need to be changed. Change the properties with the red boxes on the screenshot below.
      * Choose __Mobile 2.4__, __x86__ and __GCC 4.9__ of the toolchain.
      * Then click the __OK__ button.

      ![](Tizen-img/ide-build-1.png "")

    Repeat this same step for the __cpp-tests__ project.

    To build for the __Emulator__, right click on the __libcocos2d-x__ project and select __Build Configurations -> Set Active -> Emulator__

      ![](Tizen-img/ide-build-3.png "")

  * Now, we can build. First, build __libcocos2d-x__. Right click on the __libcocos2d-x__ project and select __Build Project__ or press the __F10__ key.

    ![](Tizen-img/ide-build-2.png "")

  * Repeat this same step for the __cpp-tests__ project.

Once everything is built __cpp-tests__ will run and you can experiment with it's functionality.

  ![](Tizen-img/cpp-tests.png "")

## Compiling & Running with Command-line tool
You also can compile & run your project on Tizen with `cocos` command. There are some arguments for the Tizen platform:
| Argument | Available Value | Description |
| ----|----|----|
| --tizen-arch | x86, arm | Determines the architecture type for the rootstrap. Default is x86. (x86 is for simulators, and arm for devices) |
| --tizen-profile | Path of signing profile | Set the profile path for signing. |
| --tizen-sign | String | Set the profile name to use for signing. |
| --tizen-strip | - | Determines whether to strip the native binary. |

Sample commands:
1. `cocos compile -s PROJECT_PATH -p tizen  -m release --tizen-arch arm --tizen-profile PROFILE_PATH --tizen-sign SIGN_STRING --tizen-strip`

    Compile the project for the ARM architecture. A .tpk file will be generated.

2. `cocos run -s PROJECT_PATH -p tizen --tizen-profile PROFILE_PATH --tizen-sign SIGN_STRING`

    Launch the Tizen simulator and then run the project on the Tizen simulator. (Note: it is important to remember that the Tizen simulator must always be running in-order to run your project.)

## Starting a new project
Once everything above works, you can start a new project! To do this, read our
document on the **[Cocos Command-line tool](../editors_and_tools/cocosCLTool.md)**.
