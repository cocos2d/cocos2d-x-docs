## 注册事件监听

当我们需求多个节点对象有相同的事件响应时, 可以创建一个事件监听器, 然后通过 __`eventDispatcher`__, 将其注册到多个对象.

以我们之前提到的触摸事件监听器为例

{% codetabs name="C++", type="cpp" -%}
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);
{%- endcodetabs %}

需要注意的是, 在添加到多个对象时, 需要使用 __`clone()`__ 方法.

{% codetabs name="C++", type="cpp" -%}
// Add listener
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1,
sprite1);

// Add the same listener to multiple objects.
_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite2);

_eventDispatcher->addEventListenerWithSceneGraphPriority(listener1->clone(),
 sprite3);
{%- endcodetabs %}

## 移除事件监听

按照下面的方法, 可以将已经添加的事件监听器移除

{% codetabs name="C++", type="cpp" -%}
_eventDispatcher->removeEventListener(listener);
{%- endcodetabs %}

_内置节点对象的事件分发机制, 和我们上面讨论的一致, 比如, 当你点击带有菜单项的菜单时, 也会分发一个事件. 同样的你也可以在内置节点对象上使用 `removeEventListener()` 移除事件监听._
