# Cocos2d-x xml解析

Cocos2d-x 已经加入了`tinyxml2`用于xml的解析。3.0版本位于`external/tinyxml2`下。2.x版本位于`cocos2dx/support/tinyxml2`下。

tinyxml2 Github地址：[https://github.com/leethomason/tinyxml2](https://github.com/leethomason/tinyxml2)

帮助文档地址：[http://grinninglizard.com/tinyxml2docs/index.html](http://grinninglizard.com/tinyxml2docs/index.html)

##生成xml文档

1. 引入头文件
	
	```
	#include "tinyxml2/tinyxml2.h"
	using namespace tinyxml2;
	```
	
2. xml文档生成
	
	```
	void  HelloWorld::makeXML(const char *fileName)
{
    std::string filePath = FileUtils::getInstance()->getWritablePath() + fileName;
    
    XMLDocument *pDoc = new XMLDocument();
    
    //xml 声明（参数可选）
    XMLDeclaration *pDel = pDoc->NewDeclaration("xml version=\"1.0\" encoding=\"UTF-8\"");
    
    pDoc->LinkEndChild(pDel);
    
    //添加plist节点
    XMLElement *plistElement = pDoc->NewElement("plist");
    plistElement->SetAttribute("version", "1.0");
    pDoc->LinkEndChild(plistElement);
    
    XMLComment *commentElement = pDoc->NewComment("this is xml comment");
    plistElement->LinkEndChild(commentElement);
    
    //添加dic节点
    XMLElement *dicElement = pDoc->NewElement("dic");
    plistElement->LinkEndChild(dicElement);
    
    
    //添加key节点
    XMLElement *keyElement = pDoc->NewElement("key");
    keyElement->LinkEndChild(pDoc->NewText("Text"));
    dicElement->LinkEndChild(keyElement);
    
    XMLElement *arrayElement = pDoc->NewElement("array");
    dicElement->LinkEndChild(arrayElement);
    
    for (int i = 0; i<3; i++) {
        XMLElement *elm = pDoc->NewElement("name");
        elm->LinkEndChild(pDoc->NewText("Cocos2d-x"));
        arrayElement->LinkEndChild(elm);
    }
    
    pDoc->SaveFile(filePath.c_str());
    pDoc->Print();
    
    delete pDoc;
}
	```
	
3. 打印结果

	```
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
    <!--this is xml comment-->
    <dic>
        <key>Text</key>
        <array>
            <name>Cocos2d-x</name>
            <name>Cocos2d-x</name>
            <name>Cocos2d-x</name>
        </array>
    </dic>
</plist>
	```

上面代码使用tinyxml简单生成了一个xml文档。

##解析xml

下面我们就来解析上面创建的xml文档

1. 引入头文件
	
	```
	#include "tinyxml2/tinyxml2.h"
	using namespace tinyxml2;
	```
2. xml解析
	
	```

	void HelloWorld::parseXML(const char *fileName)
	{
    
    std::string filePath = FileUtils::getInstance()->getWritablePath() + fileName;
    XMLDocument *pDoc = new XMLDocument();
    XMLError errorId = pDoc->LoadFile(filePath.c_str());
    
    if (errorId != 0) {
        //xml格式错误
        return;
    }
    
    XMLElement *rootEle = pDoc->RootElement();
    
    //获取第一个节点属性
    const XMLAttribute *attribute = rootEle->FirstAttribute();
    //打印节点属性名和值
    log("attribute_name = %s,attribute_value = %s", attribute->Name(), attribute->Value());

    XMLElement *dicEle = rootEle->FirstChildElement("dic");
    XMLElement *keyEle = dicEle->FirstChildElement("key");
    if (keyEle) {
        log("keyEle Text= %s", keyEle->GetText());
    }
    
    XMLElement *arrayEle = keyEle->NextSiblingElement();
    XMLElement *childEle = arrayEle->FirstChildElement();
    while ( childEle ) {
        log("childEle Text= %s", childEle->GetText());
        childEle = childEle->NextSiblingElement();
    }
    
    delete pDoc;
    
	}
	```
	在节点解析过程中，注意对获取到的节点进行判空处理。


3. 解析结果打印

	```
	cocos2d: attribute_name = version,attribute_value = 1.0
	cocos2d: keyEle Text= Text
	cocos2d: childEle Text= Cocos2d-x
	cocos2d: childEle Text= Cocos2d-x
	cocos2d: childEle Text= Cocos2d-x
	```


##小结
 
 上面的简单示例，演示了如何使用tinyxml进行xml文档生成和解析。更多详细的帮助请参考 tinyxml帮助文档[http://grinninglizard.com/tinyxml2docs/index.html](http://grinninglizard.com/tinyxml2docs/index.html)



