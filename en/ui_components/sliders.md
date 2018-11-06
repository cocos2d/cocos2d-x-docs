## Slider
Sometimes it is necessary to change a value slightly. Perhaps you have a character
and you want to allow the player to adjust the strength of attacking an enemy.
A `Slider` allows users to set a value by moving an indicator. To create a `Slider`:

```cpp
#include "ui/CocosGUI.h"

auto slider = Slider::create();
slider->loadBarTexture("Slider_Back.png"); // what the slider looks like
slider->loadSlidBallTextures("SliderNode_Normal.png", "SliderNode_Press.png", "SliderNode_Disable.png");
slider->loadProgressBarTexture("Slider_PressBar.png");

slider->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
		switch (type)
		{
				case ui::Widget::TouchEventType::BEGAN:
						break;
				case ui::Widget::TouchEventType::ENDED:
						std::cout << "slider moved" << std::endl;
						break;
				default:
						break;
		}
});

this->addChild(slider);
```

As you can see in the above example we specify a _.png_ image for each of the
possible states the slider can be in. A `Slider` is made up of 5 graphics that
might look like this:

![](ui_components-img/Slider_Back.png "") ![](basic_concepts-img/smallSpacer.png "") ![](ui_components-img/Slider_PressBar.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/SliderNode_Normal.png "") ![](basic_concepts-img/smallSpacer.png "") ![](ui_components-img/SliderNode_Press.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/SliderNode_Disable.png "")

On screen a `Slider` might look like this:

![](ui_components-img/Slider_example.png "")
