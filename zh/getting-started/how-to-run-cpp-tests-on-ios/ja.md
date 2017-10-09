# シミュレータを使ったiOS上での実行について
   
## 動作環境

* Mac OS X 10.8 もしくはそれ以上のバーション(ここで使われているのは 10.9 です)
* iOS 5.0 以上
* Xcode  4.6.2 もしくはそれ以上のバージョン(ここで使われているのは 5.0.1 です。 新しいバージョンは以下のURLから入手できます。<https://developer.apple.com/downloads/index.action>)

## プロジェクトの実行

* `cocos2d-x/build` の中にある `cocos2d_tests.xcodeproj`を開きます。
* ドロップダウンの中から`cpp-tests iOS`を選択します。
  
  ![select project](res/select_project.png)
  
* 実行ボタンをクリックしサンプルコードをコンパイル,実行します。

  ![select run button](res/select_run.png)
  
* 成功していれば以下の画像のように表示されます。

  ![run](res/run.png)
  
* 停止ボタンをクリックし,サンプルの実行を終了します。

  ![stop](res/select_stop.png)

  
### 実機（iOS）で動作させたい場合

シミュレータで実行したものを,同じように実機で動作させる場合デベロッパー登録を完了させる必要があります。
[IOS Developer Program](https://developer.apple.com/programs/ios/)


