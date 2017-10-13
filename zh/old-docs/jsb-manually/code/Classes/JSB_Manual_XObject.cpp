#include <stdio.h>

#include "XObject.h"
#include "ScriptingCore.h"

static JSClass* JSB_XObject_class = NULL;
static JSObject* JSB_XObject_object = NULL;

static void JSB_XObject_finalize(JSFreeOp *fop, JSObject *obj)
{
	CCLOGINFO("jsbindings: finalizing JS object %p (XObject)", obj);
    XObject *newObject = (XObject *)JS_GetPrivate(obj);
    JS_SetPrivate(obj, NULL);
    delete newObject;
}

static void JSB_XObject_Callback(void *selector, int value)
{
    JSObject *jsobj = (JSObject *)selector;
    jsval param[] = {
        INT_TO_JSVAL(value)
    };
    jsval retval;
    ScriptingCore::getInstance()->executeFunctionWithOwner(OBJECT_TO_JSVAL(jsobj), "callback", 1, param, &retval);
}

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
