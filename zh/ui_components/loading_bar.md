# 进度条(LoadingBar)

如果你经常玩游戏, 那肯定见过一个情景: 屏幕上显示了一个进度条, 提示资源正在加载中, 这个条表示资源加载的进度. Cocos2d-x 提供了 `LoadingBar` 对象支持进度条.

创建一个进度条:

{% codetabs name="C++", type="cpp" -%}
#include "ui/CocosGUI.h"

auto loadingBar = LoadingBar::create("LoadingBarFile.png");

// set the direction of the loading bars progress
loadingBar->setDirection(LoadingBar::Direction::RIGHT);

this->addChild(loadingBar);
{%- endcodetabs %}

上面的例子, 我们创建了一个进度条, 当进度增加时, 我们设置了进度条填充的方向: 向右填充. 这只是创建了一个进度条, 在进度的控制中, 你肯定需要改变进度条的进度.

进度设置:

{% codetabs name="C++", type="cpp" -%}
#include "ui/CocosGUI.h"

auto loadingBar = LoadingBar::create("LoadingBarFile.png");
loadingBar->setDirection(LoadingBar::Direction::RIGHT);

// something happened, change the percentage of the loading bar
loadingBar->setPercent(25);

// more things happened, change the percentage again.
loadingBar->setPercent(35);

this->addChild(loadingBar);
{%- endcodetabs %}

上面例子, 使用的进度条图像是:

![](../../en/ui_components/ui_components-img/LoadingBarFile.png "")

在屏幕上一个满进度的进度条是这样的:

![](../../en/ui_components/ui_components-img/LoadingBar_example.png "")
