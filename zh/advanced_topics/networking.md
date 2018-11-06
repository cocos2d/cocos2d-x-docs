# 网络访问

## 使用 HTTP 进行网络访问

有时候我们需要从网络上获取资源数据，一种常见的解决方法就是使用 HTTP 进行网络访问。

使用 HTTP 进行网络访问有三个步骤：

  1. 创建一个 HTTP 请求 `HttpRequest`
  1. 通过 `setResponseCallback()` 设置一个请求完成时的回调函数
  1. 使用 `HttpClient` 发送 `HttpRequest`

`HttpRequest` 有四种类型：_POST_ _PUT_ _DELETE_ _UNKNOWN_。除非指定请求的类型，否则就默认 UNKNOWN。`HttpClient` 对象负责请求的发送，也负责数据的接收。

示例：

```cpp
HttpRequest* request = new (std :: nothrow) HttpRequest();
request->setUrl("http://just-make-this-request-failed.com");
request->setRequestType(HttpRequest::Type::GET);
request->setResponseCallback(CC_CALLBACK_2 (HttpClientTest::onHttpRequestCompleted, this));

HttpClient::getInstance()->sendImmediate(request);

request->release();
```

注意，我们通过 `setResponseCallback()` 设置请求完成时的回调函数了。这样做，在请求完成时，我们就能查看返回的数据，并提取出我们需要的。

回调函数的写法很简单，可以像这样做：

```cpp
void HttpClientTest::onHttpRequestCompleted(HttpClient* sender, HttpResponse* response)
{
  if (!response)
  {
    return;
  }

  // Dump the data
  std::vector<char>* buffer = response->getResponseData();

  for (unsigned int i = 0; i <buffer-> size (); i ++)
  {
    log ("% c", (* buffer) [i]);
  }
}
```
