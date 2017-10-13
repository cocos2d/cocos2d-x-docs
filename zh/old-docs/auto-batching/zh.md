#Auto-batching

## 简介
在游戏的绘制渲染中，往往消耗很多资源和内存，当绘制精灵数量越多，游戏的卡顿会很明显，为了优化和提升渲染效率。Cocos2d-x为我们提供了Auto-batching和SpriteBatchNode。

Auto-batching 意思是Renderer将多次draw的调用打包成一次big Draw 调用。(又名批处理)。

SpriteBatchNode 主要用于批量绘制精灵提高精灵的绘制效率的，需要绘制的精灵数量越多，效果越明显。

## Auto-batching
在3.0版本实现了引擎的逻辑代码与渲染代码的分离，实现了Auto Batch与Auto Culling功能。不再推荐使用SpriteBatchNode提高精灵的绘制效率。

Auto-culling的支持，Sprite在绘制时会进行检查，超出屏幕的不会发给渲染。

###Auto-batching的渲染流程

现在，一个渲染流程是这样的：  
（1）drawScene开始绘制场景  
（2）遍历场景的子节点，调用visit函数，递归遍历子节点的子节点，以及子节点的子节点的子节点，以及…   
（3）对每一个子节点调用draw函数  
（4）初始化QuadCommand对象，这就是渲染命令，会丢到渲染队列里   
（5）丢完QuadCommand就完事了，接着就交给渲染逻辑处理了。  
（6）是时候轮到渲染逻辑干活干活，遍历渲染命令队列，这时候会有一个变量，用来保存渲染命令里的材质ID，遍历过程中就拿当前渲染命令的材质ID和上一个的材质ID对比，如果发现是一样的，那就不进行渲染，保存一下所需的信息，继续下一个遍历。好，如果这时候发现当前材质ID和上一个材质ID不一样，那就开始渲染，这就算是一个渲染批次了。  

看官方的一张图就完全明白了：

![img](src/auto-batching.png)


（7） 因此，如果我们创建了10个材质相同的对象，但是中间夹杂了一个不同材质的对象，假设它们的渲染命令在队列里的顺序是这样的：2个A，3个A，1个B，1个A，2个A，2个A。那么前面5个相同材质的对象A会进行一次渲染，中间的一个不同材质对象B进行一次渲染，后面的5个相同材质的对象A又进行一次渲染。一共会进行三次批渲染。



##SpriteBatchNode
它是批处理绘制精灵，主要是用来提高精灵的绘制效率的，需要绘制的精灵数量越多，效果越明显。因为Cocos2d-x采用opengl es绘制图片的，opengl es绘制每个精灵都会执行：open-draw-close流程。而SpriteBatchNode是把多个精灵放到一个纹理上，绘制的时候直接统一绘制该texture，不需要单独绘制子节点，这样opengl es绘制的时候变成了：open-draw()-draw()…-draw()-close()，节省了多次open-close的时间。SpriteBatchNode内部封装了一个TextureAtlas(纹理图集，它内部封装了一个Texture2D)和一个Array(用来存储SpriteBatchNode的子节点：单个精灵)。注意：因为绘制的时候只open-close一次，所以SpriteBatchNode对象的所有子节点都必须和它是用同一个texture(同一张图片)。

在addChild的时候会检查子节点纹理的名称跟SpriteBatchNode的是不是一样，如果不一样就会出错。

```
    // check Sprite is using the same texture id
    CCASSERT(sprite->getTexture()->getName() == _textureAtlas->getTexture()->getName(), "CCSprite is not using the same texture id");
```

* SpriteBatchNode使用代码示例

```
    auto batch = SpriteBatchNode::create("Images/grossini_dance_atlas.png", 1);
    addChild(batch, 0, kTagSpriteBatchNode);        
    
    auto sprite1 = Sprite::createWithTexture(batch->getTexture(), Rect(85*0, 121*1, 85, 121));
    auto sprite2 = Sprite::createWithTexture(batch->getTexture(), Rect(85*1, 121*1, 85, 121));

       
    auto s = Director::getInstance()->getWinSize();
    sprite1->setPosition( Point( (s.width/5)*1, (s.height/3)*1) );
    sprite2->setPosition( Point( (s.width/5)*2, (s.height/3)*1) );
    
    batch->addChild(sprite1, 0, kTagSprite1);
    batch->addChild(sprite2, 0, kTagSprite2);
```

