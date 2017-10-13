#cocos2d::Vector< T >

- バージョン: v3.0 beta
- 言語: C++

Vectorクラスは "[CCVector.h](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCVector.h)"に定義されていて "COCOS2DX_ROOT/cocos/base"の中にあります。

---

```cpp
template<class T>class CC_DLL Vector;
```

---

`cocos2d::Vector<T>` は動的配列をカプセル化したシーケンスコンテナです。

`cocos2d::Vector<T>`では,要素が連続して格納,保存され,また自動的に処理されます。 内部構造は実際に [std::vector<T>](http://en.cppreference.com/w/cpp/container/vector)STLの標準シーケンスコンテナです

Cocos2d-x v3.0 beta以前は, 名前の違う [cocos2d::CCArray](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCArray.h)という別のシーケンスコンテナがありました。これは,将来的に廃止される予定になっています。

`cocos2d::Vector<T>`はめ,`cocos2d::CCArray`よりもさらに慎重に設計されています。ぜひ`cocos2d::CCArray`ではなく`cocos2d::Vector<T>`を使用してください。

`cocos2d::Vector<T>`の一般的な複雑な操作は次の通りです。

- ランダムアクセス

- 最後に挿入または要素の除去

- 挿入または要素の除去


##テンプレートについて

**T** - 要素の型.

- T は [cocos2d::Object](https://github.com/cocos2d/cocos2d-x/blob/develop/cocos/base/CCObject.h) の子オブジェクトのポインタでなければいけません。他のデータ型,又はプリミティブ型は使用できません。 なぜならCocos2d-xの中の `cocos2d::Vector<T>` のメモリ管理モデルを統合しているからです（バージョン v3.0 beta以降）

##メモリ管理について
`cocos2d::Vector<T>`クラスには,唯一のデータメンバーが含まれています。

```cpp
std::vector<T> _data;
```

`_data`のメモリ管理は,コンパイラによって自動的に処理されます。 なので `cocos2d::Vector<T>` のスタック上でオブジェクトを宣言した場合は,メモリの解放を心配する必要はありません。

もし`new`オペレータを使用して `cocos2d::Vector<T>`を動的に生成した場合`delete` オペレータを使いメモリを解放してあげる必要があります。 また, `new[]` についても対となる `delete[]`をしてあげる必要があります。

**メモ**: 現代のC++では, メモリの動的確保はあまり好まれないので `new` オペレータはあまり使わないほうがいいかもしれません。

もしどうしても `cocos2d::Vector<T>` を動的確保したければ `shared_ptr`や`unique_ptr`等のスマートポインタを使用するのがよいでしょう。

**注意**: `cocos2d::Vector<T>` 自体は `cocos2d::Object`の子オブジェクトではないのでretain/releaseといった,参照カウンタを上下させる機能を使うことができません,言い換えれば,`cocos2d::Vector<T>` 自身上でretain/releaseを呼び出すことはできません。


##使用方法
 `std::vector<T>` の一般的な操作をほぼ全てラッピングされており,`std::vector<T>`の統一されたインターフェースにCocos2d-xのメモリ管理規定を追加したものとなっています

`pushBack()` メソッドは関数の引数の所有権を保持し, `popBack()` でコンテナの最後の要素の所有権を解放します。

これらの操作を利用するとき,初心者Cocos2d-x開発者のトラップである基本的なメモリ管理に注意が必要です。

**注意**:`cocos2d::Vector<T>` `operator[]`をオーバーロードしていないので `vec[i]`のような添字演算子から要素を取得することはできません。

`cocos2d::Vector<T>` コンテナは,多くの種類のイテレータを提供しています。なのでC++の標準ライブラリの恩恵を受けることができます。 例えば,`for_each`を使ったループなどができます。

ほかに`std::vector<T>`のコンテナ操作にある, `std::find`, `std::reverse` and `std::swap`といった標準アルゴリズムを `cocos2d::Vector<T>` コンテナに入れました,これらによってより使いやすくなりました。

他の機能について更に知りたいのであれば,Cocos2d-x 3.0 beta の資料やソースコードを参考にしてください。

以下,簡単な使用例となっています。

```cpp
//Vector<Sprite*> に保持させるスプライトを作成
auto sp0 = Sprite::create();
sp0->setTag(0);
//ここでは例としてshared_ptrを使用しています
std::shared_ptr<Vector<Sprite*>>  vec0 = std::make_shared<Vector<Sprite*>>();  //デフォルトコンストラクタ
vec0->pushBack(sp0);

//５つの容量をもつVector<Object*> を作成し,その中にスプライトを追加
auto sp1 = Sprite::create();
sp1->setTag(1);

//vectorの初期化
Vector<Sprite*>  vec1(5);
//インデックスを指定してオブジェクトを挿入する
vec1.insert(0, sp1);

//またvector全体を追加することもできます
vec1.pushBack(*vec0);

for(auto sp : vec1)
{
    log("sprite tag = %d", sp->getTag());
}

Vector<Sprite*> vec2(*vec0);
if (vec0->equals(vec2)) { //二つのvectorが等しい場合はtrueを返します
    log("pVec0 is equal to pVec2");
}
if (!vec1.empty()) {  //Vectorが空かどうか
    //vectorの容量とサイズを取得する,容量が必ずしもvectorの大きさと等しくないことに注意
    if (vec1.capacity() == vec1.size()) {
        log("pVec1->capacity()==pVec1->size()");
    }else{
        vec1.shrinkToFit();   //アイテムの数に対応するようにvectorを縮小する。
        log("pVec1->capacity()==%zd; pVec1->size()==%zd",vec1.capacity(),vec1.size());
    }
    //pVec1->swap(0, 1);  //インデックスを使ってvector内の2つの要素を入れ替える。
    vec1.swap(vec1.front(), vec1.back());  //valueによって2つの要素を入れ替える
    if (vec2.contains(sp0)) {  //vector中に存在するかどうかを示すブール値を返します
        log("The index of sp0 in pVec2 is %zd",vec2.getIndex(sp0));
    }
    //Vectorから要素を削除
    vec1.erase(vec1.find(sp0));
    //pVec1->erase(1);
    //pVec1->eraseObject(sp0,true);
    //pVec1->popBack();
    
    vec1.clear(); //全ての要素を削除
    log("The size of pVec1 is %zd",vec1.size());
}
 ```

出力結果:

```cpp
Cocos2d: sprite tag = 1
Cocos2d: sprite tag = 0
Cocos2d: pVec0 is equal to pVec2
Cocos2d: pVec1->capacity()==2; pVec1->size()==2
Cocos2d: The index of sp0 in pVec2 is 0
Cocos2d: The size of pVec1 is 0
```

##補足

-  `cocos2d::Vector<T>`ではメモリの動的確保はあまり推奨されていません。
- `cocos2d::Vector<T>`を引数として渡す場合,const参照として, `const cocos2d::Vector<T>&`のようにするといいでしょう。
- cocos2d::Vector<T>` を関数から返す時, 単に値オブジェクトを返します。 コンパイラはムーブセマンティクスを使用してこのような状況を最適化します。
- `cocos2d::Vector<T>` では`cocos2d::Object`の子オブジェクトのポインタ以外の任意のオブジェクトを保持しないようにしてください

