## JavaScript Manual Binding

Cocos2d-x allows you using JavaScript to call C++ classes, and vice versa. In this way, you can only care about the logical by using JavaScript to complete game. So you can introduce your own API, which is written by C++ and can be called by JS. It's a good way to enlarge game library. If you tend to customize game library, you may love this.

### Create a JS project

Cocos2d-x 3.0alpha1 allows you using **create_project.py** to create a JS project. Create a JS project named JSBMaualBinding in this way.

```
cd ~/cocos2d-x-3.0alpha1/tools/project-creator

./create_project.py -p JSBMaualBinding -k com.cocos2d-x.org -l javascript 
```

### Define your C++ classes

Now create C++ class **XObject**, which will be bound to JS, and put them in **Classes** folder. All the C++ classes need to put in this folder. For **XObject** instance, let's check out the class.


```
XObject.h

#ifndef __JSBManualBinding__XObject__
#define __JSBManualBinding__XObject__

// A function pointer, which points to callback function
typedef void (*XObjectCallFunc)(void *selector, int value);

class XObject
{
public:
    XObject(void *selector, XObjectCallFunc func);
    void logAndCallBack(int value);
private:
    void *m_selector;
    XObjectCallFunc m_callback;
};

#endif /* defined(__JSBManualBinding__XObject__) */
```

The class defines a constructor and a callback function. The second parameter of constructor is a function pointer, which point to callback function.

```
XObject.cpp

#include "XObject.h"
#include "ScriptingCore.h"

XObject::XObject(void *selector, XObjectCallFunc func)
{
    m_selector = selector;
    m_callback = func;
}

void XObject::logAndCallBack(int value)
{
    log("logAndCallBack:%d", value);
    m_callback(m_selector, value);
}
```

The implementation of constructor and callback function. When the callback function being called, you can see the log information in console.

### Bind C++ classes

Time to bind your class. Create a class **JSB_Manual_XObject** to bind class **XObject** class to JS. Also, you need to put them in **Classes** file folder. You have to remember some points before started:

1. Register a JS class, which is the C++ class you need to bind.
2. A JS class has constructor, destructor and a creator function.
3. Bind all the functions of C++ class to JS class.

Add following codes to **JSB_Manual_XObject.h**

```
#ifndef __JSB_MANUAL_XOBJECT__
#define __JSB_MANUAL_XOBJECT__

#include "jsapi.h"

// This function is used to register the bound C++ class
void JSB_register_XObject(JSContext* cx, JSObject* obj);

#endif /* defined(__JSB_MANUAL_XOBJECT__) */
```

Then check out **JSB_Manual_XObject.cpp**

