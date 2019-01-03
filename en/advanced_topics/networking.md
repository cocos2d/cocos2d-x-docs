## Networking with HTTP
Sometimes it might be helpful to obtain resources or data from another source.
One common way of doing this is by using an `HTTP` request.

HTTP networking has three steps:
   1. Create an `HttpRequest`
   2. Create a __setResponseCallback()__ callback function for replying to requests.
   3. Send `HttpRequest` by `HttpClient`

`HttpRequest` can have four types:  __POST__, __PUT__, __DELETE__, __UNKNOWN__. Unless
specified the default type is __UNKNOWN__. The `HTTPClient` object controls sending the
__request__ and receiving the data on a __callback__.

Working with an `HTTPRequest` is quite simple:

```cpp
HttpRequest* request = new (std :: nothrow) HttpRequest();
request->setUrl("//just-make-this-request-failed.com");
request->setRequestType(HttpRequest::Type::GET);
request->setResponseCallback(CC_CALLBACK_2 (HttpClientTest::onHttpRequestCompleted, this));

HttpClient::getInstance()->sendImmediate(request);

request->release();
```

Notice that we specified a __setResponseCallback()__ method for when a response is
received. By doing this we can look at the data returned and use it how we might
need to. Again, this process is simple and we can do it with ease:

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
