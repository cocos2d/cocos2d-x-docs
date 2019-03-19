# Storing Game Data
In most every game there are probably items that need to be stored and re-read in again between game play. This could be player information, stats, leaderboards, level progress and so much more. As always there are many ways a developer can choose to store this data. Each approach has advantages and disadvantages. In this tutorial we will explore storing game data with `UserDefault` and `SQLite`.

## UserDefault
`UserDefault` is simple __key/value pair__ data structure. It is a __global singleton__ that can be accessed at any time, much like the __Director__. `UserDefault` is always present, even if you never invoke it. It is just empty. The first time you add a __key/value pair__ an instance is created.

### Accessing UserDefault
Accessing `UserDefault` is as simple as:

```cpp
cocos2d::UserDefault::getInstance()->someFunction();
```

However, if you plan to access `UserDefault` more than once, it is best to grab the instance once and then use it versus accessing it each and every time you need it. Example:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setIntegerForKey("score", 10);
```

### Adding values to UserDefault
Adding __key/value pairs__ to `UserDefault` is easy:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setIntegerForKey("score", 10);
userdefaults->setFloatForKey("some_float", 2.3f);
userdefaults->setDoubleForKey("some_double", 2.4);
userdefaults->setBoolForKey("some_bool", true);
```

### Changing values in UserDefault
It may be necessary to change a __key/value pair__ in `UserDefault`. Perhaps you are storing the players score and it needs to be updated. This is achieved by simply setting the value a second time. Example:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->setStringForKey("message", "Hello");
userdefaults->setStringForKey("message", "Hello Again");
```

### Deleting values to UserDefault
Deleting __key/value pairs__ from `UserDefault` is also easy:

```cpp
auto userdefaults = cocos2d::UserDefault::getInstance();

userdefaults->deleteValueForKey("message");
userdefaults->deleteValueForKey("score");
userdefaults->deleteValueForKey("some_float");
userdefaults->deleteValueForKey("some_double");
userdefaults->deleteValueForKey("some_bool");
```

### Resetting UserDefault
If you wish to clear out `UserDefault` completely and start from scratch you can simple call:

```cpp
cocos2d::UserDefault::getInstance()->flush();
```

### Assigning UserDefault value to Labels
You probably will want to use values stored in `UserDefault` and assign them to `Label` objects for the players to see. You can achieve this with just a few lines of code. Example:

```cpp
char strTemp[256] = "";
    
std::string ret = UserDefault::getInstance()->getStringForKey("message");
sprintf(strTemp, "string is %s", ret.c_str());
some_label->setString(strTemp);
```

## SQLite
If your needs are more advanced than a simple key/value pair you can evaluate using a database to store and manipulate your game data. __SQLite__ is a very popular and commonly used relational database. You can read more about __SQLite__ on the [__SQLite website__](https://sqlite.org/index.html).

### Setting up SQLite
Download the [__SQLite__](https://sqlite.org/download.html) bundle that works for your needs. There are both _source code_ and _pre-compiled binary_ releases. If you use the _source code_ release you can simply drop __sqlite3.h__ and __sqlite3.c__ into your source tree and use __include__ to bring in __SQLite__. If you use _pre-compiled binaries_ you will need to add this as part of your _library search paths_.

### Creating a database
There are a few ways to create a new __SQLite__ database. 

#### Shipping a default database
If you download the [__SQLite CLI__](https://sqlite.org/cli.html) you can use the command-line to interact with __SQLite__ and all of it's functionality. If you choose this approach you will need to ship your database with you game as you are not creating it in code. This method allows you to use less _SQL code_ up front, making your coding a bit less. However, you will still need to use _SQL code_ when your game needs to interact with the database.

#### Programatically creating a database
If you don't wish to ship a default/pre-populated database you can always create a new database on the first launch of the game and then check if the database exists on each subsequent launch. This approach means more code. We will cover this approach in the next sections.

### Working with SQLite programatically
There are several working pieces that are needed to interact with any database, not just __SQlite__. Let's take a look at what they are:

  > __a connection to the database:__ You can either maintain a persistent database connection while you game is running or open and close the connection as needed. If you maintain a persistent database connection, if the dataase connection gets lost you will need to handle these type of error and re-connect (this is unlikely with __SQLite__). If you open and close as needed you always have a connection but if multiple parts of your game are doing this at the same time you may experience locking issues or database corruption.
  
  > __a database to work with:__ either ship one with your game or create one programatically on the first launch. In either case you will need to have a database to work with.

  > __populating the database with default values:__ either shipping a pre-populated database with your game or creating the default values on first launch.

  > __checking values from the database:__ reading data from the database to make decisions in your game.

  > __updating the database as values change:__ as values change, storing them for fuure use (as your game dictates)

  > __closing the database connection when it is not in use:__ this should be done with both a persistent connection and opening a connection as needed. Failure to close the connection can result in data-loss.

#### Use a Manager class?
Using a singleton as a manager class might be a good option. This encapsulates all of the SQL functionality to a single place provided easy access to functions without a lot of mess. A singleton pattern helps provide a __single__(or global) instance of a class. You can read more about [__singleton patterns__](http://gameprogrammingpatterns.com/singleton.html).

A simple __singleton__ may look something like this:

__c++ header__:
```cpp
#ifndef  _SQLMANAGER_H_
#define  _SQLMANAGER_H_

