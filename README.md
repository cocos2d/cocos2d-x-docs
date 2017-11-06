# Cocos Documentation User Manual

### Contributing to these docs
We always welcome contributions to our documentation.

  - Fork our [docs repo](https://github.com/cocos2d/cocos2d-x-docs)
  - __en/__ is for English contributions, __zh/__ is for 中文 contributions.
  - code blocks must be wrapped in special code to work correctly:
    - C++ only code block:
      ```html
      {% codetabs name="C++", type="cpp" -%}
      auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
      {%- endcodetabs %}
      ```
    - C++ and JavaScript code block:
      ```html
      {% codetabs name="C++", type="cpp" -%}
      auto mySprite = Sprite::create("mysprite.png", Rect(0,0,40,40));
      {%- language name="JavaScript", type="js" -%}
      var mySprite = new cc.Sprite(res.mySprite_png, cc.rect(0,0,40,40));
      {%- endcodetabs %}
      ```
  - Test your changes using `gitbook build` and `gitbook serve`. Please test in a few web browsers. See [Requirements](#Requirements).
  - Submit a *pull request* with your changes and we will review and merge it.

## Requirements
This documentation site is powered by [GitBook](https://www.gitbook.com/). You need [Node.js](https://nodejs.org/en/) and npm to be able to build the site.

To install gitbook:

```bash
npm install gitbook-cli -g
```

Install gitbook plugins:

```bash
gitbook install
```

## Preview and Build
To preview the doc, run the following command in cocos2d-x-docs dictionary:

```bash
gitbook serve
```

This will build and launch web server to host the site. It will also enable livereload plugin so your changes to the markdown source file will automatically triggers rebuild of the docs.

If you just want to build the markdown to html, use this command:

```bash
gitbook build
```
