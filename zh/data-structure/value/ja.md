#cocos2d::Value について

- 対象: v3.0 beta以降
- 言語: C++

本稿のValueクラスは "[CCValue.h](https://github.com/andyque/cocos2d-x/blob/develop/cocos/base/CCValue.h)"で定義され,"COCOS2DX_ROOT/cocos/base"のフォルダー内に置かれています。

---

```cpp
class Value;
```

---

`cocos2d::Value`は,多くの基本型(`int`,`float`,`double`,`bool`,`unsigned char`,`char*`,`std::string`) や,`std::vector<Value>`,`std::unordered_map<std::string,Value>`,`std::unordered_map<int,Value>`を格納することができます。


基本型,もしくはそれに変換出来るものであればほとんどが`cocos2d::Value`に格納出来ますが,そうでない物に関してはこのクラス以外の手段を考えた方が良い場合があります。

`cocos2d::Value`の_baseData内の変数は全て,共用体として宣言されることで同じメモリスペースを共有しています。

Cocos2d-x v3.0 beta以前のバージョンでは`CCBool`,`CCFloat`,`CCDouble`, `CCinteger`などの基本型をラッピングするクラスが提供されていましたが,以降のバージョンでは使用出来ない,もしくは推奨されていません。

*メモ* : 多くの型を扱う場合や,変数を格納するコンテナが必要だと思ったときは, `cocos2d::Vector<T>`や`cocos2d::Map<K,V>`,`cocos2d::Value`を使うと便利です。

##メモリ管理に関して
`cocos2d::Value`は,自動解放の仕組みを持っていないので,C++のルールに則った解放を行ってください。

`cocos2d::Value`は,以下のようにメンバを持っています。

```cpp
union
{
    unsigned char byteVal;
    int intVal;
    float floatVal;
    double doubleVal;
    bool boolVal;
}_baseData;

std::string _strData;
ValueVector* _vectorData;
ValueMap* _mapData;
ValueMapIntKey* _intKeyMapData;

Type _type;
```

以上のコードはクラスほんの一部ですが,メンバの宣言部分を記載しています。
`_baseData`,`_strData`,`_type`のデータメンバは自動変数の効果により自動で解放されます。
また,`cocos2d::Value`の持つポインタメンバ(`_vectorData`,`_mapData`,`_intKeyMapData`)の解放については,自身のデストラクタによって行われます。

注意点 : `cocos2d::Value`を使う時は,通常のCocos2d-xのクラスを使う時に行うretain/release などの参照カウンタを増減させるような機能は使えません。

##使用例
`cocos2d::Value`を使うのは難しくありません。

分かりやすく使ってみた例を以下に記述します。

```cpp
Value val;   // デフォルトコンストラクタを呼び出します。
if (val.isNull()) {
	log("val is null");
}else{
	std::string str =val.getDescription();
	log("The description of val0:%s",str.c_str());
}
//----------------------------------------------------
Value val1(65);   // 宣言と同時にint型で初期化
//Value val1(3.4f);   // 宣言と同時にfloat型で初期化
//Value val1(3.5);   // 宣言と同時にdouble型で初期化
log("The description of the integer value:%s",val1.getDescription().c_str());
log("val1.asByte() = %c",val1.asByte());
//----------------------------------------------------
std::string strV = "string";
Value val2(strV);   // 宣言と同時にstd::string型で初期化
log("The description of the string value:%s",val2.getDescription().c_str());
//----------------------------------------------------
auto sp0 = Sprite::create();
Vector<Object*>* vecV = new Vector<Object*>();
vecV->pushBack(sp0);
Value val3(vecV);   //宣言と同時にVecter型で初期化
log("The description of the Vector value:%s",val3.getDescription().c_str());
delete vecV;
//----------------------------------------------------
Map<std::string, Object*>* mapV = new Map<std::string, Object*>();
mapV->insert(strV,sp0);
Value val4(mapV);   // 宣言と同時にMap型で初期化
log("The description of the Map value:%s",val4.getDescription().c_str());
delete mapV;
//----------------------------------------------------
Value val6(&val4);   // 宣言と同時にMap型で初期化
log("The description of the Value-type value:%s",val6.getDescription().c_str());
//----------------------------------------------------
val2 = val1;   // assigning between 2 Value-type
log("operator-> The description of val2:%s",val2.getDescription().c_str());
val2 = 4;   //直接数値を代入
log("operator-> The description of val4:%s",val2.getDescription().c_str());
```

出力結果:

```cpp
cocos2d: val is null
cocos2d: The description of the integer value:
65

cocos2d: val1.asByte() = A
cocos2d: The description of the string value:
string

cocos2d: The description of the Vector value:
true

cocos2d: The description of the Map value:
true

cocos2d: The description of the Value-type value:
true

cocos2d: operator-> The description of val2:
65

cocos2d: operator-> The description of val4:
4
```

##補足
- `cocos2d::Value`や,新しいコンテナクラス(`cocos2d::Vector<T>`,`cocos2d::Map<K,V>`)は,このバージョンにおいて`cocos2d::CCBool`, `cocos2d::CCFloat`,`cocos2d::CCDouble`,`cocos2d::CCString`,`cocos2d::CCInteger`や Objective-c のような形式で書かれた古いコンテナクラス(`cocos2d::CCArray` ,`cocos2d::CCDictionary`)に比べ,より機能的に優れており推奨されます。
- 多くの基本型を使用したいと思ったときは,`cocos2d::Value`に格納したり,新しいコンテナクラス`cocos2d::Vector<T>`,`cocos2d::Map<K,V>`と連動させたりします。
