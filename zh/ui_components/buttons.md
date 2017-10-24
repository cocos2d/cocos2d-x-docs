# 按钮(Button)

按钮(Button)是什么, 好像没有必要解释, 我们都知道这东西是用来点击的, 点击后使我们的游戏产生一些变化, 比如更改了场景, 触发了动作等等. 按钮会拦截点击事件, 事件触发时调用事先定义好的回调函数. 按钮有一个正常状态, 一个选择状态, 还有一个不可点击状态, 按钮的外观可以根据这三个状态而改变. Cocos2d-x 使用 `Button` 对象实现按钮功能, 创建一个按钮并定义一个回调函数很简单, 记得在操作的时候要有头文件包含 `#include "ui/CocosGUI.h"`.

{% codetabs name="C++", type="cpp" -%}

auto button = Button::create("normal_image.png", "selected_image.png", "disabled_image.png");

button->setTitleText("Button Text");

button->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
        switch (type)
        {
                case ui::Widget::TouchEventType::BEGAN:
                        break;
                case ui::Widget::TouchEventType::ENDED:
                        std::cout << "Button 1 clicked" << std::endl;
                        break;
                default:
                        break;
        }
});

this->addChild(button);
{%- endcodetabs %}

在上面的例子可以看到, 我们为按钮的每一个状态都指定了一个 _.png_ 图像, 像这样:

![](../../en/ui_components/ui_components-img/Button_Normal.png "") ![](../../en/basic_concepts/basic_concepts-img/smallSpacer.png "") ![](../../en/ui_components/ui_components-img/Button_Press.png "") ![](../../en/basic_concepts/basic_concepts-img/smallSpacer.png "")
![](../../en/ui_components/ui_components-img/Button_Disable.png "")

在屏幕显示的时候, 是这样:

![](ui_components-img/Button_example.png "")