* SpriteBatchNode和SpriteFrameCache结合使用代码示例

必须保证SpriteFrameCache和SpriteBatchNode加载的是同一纹理贴图。

```
   SpriteFrameCache::getInstance()->addSpriteFramesWithFile("animations/ghosts.plist", "animations/ghosts.png"); 
  
   SpriteBatchNode *batch = SpriteBatchNode::batchNodeWithFile("animations/ghosts.png"); 
   addChild(batch, 0, kTagSprite1); 
  
   Sprite *pFather = Sprite::spriteWithSpriteFrameName("father.gif"); 
   pFather->setPosition(p( s.width/2, s.height/2)); 
   batch->addChild(pFather, 0, kTagSprite2); 
```
##SpriteBatchNode vs. Auto-batching

在3.0版本中提供了新的渲染机制，实现引擎逻辑代码和渲染的分离。该版本依然支持SpriteBatchNode，和以前的版本保持一致。但是不再推荐使用SpriteBatchNode。

Auto-culling的支持，Sprite在绘制时会进行检查，超出屏幕的不会发给渲染。


## 使用Auto-batching

* 需确保精灵对象拥有相同的TextureId(精灵表单spritesheet)；
* 确保他们都使用相同的材质和混合功能
* 不再把精灵添加SpriteBatchNode上
* 避免打乱QuadCommand队列

Auto-batching拥有更好的性能提升。

下面通过代码来分析几种符合Auto-batching使用的情况

1. 使用同一图片生成精灵，加到场景中。此种情况最简单，就是重复添加同一个精灵。 由于满足Auto-batching的条件。此时的渲染批次为2.(首先，即使我一个精灵也不创建，渲染批次也至少是1,加上刚刚这重复添加的精灵的渲染)
	
	```
	Size winSize = Director::getInstance()->getWinSize();
    for(int i = 0; i < 10000; i++)
    {
        Sprite* sprite = Sprite::create("CloseNormal.png");
        sprite->setPosition(Point(CCRANDOM_0_1() * winSize.width, 0 + CCRANDOM_0_1() * winSize.height));
        this->addChild(sprite);
    }
	```
	
2. 使用精灵帧表单，加载生成添加不同的精灵。但是各个精灵的材质都是一样的，满足Auto-batching的条件。此时的渲染批次为2.(首先，即使我一个精灵也不创建，渲染批次也至少是1,加上刚刚这重复添加的精灵的渲染)
	
	```
	SpriteFrameCache::getInstance()->addSpriteFramesWithFile("MatrixLayer.plist");

	Size winSize = Director::getInstance()->getWinSize();
    for(int i = 0; i < 10000; i++)
    {
        char buf[64];
        sprintf(buf,"Item%dn.png", i%5 + 1);
        SpriteFrame *frame= SpriteFrameCache::getInstance()->getSpriteFrameByName(buf);
        Sprite *sprite = Sprite::createWithSpriteFrame(frame);
        sprite->setPosition(Point(CCRANDOM_0_1() * winSize.width, 0 + CCRANDOM_0_1() * winSize.height));
        this->addChild(sprite);
    }

	```
在实际使用中推荐使用这种方式。
	
3. 此种情况假设在不同的zOrder下添加不同的精灵，在遍历子节点之前，其实还偷偷做了一件事情，那就是，调用sortAllChildren();函数对子节点进行排序，虽然重复添加不同材质生成的精灵，但是它们的zOrder不一样，根据zOrder，Auto-batching渲染命令被重新排序，根据材质相同加入渲染队列从而降低了渲染次数。
	
	```
	for(int i = 0; i < 10000; i++)
    {
        Sprite* sprite1 = Sprite::create("CloseNormal.png");
        sprite1->setPosition(Point(CCRANDOM_0_1() * winSize.width, 0 + CCRANDOM_0_1() * winSize.height));
        this->addChild(sprite1);
        
        Sprite* sprite2 = Sprite::create("CloseSelected.png");
        sprite2->setPosition(Point(CCRANDOM_0_1() * winSize.width, 0 + CCRANDOM_0_1() * winSize.height));
        this->addChild(sprite2);
        sprite2->setZOrder(1);

    }
	```
如果注释掉sprite2->setZOrder(1);你会发现渲染批次会升高。


