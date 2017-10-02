#cocos2d::Value

- Since: v3.0 beta
- Language: C++

"COCOS2DX_ROOT/cocos/base" 폴더의 "[CCValue.h](https://github.com/andyque/cocos2d-x/blob/develop/cocos/base/CCValue.h)" 에 정의되어 있습니다.

---

```cpp
class Value;
```

---

`cocos2d::Value` 는 여러 프리미티브 타입(`int`,`float`,`double`,`bool`,`unsigned char`,`char*` and `std::string`) 과 `std::vector<Value>`, `std::unordered_map<std::string,Value>`, `std::unordered_map<int,Value>` 을 래핑한 클래스입니다.

여러분은 위에서 언급된 모든 프리미티브 타입 변수들을 `cocos2d::Value` 오브젝트에 담을 수 있으며, 다른 프리미티브 타입으로 변환할 수 있습니다.

내부적으로 `cocos2d::Value` 는 유니온을 구성해 모든 종류의 프리미티브 타입 변수들을 저장하며, 이를 통해 많은 메모리 공간을 절약합니다.

Cocos2d-x v3.0 beta 이전에는, `CCBool`, `CCFloat`, `CCDouble`, `CCinteger` 등의 프리미티브 타입을 래핑한 클래스가 있었습니다. 하지만 이 클래스들은 더 이상 사용되지 않을 것입니다.

*주목*:프리미티브 타입 변수들과 컨테이너를 다룰 때, `cocos2d::Vector<T>`,`cocos2d::Map<K,V>` 와 `cocos2d::Value` 를 사용해 주세요.


##메모리 관리
`cocos2d::Value` 의 메모리는 자동으로 이것의 소멸자에 의해 관리됩니다. 그러니 `cocos2d::Value`의 메모리를 다룰 때에 C++메모리 관리 규범의 정석을 따라주세요.

`cocos2d::Value` 클래스는 아래의 데이터 멤버들을 포함합니다:

```cpp
union
{
    unsigned char byteVal;
    int intVal;
    float floatVal;
    double doubleVal;
    bool boolVal;
}_baseData;

std::string _strData;
ValueVector* _vectorData;
ValueMap* _mapData;
ValueMapIntKey* _intKeyMapData;

Type _type;
```

코드 스니펫을 보면 알 수 있듯이, `_baseData`, `_strData` 와 `_type` 데이터 멤버들의 메모리 관리는 컴파일러와 이들의 소멸자에 의해 자동으로 관리됩니다. `cocos2d::Value` 의 소멸자는 모든 포인터 멤버 변수들을 메모리 해제합니다.(`_vectorData`,`_mapData` and `_intKeyMapData`).

경고: `cocos2d::Value` 는 다른 cocos2 클래스들과는 달리, retain/release 및 레퍼런스 카운트를 이용한 메모리 관리를 사용하지 않습니다!

##기본적인 사용법
`cocos2d::Value` 는 굉장히 직관적입니다.

여기 간단한 예시가 있습니다:

```cpp
Value val;   // 기본 생성자를 호출
if (val.isNull()) {
	log("val is null");
}else{
	std::string str =val.getDescription();
	log("The description of val0:%s",str.c_str());
}
//----------------------------------------------------
Value val1(65);   // 정수로 초기화
//Value val1(3.4f);   // 부동소수점 타입으로 초기화
//Value val1(3.5);   // 고정소수점 타입으로 초기화
log("정수값에 대한 설명:%s",val1.getDescription().c_str());
log("val1.asByte() = %c",val1.asByte());
//----------------------------------------------------
std::string strV = "string";
Value val2(strV);   // string으로 초기화
log("string값에 대한 설명:%s",val2.getDescription().c_str());
//----------------------------------------------------
auto sp0 = Sprite::create();
Vector<Object*>* vecV = new Vector<Object*>();
vecV->pushBack(sp0);
Value val3(vecV);   // Vector로 초기화
log("Vector값에 대한 설명:%s",val3.getDescription().c_str());
delete vecV;
//----------------------------------------------------
Map<std::string, Object*>* mapV = new Map<std::string, Object*>();
mapV->insert(strV,sp0);
Value val4(mapV);   // Value 타입으로 초기화
log("Map값에 대한 설명:%s",val4.getDescription().c_str());
delete mapV;
//----------------------------------------------------
Value val6(&val4);   // Value 타입으로 초기화
log("The description of the Value-type value:%s",val6.getDescription().c_str());
//----------------------------------------------------
val2 = val1;   // assigning between 2 Value-type
log("operator-> The description of val2:%s",val2.getDescription().c_str());
val2 = 4;   //assigning directly
log("operator-> The description of val4:%s",val2.getDescription().c_str());
```

output:

```cpp
cocos2d: val is null
cocos2d: 정수값에 대한 설명:
65

cocos2d: val1.asByte() = A
cocos2d: string값에 대한 설명:
string

cocos2d: Vector값에 대한 설명:
true

cocos2d: Map값에 대한 설명:
true

cocos2d: The description of the Value-type value:
true

cocos2d: operator-> The description of val2:
65

cocos2d: operator-> The description of val4:
4
```

##Best Practice
- `cocos2d::Value` 와 새로운 템플릿 컨테이너들(`cocos2d::Vector<T>` and `cocos2d::Map<K,V>`)을 사용하는것이 `cocos2d::CCBool`, `cocos2d::CCFloat`,`cocos2d::CCDouble`,`cocos2d::CCString`,`cocos2d::CCInteger` 와 옛 Objective-c 스타일의 컨테이너(`cocos2d::CCArray` 와 `cocos2d::CCDictionary`)를 사용하는것보다 좋습니다.
- 여러분이 프리미티브 타입 변수의 집합을 다루실 때에는, 프리미티브 타입 변수를 `cocos2d::Value` 로 래핑하세요. 그리고 새로운 템플릿 컨테이너인 `cocos2d::Vector<T>` 와 `cocos2d::Map<K,V>` 를 사용하세요.
