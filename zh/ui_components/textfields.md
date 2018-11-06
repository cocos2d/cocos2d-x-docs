# 文本框(TextField)

如果你想让参与游戏的玩家可以自定义一个昵称怎么办，在哪里输入文本？Cocos2d-x 提供 __`TextField`__ 满足这种需求。它支持触摸事件，焦点，定位内容百分比等。

创建一个文本框：

```cpp
#include "ui/CocosGUI.h"

auto textField = TextField::create("","Arial",30);

textField->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
                std::cout << "editing a TextField" << std::endl;
});

this->addChild(textField);
```

这个例子中，创建了一个 `TextField`，指定了回调函数。

提供的文本框对象，是多功能的，能满足所有的输入需求，比如用户密码的输入，限制用户可以输入的字符数等等！

看一个例子：

```cpp
#include "ui/CocosGUI.h"

auto textField = TextField::create("","Arial",30);

// make this TextField password enabled
textField->setPasswordEnabled(true);

// set the maximum number of characters the user can enter for this TextField
textField->setMaxLength(10);

textField->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
                std::cout << "editing a TextField" << std::endl;
});

this->addChild(textField);
```

屏幕上一个文本框是这样的：

![](../../en/ui_components/ui_components-img/TextField_example.png "")

当点击文本框，键盘就会自动调出来，此时可以输入文本：

![](../../en/ui_components/ui_components-img/TextField_example_keyboard.png "")
