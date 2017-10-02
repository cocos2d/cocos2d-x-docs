#HttpClient session#

## session概述

###session机制

session机制是一种服务器端的机制，服务器使用一种类似于散列表的结构（也可能就是使用散列表）来保存信息。

当程序需要为某个客户端的请求创建一个session的时候，服务器首先检查这个客户端的请求里是否已包含了一个session标识 - 称为session id，如果已包含一个session id则说明以前已经为此客户端创建过session，服务器就按照session id把这个session检索出来使用（如果检索不到，可能会新建一个），如果客户端请求不包含session id，则为此客户端创建一个session并且生成一个与此session相关联的session id，session id的值应该是一个既不会重复，又不容易被找到规律以仿造的字符串，这个session id将被在本次响应中返回给客户端保存。 保存这个session id的方式可以采用cookie，这样在交互过程中浏览器可以自动的按照规则把这个标识发回给服务器。一般这个cookie的名字都是类似于SEEESIONID，而。比如weblogic对于web应用程序生成的cookie，JSESSIONID=ByOK3vjFD75aPnrF7C2HmdnV6QZcEbzWoWiBYEnLerjQ99zWpBng!-145788764，它的名字就是JSESSIONID。

session，简而言之就是在服务器上保存用户操作的历史信息。服务器使用session id来标识session，session id由服务器负责产生，保证随机性与唯一性，相当于一个随机密钥，避免在握手或传输中暴露用户真实密码。但该方式下，仍然需要将发送请求的客户端与session进行对应，所以可以借助cookie机制来获取客户端的标识（即session id），也可以通过GET方式将id提交给服务器。

* session的原理图：

	![](res/session.png)


##HttpClient session的使用

下面我们结合实例来学习session的一个简单使用场景。玩家登陆游戏，登陆成功，服务器返回sessionID标识此次会话。后面的领取每日登陆奖励请求中都加入此sessionID，服务器上保存用户操作的历史信息实现服务端管理客户端的功能。根据sessionID管理登陆的玩家的会话，并更新玩家领取奖励信息。


## 服务器接口设计

根据上面设计的使用场景，我们的服务器需要支持玩家登录和更新每日登录领取奖励。我们设计了如下的两个服务器接口：

###登陆接口


* URL

	`http://host:port/devicelogin`

* Method

	`POST`

* 参数 

	```
{
	"DeviceID" : "device id of the phone"
}
```

* 返回值

	http response code 200，登陆成功，http头部set-cookie自动包含sessionID。

	```
{
	"IsLottery" : true,
	"NoLootCount" : 0
}
```

参数1:今日是否已领取每日奖励
参数2:装备宝箱未出高级装备次数

> 客户端解析sessionID，并放入后续http请求中。

### 更新每日奖励接口

* URL

	`http://host:port/lotteryed`

* Method

	`POST`

* 参数

	`NULL`

* 返回值

	`http response code 200`(更新成功)


## 客户端实现

###工程创建

打开终端，使用如下命令新建工程：

```
cocos new HelloWorld -p com.your_company.HelloWorld -l cpp 

```

按照上面的操作，我们新建了一个Cocos2d-x v3.x的HelloWorld工程。

工程创建好后，让我们来完成httpClient的post请求玩家登陆，和每日登陆领取金币奖励的客户端网络处理。
 在上一节[如何使用httpClient](../httpclient/zh.md)中已经介绍了httpClient的用法。 下面我们直接进入正题，开始编写代码

首先，在HelloWorldScene.cpp文件中加入下面的实现。
引入头文件和命名空间

```
#include "network/HttpClient.h"
using namespace cocos2d::network;
```

###login
####登陆请求实现

根据服务器接口，新建http请求，添加请求参数。实现代码如下：

```
void HelloWorld::login()
{
    HttpRequest* request = new HttpRequest();
    request->setUrl("http://172.100.104.128:8001/devicelogin");//1
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(CC_CALLBACK_2(HelloWorld::onLoginHttpRequestCompleted,this));
    
    // 添加post请求参数
    const char* postData = "{\
    \"DeviceID\" : \"device id of the phone\"\
    }";
    request->setRequestData(postData, strlen(postData));//2
    request->setTag("login POST");//3
    //cocos2d::network::HttpClient::getInstance()->enableCookies(NULL);
    cocos2d::network::HttpClient::getInstance()->send(request);
    request->release();
}
```

1. 设置登陆请求url
2. 添加请求参数
3. 设置http请求的tag

####登陆的请求回调处理

上面的登陆请求设置了onLoginHttpRequestCompleted方法作为响应函数。无论服务器返回怎样的状态onLoginHttpRequestCompleted都将被调用。在响应方法中我们加入了打印登陆返回信息的代码。实现如下：

```
void HelloWorld::onLoginHttpRequestCompleted(cocos2d::network::HttpClient *sender, cocos2d::network::HttpResponse *response)
{
    if (!response)
	{
		return;
	}
	
    if (0 != strlen(response->getHttpRequest()->getTag()))
	{
		log("%s completed", response->getHttpRequest()->getTag());
	}
    
    //打印 http header信息
    std::vector<char> *header = response->getResponseHeader();
    for (unsigned int i = 0; i < header->size(); i++)
	{
		printf("%c", (*header)[i]);
	}
	printf("\n");
    
    //TODO 登陆成功，服务器会通过set-Cookie,返回sessionID,解析sessionID并保存，用于接下来的请求
    
	int statusCode = response->getResponseCode();
	log("response code: %d", statusCode);
	if (!response->isSucceed())
	{
		log("response failed");
		log("error buffer: %s", response->getErrorBuffer());
		return;
	}
    
	// 打印 response data
	std::vector<char> *buffer = response->getResponseData();
	for (unsigned int i = 0; i < buffer->size(); i++)
	{
		printf("%c", (*buffer)[i]);
	}
	printf("\n");
}
```

