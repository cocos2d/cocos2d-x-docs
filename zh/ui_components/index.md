# 组件简介

UI 组件不是游戏专有的, 是个应用程序都可能会使用几个. 看一看你常使用的应用程序, 肯定能发现它有使用UI 组件. UI 代表什么? UI 组件是做什么的? 本章会告诉你答案

UI 代表用户界面, 是 _User Interface_ 的缩写, 你看到的屏幕上的东西就是用户界面. 界面组件有标签, 按钮, 菜单, 滑动条等. Cocos2d-x 提供了一套易用的 UI 组件, 游戏开发过程中, 你能很容易的把他们添加到游戏中. 听起来这可能很简单, 但创建像 `Label(标签)` 这样的核心类实际要考虑很多问题.

可以想象创建一套自定义的组件是多么的困难! 当然你根本没必要这样做, 因为你需要的我们都考虑到了.

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
