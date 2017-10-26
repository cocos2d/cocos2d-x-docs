<div class="langs">
  <a href="#" class="btn" onclick="toggleLanguage()">中文</a>
</div>

## Custom Events
The event types above are defined by the system, and the events (such as touch
screen, keyboard response etc) are triggered by the system automatically. In
addition, you can make your own custom events which are not triggered by the system,
but by your code, as follows:

{% codetabs name="C++", type="cpp" -%}
_listener = EventListenerCustom::create("game_custom_event1", [=](EventCustom* event){
    std::string str("Custom event 1 received, ");
    char* buf = static_cast<char*>(event->getUserData());
    str += buf;
    str += " times";
    statusLabel->setString(str.c_str());
});

_eventDispatcher->addEventListenerWithFixedPriority(_listener, 1);
{%- endcodetabs %}

A custom event listener has been defined above, with a response method, and added
to the event dispatcher. So how is the event handler triggered? Check it out:

{% codetabs name="C++", type="cpp" -%}
static int count = 0;
++count;

char* buf[10];
sprintf(buf, "%d", count);

EventCustom event("game_custom_event1");
event.setUserData(buf);

_eventDispatcher->dispatchEvent(&event);
{%- endcodetabs %}

The above example creates an EventCustom object and sets its UserData. It is then
dispatched manually with `_eventDispatcher->dispatchEvent(&event)`. This triggers
the event handler defined previously. The handler is called immediately so a local
stack variable can be used as the UserData.
