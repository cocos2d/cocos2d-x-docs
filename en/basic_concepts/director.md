<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Director
Cocos2d-x uses the concept of a `Director`, just like in a movie! The `Director`
controls the flow of operations and tells the necessary recipient what to do.
Think of yourself as the _Executive Producer_ and you tell the `Director` what
to do! One common `Director` task is to control `Scene` replacements and
transitions. The `Director` is a shared singleton (effectively, there's only one
instance of the class at a time) object that you can call from anywhere in your
code.

Here is an example of a typical game flow. The `Director` takes care of
transitioning through this as your game criteria decides:

![](basic_concepts-img/scenes.png "")

You are the director of your game. You decide what happens, when and how.
Take charge!
