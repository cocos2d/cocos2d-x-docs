# How to use WebSocket

## Introduction

WebSocket is a protocol providing full-duplex communications channels over a single TCP connection. The WebSocket protocol was standardized by the IETF as RFC 6455 in 2011, and the WebSocket API in Web IDL is being standardized by the W3C.

Open source library **libwebsockets** has been integrated into Cocos2d-x to support WebSocket. Cocos2d-x provide a set of wrapper APIs on top of libwebsockets to make it easy to use in C++, JavaScript or Lua games.

Cocos2d-x supports the latest WebSocket Version 13.

## Using in C++

You can refer to the detailed code in engine directory:
./samples/Cpp/TestCpp/Classes/ExtensionsTest/NetworkTest/WebSocketTest.cpp

### Preparing the header file

Firstly, you need to include the header file of WebSocket.

```
#include "network/WebSocket.h"
```

Secondly, you class need public inherit from cocos2d::network::WebSocket::Delegate, which defines four message callback functions.


```
class WebSocketTestLayer
: public cocos2d::Layer
, public cocos2d::network::WebSocket::Delegate
```

**Override** callback functions. We will introduce them later.

```
virtual void onOpen(cocos2d::network::WebSocket* ws);
virtual void onMessage(cocos2d::network::WebSocket* ws, const cocos2d::network::WebSocket::Data& data);
virtual void onClose(cocos2d::network::WebSocket* ws);
virtual void onError(cocos2d::network::WebSocket* ws, const cocos2d::network::WebSocket::ErrorCode& error);
```

### Creating and Initializing

WebSocket.org provides a server to test WebSocket, which address is "ws://echo.websocket.org".

Our example will connect to this server to show you how to use WebSocket in Cocos2d-x.

Create a WebSocket:

```
cocos2d::network::WebSocket* _wsiSendText = new network::WebSocket();
```

The init() function accepts two parameter, first is the delegate and second is the URL address to be required. 

**"ws://"** means unencrypted connection while **"wss://"** means encrypted connection.

```
_wsiSendText->init(*this, "ws://echo.websocket.org")
```

### Listening for messages

Before sending message, we need know how to handle network message.

#### onOpen

**init()** will send a network connection request to the server. Once the connection was established, the onOpen() method will be invoked then you can send data to the server.

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

onMessage() method will be called when the WebSocket client received a message from the server. The Message was stored in **network::WebSocket::Data** usually have two types: string or binary. Use the property **isBinary** to determine the type and correctly deal with the data.

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

whenever the connection was close by server or client, client will receive **onClose** message and release memory here is a good habit.

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

If an error was occurred while sending a message to server, client will receive **onError** message.

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

### Sending message

Once the connection was established, you can send a message to the server by calling the WebSocket object's send() method.

Sending text message:

```
_wsiSendText->send("Hello WebSocket, I'm a text message.");
```

Sending binary message:

```
_wsiSendBinary->send((unsigned char*)buf, sizeof(buf));
```

### Closing the connection

When you've finished using the WebSocket connection, call the WebSocket method close() to close connection. close() will trigger **onClose** message.

```
_wsiSendText->close();
```

## Using in Lua

You can refer to the detailed code in engine directory:
./samples/Lua/TestLua/Resources/luaScript/ExtensionTest/WebProxyTest.lua


### Creating a WebSocket object

Coding in Lua is more simpler than in C++. No need to worry about header files. Create a WebSocket object just use the following codes, parameter is the server's URL.

```
wsSendText = WebSocket:create("ws://echo.websocket.org")
```

### Defining and registering callbacks

The description of callback functions, please refer to C++'s which was introduced above.
Define four normal Lua functions as following code:

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

The registration of WebSocket's callbacks in Lua is different from its in C++, you must use registerScriptHandler() method.

The first parameter is the point of callback function, the second parameter is the type of callback message.

```
if nil ~= wsSendText then
	wsSendText:registerScriptHandler(wsSendTextOpen,cc.WEBSOCKET_OPEN)
	wsSendText:registerScriptHandler(wsSendTextMessage,cc.WEBSOCKET_MESSAGE)
	wsSendText:registerScriptHandler(wsSendTextClose,cc.WEBSOCKET_CLOSE)
	wsSendText:registerScriptHandler(wsSendTextError,cc.WEBSOCKET_ERROR)
end
```

### Sending message

There is no different between sending text or binary in Lua.

```
wsSendText:sendString("Hello WebSocket中文, I'm a text message.")
```

### Closing the connection

When you've finished using the WebSocket connection, you have to manually close the connection to release memory. Close() method will trigger **cc.WEBSOCKET_CLOSE** message.

```
wsSendText:close()
```

## Using in JSB


You can refer to the detailed code in engine directory:
./samples/Javascript/Shared/tests/ExtensionsTest/NetworkTest/WebSocketTest.js


### Creating a WebSocket object

Coding in JSB is more simpler than in C++. No need to worry about header files. Create a WebSocket object just use the following codes, parameter is the server's URL.

```
this._wsiSendText = new WebSocket("ws://echo.websocket.org");
```

### Callback functions

The description of callback functions, please refer to C++'s which was introduced above. Callback functions in JSB is a property be assigned with a lambda function. 

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

### Sending message

Once the connection was established, you can send a message to the server by calling the WebSocket object's send() method.

Sending text message:

```
this._wsiSendText.send("Hello WebSocket中文, I'm a text message.");
```

Sending binary message.

The sample code use _stringConvertToArray() method to convert a string to binary data. 

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

var buf = "Hello WebSocket中文,\0 I'm\0 a\0 binary\0 message\0.";
var binary = this._stringConvertToArray(buf);

this._wsiSendBinary.send(binary.buffer);
```

### Closing the connection

When you've finished using the WebSocket connection, you have to manually close the connection to release memory. Close() method will trigger **onclose** message.

```
onExit: function() {
	if (this._wsiSendText)
		this._wsiSendText.close();
},
```