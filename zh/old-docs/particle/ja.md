##Cocos2d-x ParticleSystem v2.xとv3.xの違いについて
---
###CCParticleBatchNodeとParticleBatchNode
###*類似性について*
####継承グラフ

![](res/./ParticleBatchNode@2.x.png)   ![](res/./ParticleBatchNode@3.0.png)

両方のクラスはNodeクラス(v2.xではCCNode)とTextureProtocolクラス(v2.xではCCTextureProtocol)を継承しています。

**注意:** この記事の残りの部分は「v3.x」の概念を使用するので,CCプレフィックスをクラス名から削除して使用しています。

ParticleBatchNodeは名前の通り,バッチノードのようなものです。  
自身に子要素を持っている場合,1度のOpenGLコールで子要素も描画することができます。(BatchDraw処理として知られています)

ParticleBatchNodeは唯一のテクスチャ(イメージファイルまたはテクスチャアトラス)を参照しています。  
テクスチャに含まれているParticleSystemのみParticleBatchNodeに追加することができます。

ParticleBatchNodeに追加されている全てのParticleSystemは,1度のOpenGL ESのドローコールで描画されます。

**警告:** もしも,ParticleSystemがParticleBatchNodeに追加されていない場合,各ParticleSystemごとにドローコールが発生してしまう為,効率的ではありません。

###*違いについて*

-  CCプレフィックスの削除。
-  C++11から追加された機能「override」キーワードを使用しています。 例として : ```virtual void addChild( Node* child ) override;```
- ```CCDirector::shareDirector();```ではなく,```Director::getInstance();```を使用してシングルトンを取得します。
-  ```Director::getInstance()->getTextureCache()->addImage( const std::string& path );```を使用して画像をテクスチャキャッシュに追加します。
-  ```CC_SYNTHESIZE( CCTextureAtlas*, m_pTextureAtlas, TextureAtlas );```の代わりにv3.xではインライン関数の```getTextureAtlas();```と```setTextureAtlas( TextureAtlas* atlas );```を使用します。
-  v2.xでは```objectAtIndex( unsigned int index );```を使用していましたが,v3.xでは```getObjectAtIndex( long index );```を使用することができます。
-  v3.xで使用する```BlendFunc::ALPHA_NON_PREMULTIPLIED```は以下のように定義されています : ```const BlendFunc BlendFunc::ALPHA_NON_PREMULTIPLIED = { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA };``` これは,v2.xでマクロとして定義されていた```GL_SRC_ALPHAと GL_ONE_MINUS_SRC_ALPHA```の代わりになります。また,```CC_BLEND_SRC```と```CC_BLEND_DST ```の代わりに```BlendFunc::ALPHA_PREMULTIPLIED```を使用することができます。

---
###CCParticleSystemとParticleSystem
###*類似性について*
####継承グラフ

![](res/./ParticleSystem@2x.png)	![](res/./ParticleSystem@3.0.png)

Particle Systemはパーティクルの基本クラスです。

Particle Systemの属性について :

- emission rate of the particles ( 粒子の排出率 )
- Gravity Mode (Mode A) ( グラヴィティモード )
- gravity ( 重力 )
- direction ( 方向 )
- speed +- variance ( 速度 +- 分散 )
- tangential acceleration +- variance ( 接線加速度 +- 分散 )
- radial acceleration +- variance ( 放射状加速度 +- 分散 )
- Radius Mode (Mode B) ( ラディウスモード )
- startRadius +- variance ( 開始時の半径 +- 分散 )
- endRadius +- variance ( 終了時の半径 +- 分散 )
- rotate +- variance ( 回転 +- 分散 )
- Properties common to all modes ( 共通プロパティモード )
- life +- life variance ( 生存時間 +- 生存時の分散 )
- start spin +- variance ( 開始時の回転値 +- 分散 )
- end spin +- variance ( 終了時の回転値 +- 分散 )
- start size +- variance ( 開始時の大きさ +- 分散 )
- end size +- variance ( 終了時の大きさ +- 分散 )
- start color +- variance ( 開始時の色 +- 分散 )
- end color +- variance ( 終了時の色 +- 分散 )
- life +- variance ( 生存時間 +- 分散 )
- blending function ( ブレンディング機能 )
- texture ( テクスチャ )

