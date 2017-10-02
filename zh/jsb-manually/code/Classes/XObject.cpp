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