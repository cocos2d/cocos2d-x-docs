#Cocos2d-x-3.0で改善されたラベル

Cocos2d-xの3.0がリリースされる前は,CCLabelTTF, CCLabelBMFont, CCLabelAtlasの三つのクラスでテキストラベルを作成することができました。

Cocos2dは-X 3.0では,新しい"Label"クラスを追加しました。
ver3.0からはこのクラスでテキストラベルを作成します。
新しいラベルはFreeTypeライブラリで動作しているので,別々のプラットフォームでの描画結果が同じになりました。

新しいLabelクラスはは高速なキャッシュポリシーを持っているので,キャッシュを追跡することにより,早くレンダリングができます。
また,影を付けるなどたくさんの機能をもっているLabelBMFontとLabelTTF
は,Labelクラスに置き換えることができるようになっています。

## 変更点:

1. クラス,構造体,マクロのCCプレフィックスを削除,m,p,等の半ガリー命名規則を除去。
2. メンバ関数のパラメータと戻り値の型,特定のデータ型の変更。たとえばchar型はstring型に,unsigned型はlong型に置き換わりました。
3. いくつかの列挙型の名前と属性値の変更をしました。
4. `float getFontSize() const;`のように,メンバー関数にconst修飾子の追加。プログラムの堅牢性を向上させました。 

##  古いCCLabelから変わっている所

### 1.継承関係の比較
次のようにV3.0のバージョンでは,すべてのクラスのCCプレフィックスを削除し,CCCopyingクラスを削除している

#### CCLabelTTF と LabelTTF 

![](./res/classcocos2d_1_1_c_c_label_t_t_f.png)

![](./res/classcocos2d_1_1_label_t_t_f.png)


### 2. 水平配向と垂直配向の定義が変更される

#### バージョン2.xでは

```
	static CCLabelTTF * create(const char *string, const char *fontName, float fontSize,
	　　                               const CCSize& dimensions, CCTextAlignment hAlignment, 
	　　                               CCVerticalTextAlignment vAlignment);
```

#### バージョン3.0では
```
	static LabelTTF * create(const std::string& string, const std::string& fontName, float fontSize,
	　　                             const Size& dimensions, TextHAlignment hAlignment,
	　　                             TextVAlignment vAlignment);
```
上記の例のように　アップグレードしたバージョンの機能を見ていきましょう。

まず,CCプレフィックスはこのver3.0からありません

次に,char型の配列はstring型に置き換えられています
(char型の配列のほうが効率的なのですが,ミスが多いのでstring型を使用する方が便利です)

また,最後の２つのパラメータ（テキストの水平および垂直の位置合わせ）の種類も変更されています。しかし,両方とも次の表のように名前が変更されているだけで,以前のバージョンと同様の効率結果となっています。


| |*cocos2d-x-2.x*|*cocos2d-x-3.0*|
|---------------|---------------|---------------|
|平面線形|`typedef enum{kCCTextAlignmentLeft,kCCTextAlignmentCenter,kCCTextAlignmentRight,} CCTextAlignment;`|`enum class TextHAlignment{LEFT,CENTER,RIGHT};`|
|垂直整列|`typedef enum{kCCVerticalTextAlignmentTop, kCCVerticalTextAlignmentCenter,kCCVerticalTextAlignmentBottom,} CCVerticalTextAlignment;`|`enum class TextVAlignment{TOP,CENTER,BOTTOM};`|




## CCLabel以外の変化

LabelBMFontは,以下の機能が削除されました。

``` 
	CCBMFontConfiguration* getConfiguration() const;
```

この関数は,V３．０版以上で設定を取得するために呼び出すことはできません
（FNTファイル構成プロパティ）

## 拡張
### 新しいLabelクラス


それではLabelクラスの階層チャートを見てみましょう


![](./res/classcocos2d_1_1_label.png)


上記のチャートのLabelTextFormatProtocolは,新しいクラスです。
LabelTextFormatProtocolは文字列を格納するインターフェースを提供する
すべての純粋仮想基底クラスである,LabelProtocolと同じです。

継承グラフは,次のとおりです。

![](./res/classcocos2d_1_1_label_text_format_protocol.png)


-----------------------------


