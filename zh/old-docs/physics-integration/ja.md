# Physicsの統合

* 使用バージョン : Cocos2d-x v3.0 alpha1

## 初めに

ゲームにおいて,現実世界の物理挙動をシミュレートするのは非常に大変なので,物理エンジンを使用するのが一般的です。 ご存知かもしれませんが,Box2Dはほぼ全ての物理的効果をシミュレートすることができます。 しかしChipmunkのが軽量という特徴もあります。 Cocos2d-x v2.0では直接物理エンジンを使用しており,物理特性ボディを持つスプライトとしてCCPhysicsSpriteを提供していました。 しかし,物理エンジンの他の要素はCocos2d-xには入っておらず,ゲーム内で直接ChipmunkまたはBox2DのAPIを呼び出す必要がありました。 直接物理エンジンを使用する場合,複雑で多くのAPIパラメータが存在するので,ゲーム開発者が全てを把握するのは困難でした。 しかし,Cocos2d-x v3.0の物理挙動はChipmunkとBox2Dをラッピングした形に変更され,ゲーム開発者が物理エンジンのAPIを直接呼び出す必要がなくなりました。

Cocos2d-xの統合された物理エンジンについて :

* 物理挙動を持った世界(以降フィジックスワールドと表記します)とシーンは統合され,シーンを作成する際に物理エンジンを使用するか否かを割り当てることができます。
* ノードとスプライトは物理構造のプロパティを所有しています。
* Cocos2d-x v3.0のカプセル化された物理エンジンの機能として,ボディ(PhysicsBody), シェイプ(PhysicsShape), コンタクト(PhysicsContact), ジョイント(PhysicsJoint), ワールド(PhysicsWorld)があります。 これらは簡単に使用することができます。
* より簡単に衝突を検出できるEventListenerPhysicsContactの実装。

## 物理エンジンを使用したゲームプロジェクトを作成する

Cocos2d-x v3.0のプロジェクトは,以下のパスのスクリプトを実行することで作成することができます。

**/tools/project-creator/create_project.py**

物理挙動はデフォルトで開放されており,基本の物理エンジンとしてChipmunkを使用しています。

物理エンジンを無効にする場合は`ccConfig.h`内に定義されている`CC_USE_PHYSICS`を変更してください。

## フィジックスワールドをシーンに含めて作成する

次のコードはシーンとフィジックスワールドを生成し,レイヤーにフィジックスワールドを渡すというものです。  
例として**PhysicsLayer.h**に追加します。

```
class PhysicsLayer : public cocos2d::Layer
{
...
	// 次のコードを追加してください
	void setPhyWorld( PhysicsWorld* world ) { m_world = world; }
private:
    PhysicsWorld* m_world;
...
}
```

**PhysicsLayer.cpp**の**createScene**関数内に次のコードを追加してください。

```
Scene* PhysicsLayer::createScene()
{
...
	// 次のコードを追加してください
	auto scene = Scene::createWithPhysics();
	scene->getPhysicsWorld()->setDebugDrawMask( PhysicsWorld::DEBUGDRAW_ALL );
	
	auto layer = HelloWorld::create();
	layer->setPhyWorld( scene->getPhysicsWorld() );
...
	return scene;
}
```

Sceneクラスはシーンとフィジックスワールドを生成する静的ファクトリメソッドの`createWithPhysics()`が追加されました。 フィジックスワールドのインスタンスを取得したい場合は,Sceneクラスの`getPhysicsWorld()`で取得することができます。

PhysicsWorldクラスには`setDebugDrawMask()`という関数があります。 それは形状,関節,接触などを可視化できる非常に便利な関数です。 あなたがゲームをリリースする場合などは,このデバッグ機能をオフにすることを忘れないでください。

`setPhyWorld()`によってフィジックスワールドをシーンの子要素であるレイヤーに渡すことができ,シーンでは他のレイヤーによって共有されるフィジックスワールドの唯一のインスタンスを所有しています。


PhysicsWorldクラスはデフォルトで`Vect( 0.0f, -98.0f )`という値の重力が設定されています。 変更するには`setGravity()`を使用します。

