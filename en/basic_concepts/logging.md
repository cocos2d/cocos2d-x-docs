 Logging as a way to output messages
Sometimes, when your app is running, you might wish to see messages being written
to the console for informational or debug purposes. This is built into the
engine, using __log()__. Example:

{% codetabs name="C++", type="cpp" -%}
// a simple string
log("This would be outputted to the console");

// a string and a variable
string s = "My variable";
log("string is %s", s);

// a double and a variable
double dd = 42;
log("double is %f", dd);

// an integer and a variable
int i = 6;
log("integer is %d", i);

// a float and a variable
float f = 2.0f;
log("float is %f", f);

// a bool and a variable
bool b = true;
if (b == true)
    log("bool is true");
else
    log("bool is false");

<!--{%- language name="JavaScript", type="js" -%}
// a simple string
cc.log("This would be outputted to the console");

// outputting more than a simple string
var pos = cc._p(sender.x, sender.y);
cc.log("Position x: " + pos.x + ' y:' + pos.y);-->

{%- endcodetabs %}

And, c++ users, if you prefer you can use __std::cout__ in place of __log()__,
however, __log()__ might offer easier formatting of complex output.
