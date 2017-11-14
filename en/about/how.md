## How to contribute to our projects

### Contributing to these docs
We always welcome contributions to our documentation.

  - Fork our [docs repo](https://github.com/cocos2d/cocos2d-x-docs)
  - __en/__ is for English contributions, __zh/__ is for 中文 contributions.
  - code blocks must be wrapped in special code to work correctly:
    - C++ code block:
      ```html
      {% codetabs name="C++", type="cpp" -%}
      auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
      {%- endcodetabs %}
      ```
  - Test your changes using `gitbook build` and `gitbook serve`. Please test in a few web browsers.
  - Submit a *pull request* with your changes and we will review and merge it.

### Contributing to cocos2d-x

#### For general questions
You can ask general questions by using:

  -   Forum (preferred way): http://discuss.cocos2d-x.org/
  -   Weibo: http://t.sina.com.cn/cocos2dx
  -   Twitter: http://www.twitter.com/cocos2dx

#### Reporting bugs
To report bugs, please use the [Issue Tracker](https://github.com/cocos2d/cocos2d-x/issues)

Steps to report a bug:

  - Open the [url](https://github.com/cocos2d/cocos2d-x/issues/new)
  - Add all the needed information to reproduce the bug, the information include
    - engine version
    - steps to reproduce the bug
    - some pseudocode
    - resources link if needed

#### Submitting patches
If you want to contribute code, please follow these steps:

(If you are new to git and/or GitHub, you should read [Pro Git](http://progit.org/book/) , especially the section on [Contributing to a project:Small/Large Public Project](http://progit.org/book/ch5-2.html#public_small_project) )

  -   Download the latest cocos2d-x develop branch from github:
    ```sh
    $ git clone git://github.com/cocos2d/cocos2d-x.git
    $ cd cocos2d-x
    $ git checkout v3
    $ ./download-deps.py
    $ git submodule update --init
    ```
  -   Apply your changes in the recently downloaded repository
  -   Commit your changes in your own repository
  -   Create a new branch with your patch: `$ git checkout -b my_fix_branch`
  -   Push your new branch to your public repository
  -   Send a “pull request” to user “cocos2d”
  -   It must be _complete_. See the definition below
  -   It must follow the _Releases_ rules. See the definition below

#### Only _complete_ patches will be merged
The patch must be _complete_. By that, we mean:

  -   For C++ code follow the [Cocos2d C++ Coding Style](https://github.com/cocos2d/cocos2d-x/blob/v3/docs/CODING_STYLE.md)
  -   For Python code follow the [PEP8 guidelines](https://www.python.org/dev/peps/pep-0008)
  -   Describe what the patch does
  -   Include test cases if applicable
  -   Include unit tests if applicable
  -   Must be tested in all supported platforms. If you don't have access to test your code in all the supported platforms, let us know.
  -   Must NOT degrade the performance
  -   Must NOT break existing tests cases
  -   Must NOT break the Continuous Integration build
  -   Must NOT break backward compatibility
  -   Must compile WITHOUT warnings
  -   New APIs MUST be **easy to use**, **familiar** to cocos2d-x users
  -   Code MUST be **easy to extend** and **maintain**
  -   Must have documentation: C++ APIs must use Doxygen strings, tools must have a README.md file that describe how to use the tool
  -   Must be efficient (fast / low memory needs)
  -   It must not duplicate existing code, unless the new code deprecates the old one
  -   Patches that refactor key components will only be merged in the next major versions.

#### Promoting cocos2d-x
Help us promote cocos2d-x by using the cocos2d-x logo in your game, or by mentioning cocos2d-x in the credits.

#### Spreading the word!
You can help us spread the word about Cocos2d-x! We would surely appreciate it!

  * Talk about us on Facebook! Our [__Facebook Page__](https://www.facebook.com/cocos2dx/)
  * Tweet, Tweet! Our [__Twitter__](https://twitter.com/cocos2dx)
  * Read our [__Blog__](http://blog.Cocos2d-x.org/) and promote it on your social media.
  * Become a [__Regional Coordinator__](http://discuss.Cocos2d-x.org/t/we-need-regional-coordinators/24104)
