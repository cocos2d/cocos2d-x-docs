# Cocos Documentation User Manual

### Contributing to these docs
Contributions to the Cocos documentation are always welcome. To edit a document, please fork the Cocos [docs repository](https://github.com/cocos2d/cocos2d-x-docs).

Notes:
  - Fork our [docs repo](https://github.com/cocos2d/cocos2d-x-docs)
  - The __en/__ directory contains English contributions. The __zh/__ directory contains 中文 contributions.
  - code blocks must be wrapped in a markdown codeblock. For Markdown help, please see [GitHub Flavored Markdown](https://github.github.com/gfm/)
  - Changes must be tested using `gitbook build` and `gitbook serve`, and must be tested in multiple web browsers. For more information, see the [Requirements](#Requirements) section below.
  - Submit completed changes via a *pull request* so they can be reviewed and merged.

### Requirements
This documentation site is powered by [GitBook](https://www.gitbook.com/). You need [Node.js](https://nodejs.org/en/) and npm to be able to build it.

To install gitbook:

```bash
npm install gitbook-cli -g
```

To install gitbook plugins:

```bash
gitbook install
```

### Preview and Build
To preview the documentation site, run the following command in the cocos2d-x-docs directory:

```bash
gitbook serve
```

This command will build and launch a web server to host the site. It will also enable the *livereload* plugin, which ensures that changes to the markdown source files automatically trigger a rebuild of the documentation site.

To build the html markdown only, use this command:

```bash
gitbook build
```
