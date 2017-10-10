<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Scene
In your game you probably want a main menu, a few levels and an ending scene.
How do you organize all of these into the separate pieces they are? You guessed
it, `Scene`. When you think about your favorite movie you can see that it's
distinctly broken down into scenes, or separate parts of the story line. If we
apply this same thought process to games, we should come up with at least a few
scenes no matter how simple the game is.

Taking another look at the familiar image from earlier:

![](basic_concepts-img/2n_main.png "")

This is a main menu and it is a single `Scene`. This scene is made up of
several pieces that all fit together to give us the end result. Scenes are drawn
by the __renderer__. The __renderer__ is responsible for rendering sprites and
other objects into the screen. To better understand this we need to talk a bit
about the __scene graph__.

### Scene Graph
A __scene graph__ is a data structure that arranges a graphical scene. A
__scene graph__ contains `Node` objects in a tree (yes, it is called
__scene graph__, but it is actually represented by a __tree__) structure.

![](basic_concepts-img/tree.jpg "Simple Tree")

It sounds and looks complicated. I'm sure you are asking why should you care
about this technical detail if Cocos2d-x does the heavy lifting for you? It
really is important to understand how Scenes are drawn by the renderer.

Once you start adding nodes, sprites and animations to your game, you want to
make sure you are drawing the things you expect. But what if you are not?  What
if your sprites are hidden in the background and you want them to be the
foremost objects? No big deal, just take a step back and run through the scene
graph on a piece of paper, and I bet you find your mistake easily.

Since the _Scene Graph_ is a tree; you can __walk the tree__. Cocos2d-x uses
the __in-order walk__ algorithm. An __in-order walk__ is the left side of the
tree being walked, then the root node, then the right side of the tree. Since
the right side of the tree is rendered last, it is displayed first on the
__scene graph__.

![](basic_concepts-img/in-order-walk.png "in-order walk")

The __scene graph__ is easily demonstrated, let's take a look at our game scene
broken down:

![](basic_concepts-img/2n_main.png "")

Would be rendered as a tree, simplified to the following:

![](basic_concepts-img/2n_mainScene-sceneGraph.png "")

Another point to think about is elements with a negative __z-order__ are on the
left side of the tree, while elements with a positive __z-order__ are on the right
side.  Keep this in consideration when ordering your elements! Of course, you
can add elements in any order, and they're automatically sorted based upon a
customizable __z-order__.

Building on this concept, we can think of a `Scene` as a collection of
`Node` objects. Let's break the scene above down to see the __scene graph__ uses
the __z-order__ to layout the `Scene`:

![](basic_concepts-img/layers.png "")

The `Scene` on the left is actually made up of multiple `Node` objects
that are given a different __z-order__ to make them *stack* on top of each other.

In Cocos2d-x, you build the __scene graph__ using the *addChild()* API call:

{% codetabs name="C++", type="cpp" -%}
// Adds a child with the z-order of -2, that means
// it goes to the "left" side of the tree (because it is negative)
scene->addChild(title_node, -2);

// When you don't specify the z-order, it will use 0
scene->addChild(label_node);

// Adds a child with the z-order of 1, that means
// it goes to the "right" side of the tree (because it is positive)
scene->addChild(sprite_node, 1);
<!--{%- language name="JavaScript", type="js" -%}
// Adds a child with the z-order of -2, that means
// it goes to the "left" side of the tree (because it is negative)
scene.addChild(title_node, -2);

// When you don't specify the z-order, it will use 0
scene.addChild(label_node);

// Adds a child with the z-order of 1, that means
// it goes to the "right" side of the tree (because it is positive)
scene.addChild(sprite_node, 1);-->
{%- endcodetabs %}
