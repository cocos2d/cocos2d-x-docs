div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Label
Cocos2d-x provides a `Label` object that can create labels using __true type__,
__bitmap__ or the built-in system font. This single class can handle all your `Label`
needs.

#### Label BMFont
`BMFont` is a label type that uses a bitmap font. The characters in a bitmap font
are made up of a matrix of __dots__. It is very fast and easy to use, but not
scalable as it requires a separate font for each size character. Each character
in a `Label` is a separate `Sprite`. This means that each character can be rotated,
scaled, tinted, have a different __anchor point__ and/or most any other property changed.

Creating a `BMFont` label requires two files: a __.fnt__ file and an image
representation of each character in __.png__ format. If you are using a tool like
__Glyph Designer__ these files are created automatically for you. Creating a
`Label` object from a __bitmap font__:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithBMFont("bitmapRed.fnt", "Your Text");
{%- endcodetabs %}

![](ui_components-img/LabelBMFont.png "")

All of the characters in the string parameter should be found in the provided
__.fnt__ file, otherwise they won't be rendered. If you render a `Label` object and
it is missing characters, make sure they exist in your __.fnt__ file.

#### Label TTF
__True Type Fonts__ are different from the __bitmap fonts__ we learned about above.
With __true type fonts__ the outline of the font is rendered. This is convenient
as you do not need to have a separate font file for each size and color you might
wish to use. Creating a `Label` object that uses a __true type font__ is easy. To
create one you need to specify a __.ttf__ font file name, text string and a size.
Unlike `BMFont`, `TTF` can render size changes without the need for a separate
font files. Example, using a __true type font__:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithTTF("Your Text", "Marker Felt.ttf", 24);
{%- endcodetabs %}

![](ui_components-img/LabelTTF.png "")

Although it is more flexible than a __bitmap font__, a _true type font_ is slower
to render and changing properties like the __font face__ and __size__ is an expensive
operation.

If you need several `Label` objects from a __true type font__ that all have the
same properties you can create a `TTFConfig` object to manage them. A `TTFConfig`
object allows you to set the properties that all of your labels would have in
common. You can think of this like a *recipe* where all your `Label` objects
will use the same ingredients.

You can create a `TTFConfig` object for your `Labels` in this way:

{% codetabs name="C++", type="cpp" -%}
// create a TTFConfig files for labels to share
TTFConfig labelConfig;
labelConfig.fontFilePath = "myFont.ttf";
labelConfig.fontSize = 16;
labelConfig.glyphs = GlyphCollection::DYNAMIC;
labelConfig.outlineSize = 0;
labelConfig.customGlyphs = nullptr;
labelConfig.distanceFieldEnabled = false;

// create a TTF Label from the TTFConfig file.
auto myLabel = Label::createWithTTF(labelConfig, "My Label Text");
{%- endcodetabs %}

![](ui_components-img/LabelTTFWithConfig.png "")

A `TTFConfig` can also be used for displaying Chinese, Japanese and Korean
characters.

#### Label SystemFont
`SystemFont` is a label type that uses the default system font and font size.
This is a font that is meant not to have its properties changed. You should think
of it as __system font, system rules__. Creating a `SystemFont` label:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithSystemFont("My Label Text", "Arial", 16);
{%- endcodetabs %}

![](ui_components-img/LabelWithSystemFont.png "")

## Label Effects
After you have your `Label` objects on screen you might want to make them a bit
prettier. Perhaps they look flat or plain. Thankfully you don't have to create
your own custom fonts! `Label` objects can have effects applied to them. Not all
`Label` objects support all effects. Some effects include __shadow__, __outline__
and __glow__. You can apply one or more effects to a `Label` object easily:

Label with a __shadow__ effect:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithTTF("myFont.ttf", "My Label Text", 16);

// shadow effect is supported by all Label types
myLabel->enableShadow();
{%- endcodetabs %}

![](ui_components-img/LabelWithShadow.png "")

Label with a __outline__ effect:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithTTF("myFont.ttf", "My Label Text", 16);

// outline effect is TTF only, specify the outline color desired
myLabel->enableOutline(Color4B::WHITE, 1));
{%- endcodetabs %}

![](ui_components-img/LabelWithOutline.png "")

Label with a __glow__ effect:

{% codetabs name="C++", type="cpp" -%}
auto myLabel = Label::createWithTTF("myFont.ttf", "My Label Text", 16);

// glow effect is TTF only, specify the glow color desired.
myLabel->enableGlow(Color4B::YELLOW);
{%- endcodetabs %}

![](ui_components-img/LabelWithGlow.png "")
