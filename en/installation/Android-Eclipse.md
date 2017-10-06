<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

# Android with Eclipse Installation and Setup

## Prerequisites
* Completed the **[Android Command-Line Instructions](Android-terminal/index.html)**

* Eclipse ADT Bundle [http://www.eclipse.org/downloads/](http://www.eclipse.org/downloads/)

## Open the proj.android project with Eclipse.

* Launch Eclipse

* Right click your mouse at the empty area of the __Package Explorer__ and choose
__Import__.

* Choose __Existing Android Code Into Workspace__ from the pop up dialog and Click
__Next__.

    ![](Android-Eclipse-img/image2.png)

* Click the __Browse__ button to choose the directory of __CPP-Tests__ `proj.android`
and Click __Ok__.

    ![](Android-Eclipse-img/image3.png)

* Click __Finish__.

## Import Libcocos2dx Project
* Same steps as above only using the path of the __libcocos2dx__ project is
__[your own game project folder]/cocos/2d/platform/android/java__.

    ![](Android-Eclipse-img/image5.png)

## Build and Run the Android Project
* Connect your Android phone with __USB remote debugging__ option enabled.

* Make sure your computer can recognize your phone (you might need to install
drivers for your specific phone)

* Right click on the project and choose __Run as__ -> __Android Application__.

    ![](Android-Eclipse-img/image6.png)
