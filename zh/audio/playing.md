<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Play background music
Play an audio file for use as background music. This can be repeated
continuously.

{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// set the background music and continuously play it.
audio->playBackgroundMusic("mymusic.mp3", true);

// set the background music and play it just once.
audio->playBackgroundMusic("mymusic.mp3", false);
{%- endcodetabs %}

## Play a sound effect.
Play a sound effect.

{% codetabs name="C++", type="cpp" -%}
auto audio = SimpleAudioEngine::getInstance();

// play a sound effect, just once.
audio->playEffect("myEffect.mp3", false, 1.0f, 1.0f, 1.0f);
{%- endcodetabs %}
