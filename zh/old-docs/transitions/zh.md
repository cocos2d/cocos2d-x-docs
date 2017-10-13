###  场景转换（Transitions）
Cocos2d-x最爽的一个特性之一就是提供了在两个不同场景之间直接转换的能力。例如：淡入淡出，放大缩小，旋转，跳动等。从技术上来说，一个场景转换就是在展示并控制一个新场景之前执行一个转换效果。

场景之间通过TransitionScene系列类来实现过渡跳转的效果。TransitionScene继承于Scene，该系列类主要是与场景切换特效相关的一些使用类。如TransitionFadeDown,TransitionPageTurn,TransitionJumpZoom等等。

下图是TransitionScene的类关系图： 

![](./res/transitionScene.png)

主要的切换特效有：

- TransitionRotoZoom 旋转进入
- TransitionJumpZoom  跳动进入
- TransitionPageTurn 翻页效果进入
- TransitionRadialCCW 钟摆效果
- TransitionMoveInL ／ TransitionMoveInR ／ TransitionMoveInT ／ TransitionMoveInB 左侧／右侧／顶部／底部进入
- TransitionSlideInL／TransitionSlideInR／TransitionSlideInT／TransitionSlideInB  分别从左侧／右侧／顶部／底部滑入
- TransitionShrinkGrow 交替进入
- TransitionFlipX／TransitionFlipY  x轴翻入（左右）／ y轴翻入（上下）
- TransitionFlipAngular  左上右下轴翻入
- TransitionZoomFlipX／TransitionZoomFlipY x轴翻入放大缩小效果（左右）／ y轴翻入放大缩小效果（上下）
- TransitionFadeTR ／TransitionFadeBL／TransitionFadeUp／TransitionFadeDown 小方格右上角显示进入／ 小方格左下角显示进入／ 横条向上显示进入／ 横条向下显示进入
- TransitionSplitCols ／ TransitionSplitRows 竖条切换进入／ 横条切换进入
- TransitionZoomFlipAngular 左上右下轴翻入放大缩小效果
- TransitionFade 渐隐进入
- TransitionCrossFade 渐变进入
- TransitionTurnOffTiles 小方格消失进入
- TransitionRadialCCW／TransitionRadialCW 扇面展开收起

等等，更多效果可查看[官方API](http://cn.cocos2d-x.org/doc/cocos2d-x-3.0/index.html)。

场景转换的实现：

	auto transitions = TransitionMoveInL::create(0.2f, scene);
	Director::getInstance()->replaceScene(transitions);
	
场景的转换是由Director类来控制的，通过调用Director类的replaceScene( Scene *scene ) 方法可直接使用传入的scene替换当前场景来切换画面，当前场景会被释放，它是切换场景时最常用的方法。     
前面说过，场景转换的一系列类都继承于Scene类，所以可以创建一个转场类替代scene，从而实现各种转场的效果。        
`static TransitionMoveInL* create(float t, Scene* scene);`方法中t表示转场到scene的时间。

以上代码的效果图如下：       

![](./res/transition.jpg)