```
#include <stdio.h>

// Two head files have to reference
#include "XObject.h"
#include "ScriptingCore.h"

static JSClass* JSB_XObject_class = NULL;
static JSObject* JSB_XObject_object = NULL;

// 1.
static void JSB_XObject_finalize(JSFreeOp *fop, JSObject *obj)
{
	CCLOGINFO("jsbindings: finalizing JS object %p (XObject)", obj);
    XObject *newObject = (XObject *)JS_GetPrivate(obj);
    JS_SetPrivate(obj, NULL);
    delete newObject;
}

// 2.
static void JSB_XObject_Callback(void *selector, int value)
{
    JSObject *jsobj = (JSObject *)selector;
    jsval param[] = {
        INT_TO_JSVAL(value)
    };
    jsval retval;
    ScriptingCore::getInstance()->executeFunctionWithOwner(OBJECT_TO_JSVAL(jsobj), "callback", 1, param, &retval);
}

// 3.
static JSBool JSB_XObject_constructor(JSContext *cx, unsigned argc, JS::Value *vp)
{
    if (argc == 0) {
        JSObject *jsobj = JS_NewObject(cx, JSB_XObject_class, JSB_XObject_object, NULL);
        XObject *newObject = new XObject(jsobj, JSB_XObject_Callback);
        JS_SetPrivate(jsobj, (void *)newObject);
        JS_SET_RVAL(cx, vp, OBJECT_TO_JSVAL(jsobj));
        return JS_TRUE;
    }
    JS_ReportError(cx, "Wrong number of arguments: %d, was expecting: %d", argc, 0);
    return JS_FALSE;
}

// 4.
static JSBool JSB_XObject_logAndCallBack(JSContext *cx, uint32_t argc, jsval *vp)
{
    JSB_PRECONDITION2(argc==1, cx, JS_FALSE, "Invalid number of arguments");
    jsval *argvp = JS_ARGV(cx,vp);
    
    JSObject *jsObj = (JSObject *)JS_THIS_OBJECT(cx, vp);
    XObject *newObject = (XObject *)JS_GetPrivate(jsObj);
    // call native member function
    newObject->logAndCallBack(JSVAL_TO_INT(argvp[0]));
    
    JS_SET_RVAL(cx, vp, JSVAL_VOID);
    return JS_TRUE;
}

// 5.
static void JSB_XObject_createClass(JSContext *cx, JSObject* globalObj, const char* name)
{
	JSB_XObject_class = (JSClass *)calloc(1, sizeof(JSClass));
	JSB_XObject_class->name = name;
	JSB_XObject_class->addProperty = JS_PropertyStub;
	JSB_XObject_class->delProperty = JS_DeletePropertyStub;
	JSB_XObject_class->getProperty = JS_PropertyStub;
	JSB_XObject_class->setProperty = JS_StrictPropertyStub;
	JSB_XObject_class->enumerate = JS_EnumerateStub;
	JSB_XObject_class->resolve = JS_ResolveStub;
	JSB_XObject_class->convert = JS_ConvertStub;
	JSB_XObject_class->finalize = JSB_XObject_finalize;
	JSB_XObject_class->flags = JSCLASS_HAS_PRIVATE;
	
    // no property for this class
	static JSPropertySpec properties[] = {
        {0, 0, 0, 0, 0}
	};
    
    // define member function
	static JSFunctionSpec funcs[] = {
		JS_FN("logAndCallBack", JSB_XObject_logAndCallBack, 1, JSPROP_PERMANENT  | JSPROP_ENUMERATE),
		JS_FS_END
	};
    
	static JSFunctionSpec st_funcs[] = {
		JS_FS_END
	};
	
	JSB_XObject_object = JS_InitClass(
                                     cx,
                                     globalObj,
                                     NULL,
                                     JSB_XObject_class,
                                     JSB_XObject_constructor,
                                     0,
                                     properties,
                                     funcs,
                                     NULL,
                                     st_funcs);
}

// 6. 
void JSB_register_XObject(JSContext *cx, JSObject *obj)
{
    // define name space
    JSObject *myBinding = JS_NewObject(cx, NULL, NULL, NULL);
    JS::RootedValue myBindingVal(cx);
    myBindingVal = OBJECT_TO_JSVAL(myBinding);
	JS_SetProperty(cx, obj, "MyBinding", myBindingVal);
    // register class
    JSB_XObject_createClass(cx, myBinding, "XObject");
}
```

Let's familiar with the procedures:

1. The destructor of the JS class, which is also the destructor of the bound C++ class.
2. It's the callback method of the JS class, which is named as **callback**. Remember **callback** is a method of JS class, which means you can use this method call C++ class's callback function. You can name it whatever you want.
3. The constructor of the JS class, it does some initializing works.
4. This method is for binding C++ class's callback function-**logAndCallBck**.
5. Create a JS class by this method. In this method, you have to define all the functions in C++ class. It's an important step. Don't miss the name of parameters. For instance, **logAndCallBack** is the name of C++ function, and **JSB_XObject_logAndCallBack** is the name of bound C++ function.
6. In this method, you gave the C++ class a new name-**MyBinding**. So **MyBinding** can be treated as a JS class. And register the JS class.

You are almost complete the procedure. The last step is test the class, let's check out if the C++ class have bound to JS object - **MyBinding**.

### Test

There is a **myApp.js** file at **Resources/res**. Add following codes in **onEnter** function of **MyScene**:

```
var MyScene = cc.Scene.extend({
    ctor:function() {
        this._super();
        cc.associateWithNative( this, cc.Scene );
    },

    onEnter:function () {
        this._super();
        var layer = new MyLayer();
        this.addChild(layer);
        layer.init();
                              
        // test myBinding
        var obj = new MyBinding.XObject();
        obj.callback = function (value) {
                                 cc.log(value);
                              };
        obj.logAndCallBack(11);
    }
});
```

If you see following result in output windows, congratulations you made it!


![logInfo](res/logInfo.png)