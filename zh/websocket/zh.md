# 如何使用WebSocket


## 介绍

WebSocket是HTML5开始提供的一种浏览器与服务器间进行全双工通讯的网络技术。在WebSocket API中，浏览器和服务器只需要做一个握手的动作，然后，浏览器和服务器之间就形成了一条快速通道。两者之间就直接可以数据互相传送。

Cocos2d-x引擎集成libwebsockets，并在libwebsockets的客户端API基础上封装了一层易用的接口，使得引擎在C++, JS, Lua层都能方便的使用WebSocket来进行游戏网络通讯。

引擎支持最新的WebSocket Version 13。

## 在C++中使用

详细代码可参考引擎目录下的/samples/Cpp/TestCpp/Classes/ExtensionsTest/NetworkTest/WebSocketTest.cpp文件。

### 头文件中的准备工作

首先需要include WebSocket的头文件。

```
#include "network/WebSocket.h"
```
  
cocos2d::network::WebSocket::Delegate定义了使用WebScocket需要监听的回调通知接口。使用WebSocket的类，需要public继承这个Delegate。

```
class WebSocketTestLayer
: public cocos2d::Layer
, public cocos2d::network::WebSocket::Delegate
```

并Override下面的4个接口：

```
virtual void onOpen(cocos2d::network::WebSocket* ws);
virtual void onMessage(cocos2d::network::WebSocket* ws, const cocos2d::network::WebSocket::Data& data);
virtual void onClose(cocos2d::network::WebSocket* ws);
virtual void onError(cocos2d::network::WebSocket* ws, const cocos2d::network::WebSocket::ErrorCode& error);
```

后面我们再详细介绍每个回调接口的含义。

### 新建WebSocket并初始化

WebSocket.org 提供了一个专门用来测试WebSocket的服务器"ws://echo.websocket.org"。
测试代码以链接这个服务器为例，展示如何在Cocos2d-x中使用WebSocket。

新建一个WebSocket：

```
cocos2d::network::WebSocket* _wsiSendText = new network::WebSocket();
```
init第一个参数是delegate，设置为this，第二个参数是服务器地址。
URL中的"ws://"标识是WebSocket协议，加密的WebSocket为"wss://".

```
_wsiSendText->init(*this, "ws://echo.websocket.org")
```

### WebSocket消息监听

在调用send发送消息之前，先来看下4个消息回调。

#### onOpen

**init**会触发WebSocket链接服务器，如果成功，WebSocket就会调用**onOpen**，告诉调用者，客户端到服务器的通讯链路已经成功建立，可以收发消息了。

```
void WebSocketTestLayer::onOpen(network::WebSocket* ws)
{
	if (ws == _wsiSendText)
	{
		_sendTextStatus->setString("Send Text WS was opened.");
	}
}
```

#### onMessage

**network::WebSocket::Data**对象存储客户端接收到的数据，
isBinary属性用来判断数据是二进制还是文本，len说明数据长度，bytes指向数据。

```
void WebSocketTestLayer::onMessage(network::WebSocket* ws, const network::WebSocket::Data& data)
{
    if (!data.isBinary)
    {
        _sendTextTimes++;
        char times[100] = {0};
        sprintf(times, "%d", _sendTextTimes);
        std::string textStr = std::string("response text msg: ")+data.bytes+", "+times;
        log("%s", textStr.c_str());
        
        _sendTextStatus->setString(textStr.c_str());
    }
}
```

#### onClose

不管是服务器主动还是被动关闭了WebSocket，客户端将收到这个请求后，需要释放WebSocket内存，并养成良好的习惯：置空指针。

```
void WebSocketTestLayer::onClose(network::WebSocket* ws)
{
	if (ws == _wsiSendText)
	{
		_wsiSendText = NULL;
	}
	CC_SAFE_DELETE(ws);
}
```

#### onError

客户端发送的请求，如果发生错误，就会收到onError消息，游戏针对不同的错误码，做出相应的处理。

```
void WebSocketTestLayer::onError(network::WebSocket* ws, const network::WebSocket::ErrorCode& error)
{
	log("Error was fired, error code: %d", error);
	if (ws == _wsiSendText)
	{
		char buf[100] = {0};
		sprintf(buf, "an error was fired, code: %d", error);
		_sendTextStatus->setString(buf);
	}
}
```

### send消息到服务器

在init之后，我们就可以调用send接口，往服务器发送数据请求。send有文本和二进制两中模式。

发送文本

```
_wsiSendText->send("Hello WebSocket, I'm a text message.");
```

发送二进制数据(多了一个len参数)

```
_wsiSendBinary->send((unsigned char*)buf, sizeof(buf));
```

### 主动关闭WebSocket

这是让整个流程变得完整的关键步骤, 当某个WebSocket的通讯不再使用的时候，我们必须手动关闭这个WebSocket与服务器的连接。close会触发**onClose**消息，而后onClose里面，我们释放内存。

```
_wsiSendText->close();
```

