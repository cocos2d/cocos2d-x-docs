## TextField
What if you wanted the player of your game to type in a special name to call the
main character? Where would they type it into? Yes, a __text field__, of course.
A `TextField` widget is used for inputting text. It supports touch event, focus,
percent positioning and percent content size. To create a `TextField` widget:

{% codetabs name="C++", type="cpp" -%}
#include "ui/CocosGUI.h"

auto textField = TextField::create("","Arial",30);

textField->addTouchEventListener([&](Ref* sender, Widget::TouchEventType type){
				std::cout << "editing a TextField" << std::endl;
});

this->addChild(textField);
{%- endcodetabs %}

In this example a `TextField` is created and a __callback__ specified.

`TextField` objects are versatile and can meet all of your input needs. Would you
like the user to enter a secret password? Do you need to limit the number of
characters a user can input? `TextField` objects have this all built-it and much
more! Let's take a look at an example:

{% codetabs name="C++", type="cpp" -%}
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
{%- endcodetabs %}

On screen a `TextField` might look like this:

![](ui_components-img/TextField_example.png "")

When you are editing a `TextField`, the onscreen keyboard comes up:

![](ui_components-img/TextField_example_keyboard.png "")
