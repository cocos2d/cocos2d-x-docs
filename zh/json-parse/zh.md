#Cocos2d-x 3.0 Json用法

Cocos2d-x 3.0 加入了rapidjson库用于json解析。位于external/json下。

rapidjson 项目地址：[http://code.google.com/p/rapidjson/](http://code.google.com/p/rapidjson/)
wiki：[http://code.google.com/p/rapidjson/wiki/UserGuide](http://code.google.com/p/rapidjson/wiki/UserGuide)

下面就通过实例代码讲解rapidjson的用法。

##使用rapidjson解析json串

1. 引入头文件 

	```
	#include "json/rapidjson.h"
	#include "json/document.h"
	```
2. json解析

	```
	std::string str = "{\"hello\" : \"word\"}";
    CCLOG("%s\n", str.c_str());
    rapidjson::Document d;
    d.Parse<0>(str.c_str());
    if (d.HasParseError())  //打印解析错误
    {
        CCLOG("GetParseError %s\n",d.GetParseError());
    }
    
    if (d.IsObject() && d.HasMember("hello")) {
        
        CCLOG("%s\n", d["hello"].GetString());//打印获取hello的值
    }
	```
3. 打印结果

	```
	cocos2d: {"hello" : "word"}

	cocos2d: word
	```
	
注意：只支持标准的json格式，一些非标准的json格式不支持。

一些常用的解析方法需要自己封装。注意判断解析节点是否存在。


##使用rapidjson生成json串

1. 引入头文件 

	```
	#include "json/document.h"
	#include "json/writer.h"
	#include "json/stringbuffer.h"
	using namespace  rapidjson;
	```
2. 生成json串

	```
	rapidjson::Document document;
    document.SetObject();
    rapidjson::Document::AllocatorType& allocator = document.GetAllocator();
    rapidjson::Value array(rapidjson::kArrayType);
    rapidjson::Value object(rapidjson::kObjectType);
    object.AddMember("int", 1, allocator);
    object.AddMember("double", 1.0, allocator);
    object.AddMember("bool", true, allocator);
    object.AddMember("hello", "你好", allocator);
    array.PushBack(object, allocator);
    
    document.AddMember("json", "json string", allocator);
    document.AddMember("array", array, allocator);
    
    
    StringBuffer buffer;
    rapidjson::Writer<StringBuffer> writer(buffer);
    document.Accept(writer);

    CCLOG("%s",buffer.GetString());
	```
3. 打印结果

 	```
 	cocos2d: {"json":"json string","array":[{"int":1,"double":1,"bool":true,"hello":"你好"}]}
 	```