Cocos2d-xでは[ParticleDesigner](http://particledesigner.71squared.com/)で制作されたパーティクルをサポートしています。

Particle Designerのラディウスモードは30ヘルツのエミットレートを使用しています。  
ですが,Cocos2d-xでは別の方法をとっています。結果はほとんど変わりません。

Cocos2d-xではParticle Designerで使用された全ての変数とその他の要素をサポートしています。

- パーティクルの回転(ParticleSystemQuadを使用する場合のみサポートしています)
- 接線加速度 (グラヴィティモード)
- 放射状加速度 (グラヴィティモード)
- 半径方向 (ラディウスモード)(Particle Designerは内側方向と外側方向のみをサポートしています)

ランタイムで上記のプロパティを変更することが可能です。

例 :
```emitter.radialAccel = 15;```
```emitter.startSpin = 0;```

###*違いについて*
|*Cocos2d-x-2.x*|*Cocos2d-x-3.x*|
|---------------|---------------|
|` kCCParticleDefaultCapacity `|` kParticleDefaultCapacity `|
|` ParticleSystem::Mode kCCParticleModeGravity `|` ParticleSystem::Mode::GRAVITY `
|` ParticleSystem::Mode kCCParticleModeRadius `|` ParticleSystem::Mode::RADIUS `|
|該当なし|` typedef ParticleSystem::PositionType tPositionType `|
|` kCCPositionTypeFree ` / ` kPositionTypeFree `|` ParticleSystem::PositionType::FREE `|
|` kCCPositionTypeRelative ` / ` kPositionTypeRelative ` |` ParticleSystem::PositionType::RELATIVE `|
|` kCCPositionTypegRrouped ` / ` kPositionTypegRrouped `|` ParticleSystem::PositionType::GROUPED `|
|` kCCParticleDurationInfinity ` / ` kParticleDurationInfinity `|` ParticleSystem::DURATION_INFINITY `|
|` kCCParticleStartSizeEqualToEndSize ` / ` kParticleStartSizeEqualToEndSize `|` ParticleSystem::START_SIZE_EQUAL_TO_END_SIZE `|
|` kCCParticleStartRadiusEqualToEndRadius ` / ` kParticleStartRadiusEqualToEndRadius `|` ParticleSystem::START_RADIUS_EQUAL_TO_END_RADIUS `|

- ```CC_PROPERTY( varType, varName, funName )```と```CC_PROPERTY_READONLY( varType, varName, funName )```マクロの使用を控えるために20以上のインライン関数が定義されています。

|*Cocos2d-x-2.x*|*Cocos2d-x-3.x*|
|---------------|---------------|
|` CC_PROPERTY(int, m_nEmitterMode, EmitterMode) `|`Mode _emitterMode;`	`inline Mode getEmitterMode() const { return _emitterMode; };`	`inline void setEmitterMode(Mode mode) { _emitterMode = mode; };`|
|` CC_PROPERTY(CCParticleBatchNode*, m_pBatchNode, BatchNode) `|`ParticleBatchNode* _batchNode;`	`virtual ParticleBatchNode* getBatchNode() const;`	`virtual void setBatchNode(ParticleBatchNode* batchNode);`|
|` CC_PROPERTY_READONLY(unsigned int, m_uParticleCount, ParticleCount) `|`int _particleCount;`	`inline unsigned int getParticleCount() const { return _particleCount; };`|
|` CC_PROPERTY(float, m_fDuration, Duration) `|`float _duration;`	`inline float getDuration() const { return _duration; };`	`inline void setDuration(float duration) { _duration = duration; };`|
|` CC_PROPERTY_PASS_BY_REF(CCPoint, m_tSourcePosition, SourcePosition) `|`Point _sourcePosition;`	`inline const Point& getSourcePosition() const { return _sourcePosition; };`	`inline void setSourcePosition(const Point& pos) { _sourcePosition = pos; };`|
|` CC_PROPERTY_PASS_BY_REF(CCPoint, m_tPosVar, PosVar) `|`Point _posVar;`	`inline const Point& getPosVar() const { return _posVar; };`	`inline void setPosVar(const Point& pos) { _posVar = pos; };`|
|` CC_PROPERTY(float, m_fLife, Life) `|`float _life;`	`inline float getLife() const { return _life; };`	`inline void setLife(float life) { _life = life; };`|
|` CC_PROPERTY(float, m_fLifeVar, LifeVar) `|`float _lifeVar;`	`inline float getLifeVar() const { return _lifeVar; };`	`inline void setLifeVar(float lifeVar) { _lifeVar = lifeVar; };`|
|` CC_PROPERTY(float, m_fAngle, Angle) `|`float _angle;`	`inline float getAngle() const { return _angle; };`	`inline void setAngle(float angle) { _angle = angle; };`|
|` CC_PROPERTY(float, m_fAngleVar, AngleVar) `|`float _angleVar;`	`inline float getAngleVar() const { return _angleVar; };`	`inline void setAngleVar(float angleVar) { _angleVar = angleVar; };`|
|` CC_PROPERTY(float, m_fStartSize, StartSize) `|`float _startSize;`	`inline float getStartSize() const { return _startSize; };`	`inline void setStartSize(float startSize) { _startSize = startSize; };`|
|` CC_PROPERTY(float, m_fStartSizeVar, StartSizeVar) `|`float _startSizeVar;`	`inline float getStartSizeVar() const { return _startSizeVar; };`	`inline void setStartSizeVar(float sizeVar) { _startSizeVar = sizeVar; };`|
|` CC_PROPERTY(float, m_fEndSize, EndSize) `|`float _endSize;`	`inline float getEndSize() const { return _endSize; };`	`inline void setEndSize(float endSize) { _endSize = endSize; };`|
|` CC_PROPERTY(float, m_fEndSizeVar, EndSizeVar) `|`float _endSizeVar;`	`inline float getEndSizeVar() const { return _endSizeVar; };`	`inline void setEndSizeVar(float sizeVar) { _endSizeVar = sizeVar; };`|
|` CC_PROPERTY_PASS_BY_REF(ccColor4F, m_tStartColor, StartColor) `|`Color4F _startColor;`	`inline const Color4F& getStartColor() const { return _startColor; };`	`inline void setStartColor(const Color4F& color) { _startColor = color; };`|
|` CC_PROPERTY_PASS_BY_REF(ccColor4F, m_tStartColorVar, StartColorVar) `|`Color4F _startColorVar;`	`inline const Color4F& getStartColorVar() const { return _startColorVar; };`	`inline void setStartColorVar(const Color4F& color) { _startColorVar = color; };`|
|` CC_PROPERTY_PASS_BY_REF(ccColor4F, m_tEndColorVar, EndColorVar) `|`Color4F _endColorVar;`	`inline const Color4F& getEndColor() const { return _endColor; };`	`inline void setEndColor(const Color4F& color) { _endColor = color; };`|
|` CC_PROPERTY(float, m_fStartSpin, StartSpin) `|`float _startSpin;`	`inline float getStartSpin() const { return _startSpin; };`	`inline void setStartSpin(float spin) { _startSpin = spin; };`|
|` CC_PROPERTY(float, m_fStartSpinVar, StartSpinVar) `|`float _startSpinVar;`	`inline float getStartSpinVar() const { return _startSpinVar; };`	`inline void setStartSpinVar(float pinVar) { _startSpinVar = pinVar; };`|
|` CC_PROPERTY(float, m_fEndSpin, EndSpin) `|`float _endSpinVar;`	`inline float getEndSpin() const { return _endSpin; };`	`inline void setEndSpin(float endSpin) { _endSpin = endSpin; };`|
|` CC_PROPERTY(float, m_fEndSpinVar, EndSpinVar) `|`float _endSpinVar;`	`inline float getEndSpinVar() const { return _endSpinVar; };`	`inline void setEndSpinVar(float endSpinVar) { _endSpinVar = endSpinVar; };`|
|` CC_PROPERTY(float, m_fEmissionRate, EmissionRate) `|`float _emissionRate;`	`inline float getEmissionRate() const { return _emissionRate; };`	`inline void setEmissionRate(float rate) { _emissionRate = rate; };`|
|` CC_PROPERTY(unsigned int, m_uTotalParticles, TotalParticles) `|`int _totalParticles;`	`virtual int getTotalParticles() const;`	`virtual void setTotalParticles(int totalParticles);`|
|` CC_PROPERTY(CCTexture2D*, m_pTexture, Texture) `|`Texture2D* _texture;`	`virtual Texture2D* getTexture() const override;`	`virtual void setTexture(Texture2D *texture) override;`|
|` CC_PROPERTY(ccBlendFunc, m_tBlendFunc, BlendFunc) `|`BlendFunc _blendFunc;`	`virtual void setBlendFunc(const BlendFunc &blendFunc) override;`	`virtual const BlendFunc &getBlendFunc() const override;`|
|` CC_PROPERTY(bool, m_bOpacityModifyRGB, OpacityModifyRGB) `|`bool _opacityModifyRGB;`	`inline void setOpacityModifyRGB(bool opacityModifyRGB) { _opacityModifyRGB = opacityModifyRGB; };`	`inline bool isOpacityModifyRGB() const { return _opacityModifyRGB; };`	`CC_DEPRECATED_ATTRIBUTE inline bool getOpacityModifyRGB() const { return isOpacityModifyRGB(); }`|
|` CC_PROPERTY(tCCPositionType, m_ePositionType, PositionType) `|`PositionType _positionType;`	`inline PositionType getPositionType() const { return _positionType; };`	`inline void setPositionType(PositionType type) { _positionType = type; };`|
|` CC_SYNTHESIZE(unsigned int, m_uAtlasIndex, AtlasIndex) `|`int _atlasIndex;` `inline int getAtlasIndex() const { return _atlasIndex; };`	`inline void setAtlasIndex(int index) { _atlasIndex = index; };`|

- Cocos2d-x v3.xでは```std::string _configName;```と```int _yCoordFlipped;```という新しい属性が使用されています。

---
###CCParticleSystemQuadとParticleSystemQuad
###*類似性について*
####継承グラフ

![](res/./ParticleSystem@2x.png)	![](res/./ParticleSystem@3.0.png)

ParticleSystemQuadはParticleSystemのサブクラスであり,ParticleSystemの全ての機能が含まれています。

ParticleSystemQuadの独自機能と制限事項

- 粒子のサイズは浮動小数点型(float)を使用することができます。
- システムのスケーリングをすることができます。
- 粒子を回転させることができます。
- SubRectsをサポートしています。
- 1.1以降バッチレンダリングをサポートしています。

###*違いについて*

v3.xはv2.xとは大きな差がないので,v2.xの操作をするような感覚で使用することができると思います。
詳しく閲覧したい場合はこの[リンク](http://cocos2d-x.org/wiki/Reference)をご覧になってください。

###*サンプル*
- 以下がParticleSystemのサンプルになります。

![](res/./ParticleSystemEffect.png)

	/*
		// Cocos2d-x v2.x
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		ParticleSystemQuad* m_emitter = ParticleSystemQuad::createWithTotalParticles( 900 );
		m_emitter->setTexture( CCTextureCache::sharedTextureCache()->addImage( "fire.png" ) );
	*/
		// Cocos2d-x v3.x
		auto size = Director::getInstance()->getWinSize();
		auto m_emitter = ParticleSystemQuad::createWithTotalParticles( 900 );
		m_emitter->setTexture( Director::getInstance()->getTextureCache()->addImage( "fire.png" ) );
	
		// v2.x及びv3.xで使用することができます
		m_emitter->setDuration( -1 );
		m_emitter->setGravity( Point( 0, -240 ) );  // v2.xでは CCPoint( 0, -240 )
		m_emitter->setAngle( 90 );
		m_emitter->setAngleVar( 360 );
		m_emitter->setRadialAccel( 50 );
		m_emitter->setRadialAccelVar( 0 );
		m_emitter->setTangentialAccel( 30 );
		m_emitter->setTangentialAccelVar( 0 );
		m_emitter->setPosition( Point( size.width / 2, size.height ) );
		m_emitter->setPosVar( Point( 400, 0 ) );
		m_emitter->setLife( 4 );
		m_emitter->setLifeVar( 2 );
		m_emitter->setStartSpin( 30 );
		m_emitter->setStartSpinVar( 60 );
		m_emitter->setEndSpin( 60 );
		m_emitter->setEndSpinVar( 60 );
		m_emitter->setStartColor( Color4F( 255, 255, 255, 1 ) );
		m_emitter->setStartColorVar( Color4F( 0, 0, 0, 0 ) );
		m_emitter->setEndColor( Color4F( 255, 255, 255, 1 ) );
		m_emitter->setEndColorVar( Color4F( 0, 0, 0, 0 ) );
		m_emitter->setStartSize( 30 );
		m_emitter->setStartSizeVar( 0 );
		m_emitter->setEndSize( 20.0f );
		m_emitter->setEndSizeVar( 0 );
		m_emitter->setEmissionRate( 100 );
		addChild( m_emitter, 10 );

- ParticleSystemにはParticleExplosion, ParticleFire, ParticleFireworks, ParticleFlower, ParticleGalaxy, ParticleMeteor, ParticleRain, ParticleSmoke, ParticleSnow, ParticleSpiral, ParticleSunというサブクラスがあります。これらは一般的なパーティクルエフェクトを簡単に作成することができます。