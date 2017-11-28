## Widgets, oh, my!
__UI__ is an abbreviation that stands for _user interface_. You know, things that are on the screen. This include items like: __labels__, __buttons__, __menus__, __sliders__ and __views__. Cocos2d-x provides a set of __UI__ widgets to make it simple to add these controls to your projects. It may sound trivial, but a lot goes in to creating a core class like a `Label`. There are so many aspects of just this one. Could you imagine having to write your own custom widget set? Don't worry, your needs are covered!

<!-- topics to cover later -->
<!--
#### ImageView
A `ImageView` is a placeholder for displaying images. It supports touch events,
focus, percent positioning and percent content size. To create an `ImageView`:
```cpp
auto imageView = ImageView::create("ccicon.png");
imageView->setPosition(Vec2(0,0));
this->addChild(imageView);
```
It is also possible to create an `ImageView` from a `SpriteFrame`:
```cpp
auto imageView = ImageView::create("ccicon.png", TextureResType::PLIST);
imageView->setPosition(Vec2(0,0));
this->addChild(imageView);
```
## Text
A `Text` widget is used for displaying text. It can also use it as a _text-only_
button. You can think of a `Text` widget as `Text` supports system font and TTF fonts. To create a `Text` widget:
```cpp
auto text = Text::create("Text","fonts/MyTTF.ttf",30);

this->addChild(text);
```
You can add effects like _shadow_, _glow_ and _outline_ just like any `Label`
object.

### TextBMFont
A `TextBMFont` widget is used for displaying `BMFont` text. It supports touch
event, focus, percent positioning and percent content size. Creating a `TextBMFont`
is list like the `Text` widget:
```cpp
auto textBMFont = TextBMFont::create("BMFont", "bitmapFontTest2.fnt");
textBMFont->setPosition(Vec2(0,0));
this->addChild(textBMFont);
```

#### TextAtlas
A `TextAtlas` widget is used for displaying text as an _atlas font_. It  supports
touch event, focus, percent positioning and percent content size.\
```cpp
auto textAtlas = TextAtlas::create("1234567890", "labelatlas.png", 17, 22, "0");
textAtlas->setPosition(Vec2(0,0));
this->addChild(textAtlas);
```

#### RichText
A `RichText` widget is used for displaying text, image and custom nodes.  It
supports touch event, focus, percent positioning and percent content size. When
receiving a touch event the whole `RichText` widget receives the event. To create
a `RichText` widget:
```cpp
auto richText = RichText::create();
richText->ignoreContentAdaptWithSize(false);
richText->setContentSize(Size(100, 100));

auto re1 = RichElementText::create(1, Color3B::WHITE, 255, str1, "Marker Felt", 10);

richText->pushBackElement(re1);
richText->setPosition(Vec2(0,0));
richText->setLocalZOrder(10);
this->addChild(_richText);
```
-->