编译并运行程序。查看登陆请求的的打印信息。

登陆成功的打印信息如下：

```
HTTP/1.1 200 OK
Set-Cookie: GSessionID=MTQwNjI1Mjg3MnxEdi1CQkFFQ180SUFBUkFCRUFBQV8tWF9nZ0FIQm5OMGNtbHVad3dGQUFOMVNVUUdkV2x1ZERNeUJnSUFCUVp6ZEhKcGJtY01DZ0FJWkdWMmFXTmxTVVFHYzNSeWFXNW5EQmdBRm1SbGRtbGpaU0JwWkNCdlppQjBhR1VnY0dodmJtVUdjM1J5YVc1bkRBb0FDRzVwWTJ0T1lXMWxCbk4wY21sdVp3d0NBQUFHYzNSeWFXNW5EQWtBQjJGalkyOTFiblFHYzNSeWFXNW5EQUlBQUFaemRISnBibWNNQ3dBSmFYTk1iM1IwWlhKNUJHSnZiMndDQWdBQUJuTjBjbWx1Wnd3TkFBdHViMHh2YjNSRGIzVnVkQU5wYm5RRUFnQUFCbk4wY21sdVp3d0tBQWgxYzJWeVJHRjBZUVp6ZEhKcGJtY01BZ0FBfGH2499HK_RENNLNURPmZcbqXAhNonoWkv926tH3MJwC; Path=/; Expires=Fri, 25 Jul 2014 02:47:52 UTC; Max-Age=3600; HttpOnly
Date: Fri, 25 Jul 2014 01:47:52 GMT
Content-Length: 35
Content-Type: text/plain; charset=utf-8

cocos2d: response code: 200
Http Test, dump data: {"IsLottery":false,"NoLootCount":0}
```

通过打印信息，我们可以看到登陆请求，服务器返回的信息中，通过Set-Cookie返回了SessionID。

###lotteryed
####每日登陆奖励

将登陆成功返回的SessionID，加入到http请求的header中进行每日登陆奖励请求。
每日登陆奖励的网络请求的代码和登陆的请求代码很相似，区别在于他们拥有各自的url,网络请求完成的响应处理和不同的请求tag。

实现要点：

在http header中加入SessionID的Cookie，发起请求。

实现代码如下：

```
void HelloWorld::lottery()
{
    HttpRequest* request = new HttpRequest();
    request->setUrl("http://172.100.104.128:8001/lotteryed");//1
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(CC_CALLBACK_2(HelloWorld::onHttpRequestCompleted,this));
    
    //setHeader
    std::vector<std::string> headers;
    headers.push_back("Cookie: GSessionID=MTQwNjI1NjIxMXxEdi1CQkFFQ180SUFBUkFCRUFBQWNfLUNBQU1HYzNSeWFXNW5EQW9BQ0dSbGRtbGpaVWxFQm5OMGNtbHVad3dZQUJaa1pYWnBZMlVnYVdRZ2IyWWdkR2hsSUhCb2IyNWxCbk4wY21sdVp3d0xBQWxwYzB4dmRIUmxjbmtFWW05dmJBSUNBQUVHYzNSeWFXNW5EQTBBQzI1dlRHOXZkRU52ZFc1MEEybHVkQVFDQUFBPXz_BEw8Oo-XGEbCambVDQt2o636QUT_qg2Aj1EZX97ekw==");
    request->setHeaders(headers);//2
    
    //cocos2d::network::HttpClient::getInstance()->enableCookies(NULL);
    
    request->setTag("lotteryed POST");//3
    
    cocos2d::network::HttpClient::getInstance()->send(request);
    request->release();
}
```

1. 设置每日登陆奖励的请求url
2. 将sessionID加入到http请求的头部
3. 设置http请求的tag


###领取每日登陆奖励的网络请求回调处理

在http请求完成的回调中，我们可以通过请求tag区分，当前回调对应哪个网络请求。当然也可以使用setResponseCallback方法设置对应的响应回调处理方法。

由于lottery的http请求回调没返回什么实际参数。奖励领取成功返回http response code 200。

```
void HelloWorld::onLotteryHttpRequestCompleted(cocos2d::network::HttpClient *sender, cocos2d::network::HttpResponse *response)
{
    if (!response)
	{
		return;
	}
	
	int statusCode = response->getResponseCode();
	log("response code: %d", statusCode);
	if (!response->isSucceed())
	{
		log("response failed");
		log("error buffer: %s", response->getErrorBuffer());
		return;
	}
    
    //TODO领取奖励成功
}
```

编译并运行，输出如下信息：

```
cocos2d: response code: 200
```

`response code: 200` 表明使用sessionID进行的每日登陆奖励领取的网络请求成功了。

###sessionID的其他实现方式：

在3.x的版本中，`HttpClient::enableCookies`方法支持http会话使用cookie。 由于sessionID的保存和传递是通过cookie实现的，所以我们可以很方便的使用`HttpClient::enableCookies`方法来实现http client session。

```
cocos2d::network::HttpClient::getInstance()->enableCookies(NULL);
```

##小结

通过以上的玩家登陆游戏和领取每日登陆的网络请求，我们学习了httpclient session的使用。