Labelクラスの　静的メンバー関数:
```
	static Label* createWithTTF(const std::string& label, const std::string& fontFilePath, int fontSize, int lineSize = 0, TextHAlignment alignment = TextHAlignment::CENTER, GlyphCollection glyphs = GlyphCollection::NEHE, const char *customGlyphs = 0);    
	static Label* createWithBMFont(const std::string& label, const std::string& bmfontFilePath, TextHAlignment alignment = TextHAlignment::CENTER, int lineSize = 0);
```

 
CreateWithTTF関数は,TTFファイルから直接ラベルを作成することができます。

この関数でラベルを作成する方法がLabelTTFを作成する方法と似ています。違いは,フォント名,フォントラベルをLabelTTFクラスを作成されていますが,Labelクラスは,TTFファイルを介して直接フォントラベルを作成します。

以下のコードはLabelTTFとLabelでラベルを作成しているので違いを見てください
```
	auto label1 = LabelTTF::create("Creating label through LabelTTF class by file name", "myFontName", 24);
	label1->setPosition(Point(origin.x, origin.y + visibleSize.height - label1->getContentSize().height));
	label1->setAnchorPoint(Point(0.0f, 0.0f));
    this->addChild(label1);

	auto label2 = Label::createWithTTF("Create label through Label class by .ttf file","fonts/myFontName.ttf", 32);
	label2->setPosition(Point(origin.x, origin.y + visibleSize.height - 80));
	label2->setAlignment(TextHAlignment::LEFT);
	label2->setAnchorPoint(Point(0.0f, 0.0f));
	this->addChild(label2);
```
プログラムを実行すると,次の結果が表示されます。

![](./res/ttf.png)


LabelTTFクラスは,正しいフォントを生成するために,システムフォントを使用しています。

ラベルの整列を設定する方法は次になります
```
	label2->setAlignment(TextHAlignment::LEFT)；	//Set the text level alignment is aligned to the left
```

CreateWithBMFontはLabelBMFontと似たような作成方法でFNTファイルを使用してラベルを作成しています。

以下のコードはLabelBMFontとLabelを通じてラベルを作成していますので違いを見てください。

```
	auto label3 = LabelBMFont::create("Create label through LabelBMFont class by .fnt file", "fonts/helvetica-32.fnt");
	label3->setAnchorPoint(Point(0.0f, 0.0f));
	label3->setPosition(Point(origin.x, origin.y + visibleSize.height - 120));
	addChild(label3);

	auto label4 = Label::createWithBMFont("Create label through Label class by .fnt file", "fonts/konqa32.fnt");
	label4->setAnchorPoint(Point(0.0f, 0.0f));
	label4->setPosition(Point(origin.x, origin.y + visibleSize.height - 160));
	addChild(label4 );
```

プログラムを実行すると,次のような結果になります。

![](./res/bmfont1.png)

LabelBMFontクラスを使用するには,プロジェクトにPNGファイルとFNTファイルを含む,フォントファイルを追加する必要があります。 Labelクラスも,同じ要件を持っています。

FNTファイルには対応する画像の名前,文字に対応するunicode,画像内の
文字の座標,幅,高さが含まれています。

上記のLabel4から以下のコードのようなメンバー関数を呼び出すことで,いくつかの属性を変更することができます。

```
	auto size = label4->getLabelContentSize();
	CCLOG("Label content size: %.2fx%.2f", size.width, size.height);
	auto lineWidth = label4->getMaxLineWidth();
	CCLOG("lineWidth: %.2f", lineWidth);
	auto s = label4->getStringLenght();
	CCLOG("string lenght:%.2f", s);
	label4->setScale(2.0f);							//Changes both X and Y scale factor of the label4
	label4->setColor(Color3B::GREEN);				//Changes the color
	label4->setOpacity(127);						//Changes the opacity. 
	auto CChar = (Sprite*)label4->getLetter(0);		//get the frist letter of label, each letter of the label can be treated like a CCSprite.
	auto jump = JumpBy::create(0.5f, Point::ZERO, 60, 1);
	auto jump_4ever = RepeatForever::create(jump);
	CChar->runAction(jump_4ever);
```

違いを見るためにプログラムを実行します。


![](./res/bmfont2.png)

![](./res/bmfont3.png)