PhysicsWorldクラスの`setSpeed()`で速度を変更することも可能です。

## フィジックスワールドの境界を作成する

フィジックスワールドは全体が重力の影響を受けています。 Cocos2d-x v2.0の物理エンジンは重力を受けない形状を生成する方法として,**staticShape**という方法を用意していましたが,**staticShape**の多くのパラメータを知る必要がありました。

しかし,Cocos2d-x v3.0ではノードのプロパティとしてPhysicsShapeが用意されています。 フィジックスワールドのプロパティを設定する場合,ノードのインスタンスにそれらの情報を渡す必要があります。

次のコードは画面の周りに境界を作る方法です。

```
Size visibleSize = Director::getInstance()->getVisibleSize();
auto body = PhysicsBody::createEdgeBox( visibleSize, PHYSICSBODY_MATERIAL_DEFAULT, 3 );
auto edgeNode = Node::create();
edgeNode->setPosition( Point( visibleSize.width / 2, visibleSize.height / 2 ) );
edgeNode->setPhysicsBody( body );
scene->addChild( edgeNode );
```

Physics周りのクラスには**createEdgeBox**など,多くのファクトリメソッドが用意されています。 **createEdgeBox**は矩形エッジを生成する方法であり,引数は以下で説明します。

1. **visibleSize**を矩形領域として設定します。
2. 省略可能な引数 - テクスチャ, デフォルト設定では**PHYSICSBODY_MATERIAL_DEFAULT**になります。
3. 省略可能な引数 - ボーダーサイズ, デフォルト設定では**1**になります。

上記で物理特性を持ったボディを生成することができたので,ノードを生成し,生成したボディを設定します。 ノードの座標は画面中央に設定し,シーンに追加します。

Cocos2d-x v3.0の`addChild()`はPhysicsBodyを持つノードにも対応しています。 また,自動的にノードのボディ情報もシーンのフィジックスワールドに追加されます。

PhysicsBodyのプロジェクトメソッドは引数を使用して設定され,設定されたボディのサイズに従って自動的にPhysicsBodyとPhysicsShapeを作成することができます。 本来であれば,この作業は直接物理エンジンを使用して作成するのが一般的ですが,Cocos2d-x v3.0ではこの作業を単純化しているので多くのコードを書く必要がありません。

## 重力の影響を受けるスプライトを作成する

Cocos2d-x v3.0では,重力の影響を受けるスプライトを非常に簡単に作成することができます。

```
void HelloWorld::addNewSpriteAtPosition( Point p )
{
    auto sprite = Sprite::create( "circle.png" );
    sprite->setTag( 1 );
    auto body = PhysicsBody::createCircle( sprite->getContentSize().width / 2 );
    sprite->setPhysicsBody( body );
    sprite->setPosition( p );
    this->addChild( sprite );
}
```

まずはスプライトを生成します。 次に`PhysicsBody::createCircle`を使用して,円形のボディを生成し,スプライトに追加します。 全体の流れとしては,上記で説明した境界の作成と同じです。

PhysicsShapeを作成し,`addShape()`によってボディを追加することができます。 しかし,質量( 密度,面積 )と運動量が自動的にボディに追加されるので注意してください。 また,ボディを追加した後は,回転角度,相対位置の変更もできなくなります。 必要が無くなったボディは`removeShape()`によって削除することができます。

## 衝突の検出

現在のCocos2d-xでは,イベントディスパッチをリファクタリングしており,全てのイベントがイベントディスパッチャによって管理されるようになっています。 現在,物理エンジンの衝突イベントはイベントディスパッチャによって管理されています。

衝突した時に呼ばれるコールバック関数は次のコードになります。

```
auto contactListener = EventListenerPhysicsContact::create();
contactListener->onContactBegin = CC_CALLBACK_1( HelloWorld::onContactBegin, this );
_eventDispatcher->addEventListenerWithSceneGraphPriority( contactListener, this );
```

