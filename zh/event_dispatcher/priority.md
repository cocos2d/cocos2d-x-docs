<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## FixedPriority vs SceneGraphPriority
The __EventDispatcher__ uses priorities to decide which listeners get delivered an
event first.

__Fixed Priority__ is an integer value. Event listeners with lower Priority values
get to process events before event listeners with higher Priority values.

__Scene Graph Priority__ is a pointer to a `Node`. Event listeners whose _Nodes_ have
higher __z-order__ values (that is, are drawn on top) receive events before event
listeners whose _Nodes_ have lower __z-order__ values (that is, are drawn below).
This ensures that touch events, for example, get delivered front-to-back, as you
would expect.

Remember the __Basic COncepts__ chapter? Where we talked about the __scene graph__
and we talked about this diagram?

![](basic_concepts-img/in-order-walk.png "in-order walk")

Well, when use __Scene Graph Priority__ you are actually walking this above tree
backwards... __I__, __H__, __G__, __F__, __E__, __D__, __C__, __B__, __A__. If
an event is triggered, __H__ would take a look and either __swallow__ it (more
  on this below) or let is pass through to _I__. Same thing, __I__ will either
  __consume__ it or let is pass through to __G__ and so on until the event either
  __swallowed__ it or does not get answered.
