#cocos2d::Map< K,V >

- バージョン: v3.0 beta
- 言語: C++

本稿のMapクラスは"[CCMap.h](https://github.com/chukong/cocos2d-x/blob/develop/cocos/base/CCMap.h)" で定義され, "COCOS2DX_ROOT/cocos/base"のフォルダー内に置かれています。

---

```cpp
template <class K, class V>
class CC_DLL Map;
```

---

`cocos2d::Map<K,V>`はテンプレートによって作成される連想配列であり,[std::unordered_map<K, V>](http://en.cppreference.com/w/cpp/container/unordered_map)を基にして構成されています。

std::unordered_map<K, V> は,キーと値によって関連づけられた要素を２つ一組で保持するように作られており,要素を利用するにはキーを指定する事で値を引き出す事が出来ます。

std::unordered_map<K, V>によって管理されているオブジェクトに関しては,キーの指定さえ間違えなければ,それがそのまま値のように扱えます。

なお,この連想配列は何かを基準にして順番通りに並べるなどされておらず,整列されていないので,安定した実行速度を求める場合,望んだ通りの結果にならない場合があります。

Cocos2d-x v3.0 beta以前は [cocos2d::CCDictionary](https://github.com/chukong/cocos2d-x/blob/develop/cocos/base/CCDictionary.h) という名前で利用されていましたが,以降のバージョンではこちらの配列は使用が出来ない,もしくは推奨されません。

なので,連想配列を使用したい場合,`cocos2d::CCDictionary`の代わりに,更に慎重に設計され改良された`cocos2d::Map<K,V>`を使用してください。

##テンプレートについて

**K** - 値を判別するためのキー

- 格納している要素それぞれに対し,unordered_mapはそれを特定するための手がかりとしてkeyを使用します。

**V** - 配列に格納する値

- [cocos2d::Object](https://github.com/chukong/cocos2d-x/blob/develop/cocos/base/CCObject.h)を格納する場合,Tはポインタ型でなければなりません。他の型や基本型は入れないようにしてください。より詳細な説明は以下の「メモリ管理について」に記述します。(なお,説明はCocos2d-x v3.0 beta以降のバージョンを前提にしています)

##メモリ管理について
`cocos2d::Map<K,V>`クラスのメンバは以下のようになっています:

```cpp
typedef std::unordered_map<K, V> RefMap;
RefMap _data;
```

メモリ管理について,`_data`はコンパイラによって自動的に解放されます。また,`cocos2d::Map<K,V>`にオブジェクトをスタックしている場合,その要素についてはその限りではありません。

もし`new`のオペレータを使用し`cocos2d::Map<K,V>`を動的に作成したのであれば,`delete` オペレータを使用しメモリを解放してあげる必要があります。また,`new[]`についても同様に,対となる`delete[]`で解放する必要があります。

**メモ**: c++で`new`を使う以上切り離せない問題ではありますが,メモリの動的確保は利用者が的確な知識を持って確保,解放する事が不可欠であり,`cocos2d::Map<K,V>`を使う場合,その問題は更に顕著になるでしょう。`cocos2d::Map<K,V>`本体と要素を同時に制御するのは少し手間です。

なので,負担を少しでも軽くするために,`cocos2d::Map<K,V>`をどうしても動的生成したいのであれば`shared_ptr`や`unique_ptr`を利用する事をお勧めします。

**注意点**: `cocos2d::Map<K,V>`を使う時は,通常のCocos2d-xのクラスを使う時に行うretain/release などの参照カウンタを増減させるような機能は使えません。


##使用例

**注意点** `cocos2d::Map<K,V>`は`operator[]`をオーバーロードしていないので,`cocos2d::Map<K,V>`の要素へのアクセスについて`map[i]`という風に記述することはできません。

他の機能について更に知りたいのであれば,Cocos2d-x 3.0 beta の資料やソースコードを参考にしてください。

以下が使用例:

```cpp
//Map<K, V>に保持させるためのスプライトを作成
auto sp0 = Sprite::create();
sp0->setTag(0);
Map<std::string, Sprite*> map0;
std::string mapKey0 = "MAP_KEY_0";
map0.insert(mapKey0, sp0);
log("The size of map is %zd.",map0.size()); 
//Map<K, V>をコピーして作成します。
Map<std::string, Sprite*> map1(map0);
std::string mapKey1 = "MAP_KEY_1";
if(!map1.empty()){
	auto spTemp = (Sprite*)map1.at(mapKey0);
	log("sprite tag = %d", spTemp->getTag());
	auto sp1 = Sprite::create();
	sp1->setTag(1);
	map1.insert(mapKey1, sp1);      
	//キーをstd::vectorに管理させる事でより管理しやすく出来ます。
	std::vector<std::string> mapKeyVec;
	mapKeyVec = map1.keys();
	for(auto key : mapKeyVec)
	{
		auto spTag = map1.at(key)->getTag();
		log("The Sprite tag = %d, MAP key = %s",spTag,key.c_str());
		log("Element with key %s is located in bucket %zd",key.c_str(),map1.bucket(key));
	}
	log("%zd buckets in the Map container",map1.bucketCount());
	log("%zd element in bucket 1",map1.bucketSize(1));  
	//指定した位置が空であればnullptrを返却します。
	log("The random object tag = %d",map1.getRandomObject()->getTag());  
	//find(const K& key)を使ってランダムな位置の要素を取得します。
	//erase(const_iterator position)とすることで要素を削除する事も出来ます。
	log("Before remove sp0, size of map is %zd.",map1.size());
	map1.erase(map1.find(mapKey0));
	log("After remove sp0, size of map is %zd.",map1.size());
}  
//最大許容数を５に設定してマップを作成します。
Map<std::string, Sprite*> map2(5);
map2.reserve(10);  //最大許容量を増減させる事も出来ます。
```

出力結果:

```cpp
cocos2d: The size of map is 1.
cocos2d: sprite tag = 0
cocos2d: The Sprite tag = 1, MAP key = MAP_KEY_1
cocos2d: Element with key MAP_KEY_1 is located in bucket 1
cocos2d: The Sprite tag = 0, MAP key = MAP_KEY_0
cocos2d: Element with key MAP_KEY_0 is located in bucket 0
cocos2d: 2 buckets in the Map container
cocos2d: 1 element in bucket 1
cocos2d: The random object tag = 0
cocos2d: Before remove sp0, size of map is 2.
cocos2d: After remove sp0, size of map is 1.
```


##補足

- `cocos2d::Map<K, V>()`をconstの参照で宣言する場合,`const cocos2d::Map<K, V>()&`と記述します。
- [cocos2d::Object](https://github.com/chukong/cocos2d-x/blob/develop/cocos/base/CCObject.h)を格納する場合,Tはポインタ型でなければなりません。他の型や基本型は入れないようにしてください。
