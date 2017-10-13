#ifndef __JSBManualBinding__XObject__
#define __JSBManualBinding__XObject__

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
