# 日志输出

有时，在你的游戏正在运行的时候，为了了解程序的运行过程或是为了查找一个 BUG，你想看到一些运行时信息，可以! 这个需求引擎已经考虑到了，使用 `log()` 可以把信息输出到控制台，这样使用：

```cpp
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

```

对于使用 C++ 进行游戏开发的用户来说，可能想使用 `std::cout` 而不用 `log()`，实际上 `log()` 更易于使用，它格式化复杂的输出信息更简单。