#include <iostream>
#include <string>

class sqlite3;

class SQLManager
{
    public:
        static SQLManager* Instance();
        virtual ~SQLManager() {}
        
        void initInstance();
        bool connect();
        bool isDatabasePopulated();
        bool createDatabaseContents();
        bool createMainTable();
        
        inline bool getIsDatabaseReady() { return _bDatabaseReady; };
        inline sqlite3*& getDatabase() { return _pdb; };
        
        static int executeSelectQueryReturnSingleInt(const std::string& _sql);
        int getKeyByID(const std::string& _key, const std::string& _value);
    
        static std::string getSQLToCheckCounts(const std::string& _tableName);
    
        static void updateKey(const std::string& _key, const int& _value);
        
    private:
        SQLManager();
        SQLManager(const SQLManager&);
        SQLManager& operator= (const SQLManager&);
        static SQLManager* pinstance;
        
        bool _bDatabaseReady = false;
        sqlite3* _pdb;
        std::string _dbFile = "MyDatabase.db3";
        std::string _dbName = "MyDatabase";
        std::string _dbPath;
        int _dbVersion = 1; // increment this when database structure changes
};

#endif // _SQLMANAGER_H_
```

__c++ source__:
```cpp

#include "SQLManager.hpp"
#include "sqlite3.h"
#include "cocos2d.h"

SQLManager* SQLManager::pinstance = 0;

SQLManager::SQLManager() {}

SQLManager* SQLManager::Instance()
{
	if (pinstance == 0)
	{
		pinstance = new SQLManager;
        pinstance->initInstance();
    }
	
	return pinstance;
}

void SQLManager::initInstance()
{
    // what do we need to do when this class is instantiated?
}

bool SQLManager::connect()
{
    // connecting to SQLite
}

bool SQLManager::isDatabasePopulated()
{
    // is our database already populated?
}

bool SQLManager::createDatabaseContents()
{
    // creating the database contents
}

bool SQLManager::createMainTable()
{
    // creating the main table, but you may need more tables...
}

int SQLManager::executeSelectQueryReturnSingleInt(const std::string& _sql)
{
    // returning an int as a result from a query
}

int SQLManager::getKeyByID(const std::string& _key, const std::string& _value)
{
    // obtaining a key
}

std::string SQLManager::getSQLToCheckCounts(const std::string& _tableName)
{
    // checking how many rows a table has
}

void SQLManager::updateKey(const std::string& _key, const int& _value)
{
    // when we need to update data
}
```

This singleton class will continue to be used through the rest of this tutorial, adding to it as needed.
There are arguments for why __singleton__ patterns can be [bad](https://jorudolph.wordpress.com/2009/11/22/singleton-considerations/)

#### Creating a database
To create a new database, it is best to see if an existing database already exists. If it does, it means your game has been played before on this device, no need to create a new one. Let's check for an existing database and if not create a new one using `SQLManager::initInstance()`, `SQLManager::connect()` and `SQLManager::isDatabasePopulated()`:

```cpp
void SQLManager::initInstance()
{
    if (connect())
    {
        if (isDatabasePopulated())
        {
           // the database was found and is populated.
        }
        else
        {
            // a new database was created, so we need to pupulate it.
        }
    }
    else
    {
        // we failed to connect, handle this more gracefully for production!!!
        std::cout << "We cannot connect to database" << std::endl;
    }
}