## 在Lua中使用

详细代码可参考引擎目录下的/samples/Lua/TestLua/Resources/luaScript/ExtensionTest/WebProxyTest.lua文件。

### 创建WebSocket对象

脚本接口相对C++要简单很多，没有头文件，创建WebSocket对象使用下面的一行代码搞定。
参数是服务器地址。

```
wsSendText = WebSocket:create("ws://echo.websocket.org")
```

### 定义并注册消息回调函数

回调函数是普通的Lua function，4个消息回调和c++的用途一致，参考上面的说明。

```
local function wsSendTextOpen(strData)
	sendTextStatus:setString("Send Text WS was opened.")
end

local function wsSendTextMessage(strData)
	receiveTextTimes= receiveTextTimes + 1
	local strInfo= "response text msg: "..strData..", "..receiveTextTimes    
	sendTextStatus:setString(strInfo)
end

local function wsSendTextClose(strData)
	print("_wsiSendText websocket instance closed.")
	sendTextStatus = nil
	wsSendText = nil
end

local function wsSendTextError(strData)
	print("sendText Error was fired")
end
```

Lua的消息注册不同于C++的继承 & Override，有单独的接口registerScriptHandler。
registerScriptHandler第一个参数是回调函数名，第二个参数是回调类型。
每一个WebSocket实例都需要绑定一次。

```
if nil ~= wsSendText then
	wsSendText:registerScriptHandler(wsSendTextOpen,cc.WEBSOCKET_OPEN)
	wsSendText:registerScriptHandler(wsSendTextMessage,cc.WEBSOCKET_MESSAGE)
	wsSendText:registerScriptHandler(wsSendTextClose,cc.WEBSOCKET_CLOSE)
	wsSendText:registerScriptHandler(wsSendTextError,cc.WEBSOCKET_ERROR)
end
```

### send消息

Lua中发送不区分文本或二进制模式，均使用下面的接口。

```
wsSendText:sendString("Hello WebSocket中文, I'm a text message.")
```

### 主动关闭WebSocket

当某个WebSocket的通讯不再使用的时候，我们必须手动关闭这个WebSocket与服务器的连接，以释放服务器和客户端的资源。close会触发**cc.WEBSOCKET_CLOSE**消息。

```
wsSendText:close()
```

## 在JSB中使用

详细代码可参考引擎目录下的/samples/Javascript/Shared/tests/ExtensionsTest/NetworkTest/WebSocketTest.js文件。

### 创建WebSocket对象

脚本接口相对C++要简单很多，没有头文件，创建WebSocket对象使用下面的一行代码搞定。
参数是服务器地址。

```
this._wsiSendText = new WebSocket("ws://echo.websocket.org");
```

### 设置消息回调函数

JSB中的回调函数是WebSocket实例的属性，使用匿名函数直接赋值给对应属性。可以看出JS语言的特性，让绑定回调函数更加优美。四个回调的含义，参考上面c++的描述。

```
this._wsiSendText.onopen = function(evt) {
	self._sendTextStatus.setString("Send Text WS was opened.");
};

this._wsiSendText.onmessage = function(evt) {
	self._sendTextTimes++;
	var textStr = "response text msg: "+evt.data+", "+self._sendTextTimes;
	cc.log(textStr);

	self._sendTextStatus.setString(textStr);
};

this._wsiSendText.onerror = function(evt) {
	cc.log("sendText Error was fired");
};

this._wsiSendText.onclose = function(evt) {
	cc.log("_wsiSendText websocket instance closed.");
	self._wsiSendText = null;
};
```

### send消息

发送文本，无需转换，代码如下：

```
this._wsiSendText.send("Hello WebSocket中文, I'm a text message.");
```

发送二进制，测试代码中，使用_stringConvertToArray函数来转换string为二进制数据，模拟二进制的发送。
new Uint16Array创建一个16位无符号整数值的类型化数组，内容将初始化为0。然后，循环读取字符串的每一个字符的Unicode编码，并存入Uint16Array，最终得到一个二进制对象。

```
_stringConvertToArray:function (strData) {
	if (!strData)
		return null;

	var arrData = new Uint16Array(strData.length);
	for (var i = 0; i < strData.length; i++) {
		arrData[i] = strData.charCodeAt(i);
	}
	return arrData;
},
```

send二进制接口和send文本没有区别，区别在于传入的对象，JS内部自己知道对象是文本还是二进制数据，然后做不同的处理。

```
var buf = "Hello WebSocket中文,\0 I'm\0 a\0 binary\0 message\0.";
var binary = this._stringConvertToArray(buf);
            
this._wsiSendBinary.send(binary.buffer);
```

### 主动关闭WebSocket

当某个WebSocket的通讯不再使用的时候，我们必须手动关闭这个WebSocket与服务器的连接，以释放服务器和客户端的资源。close会触发**onclose**消息。

```
onExit: function() {
	if (this._wsiSendText)
		this._wsiSendText.close();
},
```