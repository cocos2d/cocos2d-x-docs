## CheckBox
We are all used to filling out __checkboxes__ on paper forms like job applications
and rental agreements. You can also have __checkboxes__ in your games. Perhaps, you
want to have the ability for your player to make a simple __yes__ or __no__ choice.
You might also hear this referred to as a __binary__ choice (0 and 1). A `CheckBox`
permits the user to make this type of choice. There are 5 different __states__ a
`Checkbox` can have: __normal__, __selected__ and __disabled__. It is simple to create
a `CheckBox`:

{% codetabs name="C++", type="cpp" -%}
# include "ui/CocosGUI.h"

auto checkbox = CheckBox::create("check_box_normal.png",
                                 "check_box_normal_press.png",
                                 "check_box_active.png",
                                 "check_box_normal_disable.png",
                                 "check_box_active_disable.png");

checkbox->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
		switch (type)
		{
				case ui::Widget::TouchEventType::BEGAN:
						break;
				case ui::Widget::TouchEventType::ENDED:
						std::cout << "checkbox 1 clicked" << std::endl;
						break;
				default:
						break;
		}
});

this->addChild(checkbox);
{%- endcodetabs %}

As you can see in the above example we specify a _.png_ image for each of the
possible states the `Checkbox` can be in. Since there are 5 possible states that
a `CheckBox` can be in, it is up 5 graphics, one for each of its states. Example
graphics:

![](ui_components-img/CheckBox_Normal.png "") ![](basic_concepts-img/smallSpacer.png "") ![](ui_components-img/CheckBox_Press.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/CheckBox_Disable.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/CheckBoxNode_Normal.png "") ![](basic_concepts-img/smallSpacer.png "")
![](ui_components-img/CheckBoxNode_Disable.png "")

On screen a `Checkbox` might look like this:

![](ui_components-img/Checkbox_example.png "")
