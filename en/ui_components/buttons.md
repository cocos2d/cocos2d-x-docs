## Buttons
I doubt that we need to explain buttons much. We all know them as those things
we click on to make something happen in our games. Perhaps you might use a button
to change __scenes__ or to add `Sprite` objects into your game play.
A button intercepts a touch event and calls a predefined callback when tapped.
A `Button` has a __normal__ and __selected__ state. The appearance of the `Button` can
change based upon it's state. Creating a `Button` and defining its __callback__
is simple, make sure to `#include "ui/CocosGUI.h"`:

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

As you can see in the above example we specify a _.png_ image for each of the
possible states the button can be in. A `Button` is made up of 3 graphics that
might look like this:

![](ui_components-img/Button_Normal.png "") ![](basic_concepts-img/smallSpacer.png "") ![](ui_components-img/Button_Press.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/Button_Disable.png "")

On screen a `Button` might look like this:

![](ui_components-img/Button_example.png "")
