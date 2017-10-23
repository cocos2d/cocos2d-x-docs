div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Menu and Menu Items
We are all probably familiar with what a menu is. We see these in every application
we use. In your game you would probably use a `Menu` object to navigate through
game options. Menus often contain __buttons__ like _Play_, _Quit_, _Settings_ and
_About_, but could also contain other `Menu` objects for a nested menu system.
A `Menu` object is a special type of `Node` object. You can create an  empty
`Menu` object as a place holder for your __menu items__:

{% codetabs name="C++", type="cpp" -%}
auto myMenu = Menu::create();
{%- endcodetabs %}

As we described options above of _Play_, _Quit_, _Settings_ and
_About_, these are your __menu items__. A `Menu` without __menu items__ makes little
sense.  Cocos2d-x offers a variety of ways to create your __menu items__ including
by using a `Label` object or specifying an image to display. __Menu items__ usually
have two possible states, a __normal__ and a __selected__ state. When you tap or click
on the __menu item__ a __callback__ is triggered. You can think of this as a chain
reaction. You tap/click the __menu item__ and it runs the code you specified. A
`Menu` can have just a single item or many items.

{% codetabs name="C++", type="cpp" -%}
// creating a menu with a single item

// create a menu item by specifying images
auto closeItem = MenuItemImage::create("CloseNormal.png", "CloseSelected.png",
CC_CALLBACK_1(HelloWorld::menuCloseCallback, this));

auto menu = Menu::create(closeItem, NULL);
this->addChild(menu, 1);
{%- endcodetabs %}

A menu can also be created by using a __vector__ of `MenuItem` objects:

{% codetabs name="C++", type="cpp" -%}
// creating a Menu from a Vector of items
Vector<MenuItem*> MenuItems;

auto closeItem = MenuItemImage::create("CloseNormal.png", "CloseSelected.png",
CC_CALLBACK_1(HelloWorld::menuCloseCallback, this));

MenuItems.pushBack(closeItem);

/* repeat for as many menu items as needed */

auto menu = Menu::createWithArray(MenuItems);
this->addChild(menu, 1);
{%- endcodetabs %}

If you run the sample code for this chapter you will see a `Menu` containing
`Label` objects for `MenuItems`:

![](ui_components-img/menu.png "")

### Lambda functions as Menu callbacks
Above we just learned that when you click a __menu item__ it triggers a __callback__.
C++11 offers __lambda__ functions and therefore Cocos2d-x takes full advantage of
them! A __lambda__ function is a function you write inline in your source code.
__Lambdas__ are also evaluated at runtime instead of compile time.

A simple __lambda__:

{% codetabs name="C++", type="cpp" -%}
// create a simple Hello World lambda
auto func = [] () { cout << "Hello World"; };

// now call it someplace in code
func();
{%- endcodetabs %}

Using a __lambda__ as a `MenuItem` callback:

{% codetabs name="C++", type="cpp" -%}
auto closeItem = MenuItemImage::create("CloseNormal.png", "CloseSelected.png",
[&](Ref* sender){
	// your code here
});
{%- endcodetabs %}