全ての衝突イベントを検出しているのが**EventListenerPhysicsContact**です。 インスタンスを生成したら,**CC_CALLBACK_1**を使い,**onContactBegin**をコールバック関数として登録します。 **CC_CALLBACK_1**はC++11から使用できるコールバックポインタ変換関数です。 **onContactBegin**には引数があるので,**CC_CALLBACK_1**を使い,変換します。

`_eventDispatcher`はNodeクラスの基本メンバで初期化されたレイヤーで使用することができます。

ボディの形状やグループに応じて,特定のイベントを検出できる`EventListenerPhysicsContactWithBodies`, `EventListenerPhysicsContactWithShapes`, `EventListenerPhysicsContactWithGroup`などを使用することができます。 しかし,**EventListenerPhysicsContact**を生成するだけではイベントを検出することができません。 接触ビットマスクを設定する必要があります。

接触ビットマスクの設定とグループ設定はBox2Dと同じです。

ビットマスクの設定には,**CategoryBitmask**, **ContactTestBitmask**, **CollisionBitmask**があります。 それらを取得,変更する為にget, set関数が用意されています。 これらは論理アンド演算により計算されています。

各ビットマスクの初期値として,**CategoryBitmask**の値が0xFFFFFFFF,**ContactTestBitmask**の値は0x00000000,**CollisionBitmask**の値は0xFFFFFFFFとなっています。 **CategoryBitmask**のボディと**ContactTestBitmask**のボディでは結果がゼロなので,接触イベントが送信されません。 結果がゼロ以外の場合のみ接触イベントが送信されます。 **CategoryBitmask**と**CollisionBitmask**も同じです。 初期設定では接触イベントが送信されずにお互いが衝突することを意味します。

その他の設定として**グループ**があります。 同じ**グループ**内のオブジェクトは,ゼロより大きい値の時に互いに衝突し,ゼロより小さい値の時は互いに衝突しません。 グループがゼロではない場合,ビットマスクの設定は無視されるので注意してください。( ContactTestBitmaskの設定が機能しています )

`EventListenerPhysicsContact`には接触時のコールバック関数として以下の4つを用意しています。`onContactBegin`, `onContactPreSolve`, `onContactPostSolve`, `onContactSeperate`

`onContactBegin`は接触初めの1度だけ呼ばれます。 2つの形状が衝突しているか否かを戻り値のtrue, falseで決めることができます。 接触時に`PhysicsContact::setData()`を使い,ユーザデータを設定することができます。 しかし,`onContactBegin`の戻り値をfalseで返してしまうと,`onContactPreSolve`と`onContactPostSolve`呼び出されなくなるので注意してください。 `onContactPostSolve`は1度だけ呼び出されます。

`onContactPreSolve`は各ステップで呼び出されます。 反発や摩擦などの接触に関するパラメータは`PhysicsContactPreSolve`の機能で設定することができます。 また,2つの形状が衝突するのか否かを,true, falseを返すことで決めることができます。 `PhysicsContactPreSolve::ignore()`を呼び出すことにより,以降に呼び出される`onContactPreSolve`と`onContactPostSolve`をスキップする事ができます。( 既定値ではtrueを返し衝突します )

`onContactPostSolve`は各ステップで処理された2つの形状が呼び出されます。 ここでは,ボディを削除するなどの操作が行えます。 

`onContactSeperate`は2つの形状が離れた時1度だけ呼び出されるので,`onContactBegin`と対になっている関数だと思ってください。 ここでは`PhysicsContact::setData()`を使い,登録したユーザデータを破棄することができます。

## デモ
<https://github.com/Yangtb/newPhysics.git>から上記のプログラムのデモを見ることができます。

デモはcocos2d-x-3.0alpha1に基いているので,この[ページ](http://cdn.cocos2d-x.org/cocos2d-x-3.0alpha1.zip)からダウンロードしてください。 ダウンロードができたらプロジェクトを置くフォルダとして,**cocos2d-x-3.0alpha1/projects**を作成してください。

また,Physicsの使い方を学ぶ方法として,test-cppのPhysicsTestがあります。