# 如何使用HttpClient

## 介绍

HttpClient是HTTP客户端的接口。HttpClient封装了各种对象，处理cookies，身份认证，连接管理等。

## 概念

HttpClient的使用一般包含下面6个步骤：

- 创建 HttpRequest 的实例；   
- 设置某种连接方法的类型（GET,POST等），这里通过setUrl传入待连接的地址；    
- 设置响应回调函数，读取response；  
- 添加请求到HttpClient任务队列； 
- 释放连接。无论执行方法是否成功，都必须释放连接；   
- 对得到后的内容进行处理。

## 如何使用

### 引入头文件和命名空间

```
#include "network/HttpClient.h"
using namespace cocos2d::network;
```

### HttpRequest 实例

我们将使用HttpRequest无参数的构造函数，它为大多数情况提供了一个很好的默认设置，所以我们使用它。

```
HttpRequest* request = new HttpRequest();
```

### 设置连接方法的类型和待连接的地址

由HTTP规范定义的各种方法对应各种不同的HttpRequest类。

我们将使用Get方法，这是一个简单的方法，它只是简单地取得一个URL，获取URL指向的文档。

```
request->setRequestType(HttpRequest::Type::GET);
request->setUrl("http://www.httpbin.org/get");
```

### 设置回调

无论服务器返回怎样的状态，响应主体response body总是可读的，这至关重要。

```
request->setResponseCallback(CC_CALLBACK_2(HelloWorld::onHttpComplete,this));
```

在onHttpComplete里读取响应数据：

```
std::vector<char> *buffer = response->getResponseData();//Get the request data pointer back
```

### 添加请求到HttpClient任务队列

```
cocos2d::network::HttpClient::getInstance()->send(request);
```

### 释放连接

这是一个可以让整个流程变得完整的关键步骤, 我们必须告诉HttpClient，我们已经完成了连接，并且它现在可以重用。如果不这样做的话，HttpClient将无限期地等待一个连接释放，以便它可以重用。

要释放连接，使用:

```
request->release();
```

### 处理响应

现在，我们已经完成了与HttpClient的交互，可以集中精力做我们需要处理的数据。在这个例子中，我们仅仅将它在控制台上输出。

```
// dump data
std::vector *buffer = response->getResponseData();
printf("Http Test, dump data: ");
for (unsigned int i = 0; i < buffer->size(); i++)
{
	printf("%c", (*buffer)[i]);
}
printf("\n");
```

如果你需要把response作为一个流来读取它里面的信息，上面的步骤将会同如何解析这个连接结合，当你处理完所有的数据后，关闭输入流，并释放该连接。


### GET请求示例
 
下面是一个通过HttpClient的HTTP GET请求的例子。

```
    HttpRequest* request = new HttpRequest();
    request->setUrl("http://www.baidu.com");
    request->setRequestType(HttpRequest::Type::GET);
    request->setResponseCallback(CC_CALLBACK_2(HelloWorld::onHttpRequestCompleted,this));
    request->setTag("GET test");
    cocos2d::network::HttpClient::getInstance()->send(request);
    request->release();
```

### POST请求示例
  
下面将发送一个POST请求到URL“http://httpbin.org/post”。

```
    HttpRequest* request = new HttpRequest();
    request->setUrl("http://httpbin.org/post");
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(CC_CALLBACK_2(HelloWorld::onHttpRequestCompleted,this));
    
    // write the post data
    const char* postData = "visitor=cocos2d&TestSuite=Extensions Test/NetworkTest";
    request->setRequestData(postData, strlen(postData));
    request->setTag("POST test");
    cocos2d::network::HttpClient::getInstance()->send(request);
    request->release();
```

### 处理网络回调函数

```
void HelloWorld::onHttpRequestCompleted(HttpClient *sender, HttpResponse *response)
{
	if (!response)
	{
		return;
	}	
	
	// You can get original request type from: response->request->reqType
	if (0 != strlen(response->getHttpRequest()->getTag()))
	{
		log("%s completed", response->getHttpRequest()->getTag());
	}	
	int statusCode = response->getResponseCode();
	char statusString[64] = {};
	sprintf(statusString, "HTTP Status Code: %d, tag = %s", statusCode, response->getHttpRequest()->getTag());
	_labelStatusCode->setString(statusString);
	log("response code: %d", statusCode);	
	if (!response->isSucceed())
	{
		log("response failed");
		log("error buffer: %s", response->getErrorBuffer());
		return;
	}
	// dump data
	std::vector<char> *buffer = response->getResponseData();
	printf("Http Test, dump data: ");
	for (unsigned int i = 0; i < buffer->size(); i++)
	{
		printf("%c", (*buffer)[i]);
	}
	printf("\n");
}
```

### Android

需要注意的是，如果你是Android环境，不要忘了在您的应用程序的Manifest
中增加相应的权限：

```
<uses-permission android:name=”android.permission.INTERNET” />
```

详细代码可参照..\tests\Cpp\TestCpp\Classes\ExtensionsTest\NetworkTest\HttpClientTest.cpp