bool SQLManager::connect()
{
    bool _bConnect = false;
    
	_pdb = NULL;
    
    _dbPath = cocos2d::FileUtils::getInstance()->getWritablePath() + _dbFile;
    
    int result = sqlite3_open(_dbPath.c_str(), &_pdb);
    
    if(result == SQLITE_OK)
    {
        //std::cout << "open database successfull!" << std::endl;
        _bConnect = true;
    }
    
    return _bConnect;
}

bool SQLManager::isDatabasePopulated()
{
    // check to see if the database is populated, this means it already existed. 
    // If it isn't populated we need to populate it with initial values    
}
```

The above code tries to open the specified database, at the specified path. If the file is already present, it opens, ig the file is not present it is still opened, but it would be empty. We don't know which! One solution is to check for the existence of a database table that would be present if your game has already been played. We will go into detail about this next. Before we do, let's make sure that we also understand that calling `cocos2d::FileUtils::getInstance()->getWritablePath()` will ensure that the path we get back is indeed the writeable path on this specific device. As operating systems handle this differently and also have different locations it is important that this call be made and it's return value be used. It is not advised to try and make custom locations outside what the device vendor wishes to allow.

#### Populating a database
As learned above, when trying to open a __SQLite__ database, if it doesn't exist it will be created by the __SQLite__ code. Therefore once you connect to the database,  you don't know if the database already has data for your game or if this was the first time it is being played and therefore has `zero` data in it. You need to make this decision before proceeding because if the database doesn't have the data your game needs, your game fails immediately with errors and the player may never play it again because they think it is a broken or poorly made game.  How might we go about doing this? Remember the unexplained call above to `SQLManager::isDatabasePopulated()`? Let's do the checking there and __return true;__ if the database has previous data and __return false;__ if it does not. If __return false;__ then populating the database with default data is necessary. Consider this code which attepmpts to check for a table named __Master__ to be present:

```cpp
bool SQLManager::isDatabasePopulated()
{
    bool _bPopulated = false;
    
    sqlite3_stmt *statement;
    
    std::string _sql = "SELECT count(*) FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type='table' AND name='" +
    std::string("Master") +
    std::string("' ORDER BY name LIMIT 1;");
    
    //std::cout << "sql: " << _sql << std::endl;
    
    if(sqlite3_prepare_v2(_pdb, _sql.c_str(), -1, &statement, 0) == SQLITE_OK)
    {
        int cols = sqlite3_column_count(statement);
        int result = 0;
        
        while(true)
        {
            result = sqlite3_step(statement);
            
            if(result == SQLITE_ROW)
            {
                for(int col = 0; col < cols; col++)
                {
                    std::string s = (char*)sqlite3_column_text(statement, col);
                    
                    //std::cout << "s: " << s << std::endl;
                    
                    int result = std::stoi(s);
                    
                    if(result == 1) // table exists, 0 if it doesn't exist
                    {
                        //std::cout << "We have AppMaster table" << std::endl;
                        _bPopulated = true;
                    }
                    else
                    {
                        std::cout << "We dont have APPMaster table" << std::endl;
                    }
                }
            }
            else
            {
                break;
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    return _bPopulated;
}
```
If a table named __Master__ exists, __true__ will be returned and then we know we have a database that has been populated before this launch of the game. Meaning we don't need to populate it. We can continue on knowing our database is ready to read/write/update data.

If a table named __Master__ does not exist __false__ is returned and this means we need to populate our database before using it. To do this we need to create tables with rows in them. It's hard to be specific here because each game requires unique data. However, the idea is to use the _SQL CREATE TABLE_ command along with inserting a few rows:

```cpp
// a vector with what values to initially need in the Master table.
const std::vector<std::string> AppDBMasterTableID = {"HighScore", "HighTime", 
        "CurrentScore", "CurrentTime", "CurrentVersion"};
        
//std::cout << "Creating DB Master Table" << std::endl;

_sql = "create table " +
std::string("Master") +
std::string(" (_id TEXT PRIMARY KEY, _value INT);");

//std::cout << "sql: " << _sql << std::endl;

result = sqlite3_exec(_pdb, _sql.c_str(), NULL, NULL, NULL);

if(result == SQLITE_OK)
{
    char buffer[300];
    
    std::vector<int> AppDBMasterTableValue = {0, 0, 0, 0, 1.0};
        
    for (unsigned i = 0; i < AppDBMasterTableID.size(); i++)
    {
        _sql = "INSERT INTO " +
        std::string("Master") +
        std::string(" VALUES ('%s', '%i')");
        
        sprintf(buffer, _sql.c_str(),
                AppDBMasterTableID.at(i).c_str(),
                AppDBMasterTableValue.at(i));
        
        result = sqlite3_exec(_pdb, buffer, NULL, NULL, NULL);
    }
}
```
With this concept, next time the game starts a database will exist and have the default values that are needed. It wont be created every time the game is started. Any new data that is updated or inserted into the database will persist between launches!

#### Querying data in the database
After you have the database starting when the game starts and doing a quick integrity check to make sure it has the minimum necessary daya you will need to query the database from time to time to get values to make decisions. This might mean checking to see if the player beat a previous high score or if a player has beat a particular boss. Querying the database is an easy and common operation using the _SQL SELLECT_ statement. Example:

```sql
SELECT value from Master WHERE id="high score";
```

__SQLite__ is pretty flexible in getting back data and looping over it. Consider something like:

```cpp
std::string _sql = "SELECT " +
std::string(value) +
std::string(" FROM ") +
std::string("Master") +
std::string(" WHERE _id='high score' LIMIT 1;");

sqlite3_stmt* statement;
    
if (sqlite3_prepare_v2(Instance()->getDatabase(), _sql, -1, &statement, 0) == SQLITE_OK)
{
    int cols = sqlite3_column_count(statement);
    int result = 0;
    
    while(true)
    {
        result = sqlite3_step(statement);
        
        if(result == SQLITE_ROW)
        {
            for(int col = 0; col < cols; col++)
            {
                std::string s = (char*)sqlite3_column_text(statement, col);
                
                //std::cout << "s: " << s << std::endl;
                
                return std::stoi(s);
            }
        }
        else
        {
            break;
        }
    }
}

return -1;
```

With this code the high score is returned as a string so that it can be used in a `Label` object. Note that since we are just selecting the _value_ column we only iterate over just that column in the SQL table.

#### Updating data in the database
Updating works just the same as selecting data but with a different SQL statement format. A _SQL UPDATE_ statement will be used instead. Consider:

```cpp
std::string _sql = "UPDATE " +
std::string("Master") +
std::string(" SET _value") +
std::string("=") +
std::to_string(10) +
std::string(" WHERE _id='high score';");

//std::cout << "sql: " << _sql << std::endl;

int result = sqlite3_exec(Instance()->getDatabase(), _sql, NULL, NULL, NULL);

if (result == SQLITE_OK)
{
    std::cout << (std::string("update to Master: ") + std::string(_key.c_str()) + std::string(" successful")) << std::endl;

    // continue on....
}
else
{
    std::cout << (std::string("update to Master: ") + std::string(_key.c_str()) + std::string(" Failed")) << std::endl;

    // throw an error
}
```

In this example the _high score_ is updated.

#### Inserting new data into the database
Inserting data is also easy and the format looks as familiar as the _SQL SELECT_ and _SQL UPDATE_ statements. Consider:

```cpp
std::string _sql = "INSERT INTO " +
std::string("Master") +
std::string(" VALUES ('15')");
```

#### Closing the database connection
While it isn't totally necessary to close a __SQLite__ database, it is a good idea to play it safe and do so. Database corruption is possible if you don't. Consider closing the database where it makes sense in your code, possible on game exit.

```cpp
sqlite3_close();
```