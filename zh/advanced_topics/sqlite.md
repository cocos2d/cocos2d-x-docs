## SQLite

__SQLite__ is a self-contained SQL database engine. This means there is no server
involved. __SQLite__ runs while your game is running and you write code to connect
to the database and manipulate its contents. This is by no means a comprehensive
guide, in fact, we cover 1% of what __SQLite__ can do for you. Please read their
[website](http://sqlite.org) for a lot more detail as to what functionality __SQLIte__
offers developers.

### Getting Started.
In-order to use __SQLite__ you must download it and add it to your project. Please
see the [SQLite Downloads](http://sqlite.org/download.html) page for more details.
For our purposes you will just need __sqlite.h__ and __sqlite.c__ in your project.
Add these files to your environment and make sure they are part of your build process.

#### How Does SQL Work In A Game?
Now that you have __SQLite__ you must understand how using a database in your app
works. There isn't any automatic benefit, unless you code it. There are no wizards
and no functionality for *free*. This is hand coded, by you, to meet your specific
needs. Generally speaking, you will need to evaluate the following:

* Does your database already exist?
  * Yes? Connect to it.
  * No? Create it, probably using *create table* queries. Then connect to it.

* Are you connected to the database?
  * Yes? Issue queries against it to achieve your goals.
  * No? Connect to it, then issue queries against it to achieve your goals.

* Do you need to update your database based upon player achievements?
  * Yes? Run *insert/update* queries to change the database.
  * No? Probably *select* queries are enough to use the database to drive your game
  play.

* Is the player done with your game?
  * Yes? Make sure to close the database when your game exists. Failure to do so
  may corrupt your database and make it unusable.

### Basic Database Creation And Manipulation
Let's cover how to create a simple database, connect to it and then manipulate it.

#### Creating A Simple Database
In order to use your database, it must exist. __SQLite__ is *file based*. Simply
creating a new file to house your database is sufficient. Notice that we use a
__.db__ file extension to help notate that this is indeed our database. It is also
important to understand where the database lives on the players device. When you
create the database it must be put in a location that the device allows the player
to write data to. Cocos2d-x helps make this easy with a file system API called
`getWriteablePath()`. Here is an example:

```cpp
sqlite3* pdb;

pdb = NULL;

std::string dbPath = cocos2d::FileUtils::getInstance()->getWritablePath() + "mydatabase.db";

int result = sqlite3_open(dbPath.c_str(), &pdb);

if(result == SQLITE_OK)
  std::cout << "open database successful!" << std::endl;
else   
  std::cout << "open database failed!" << std::endl;
```

With the database open, you can now use it.

#### Creating A Table
Databases use tables to store data. You need at least one table in your database.
The caveat is that you must know what data your table will contain in-order to create
it. You can always use the SQL *alter table* command if at a later tine you need to
modify your tables structure. This is outside the scope of this document, however.
Creating a simple table:

```cpp
int result = 0;
std::string sql;

sql = "create table " +
std::string("Master") +
std::string(" (id TEXT PRIMARY KEY, value INT);");

result = sqlite3_exec(pdb, sql.c_str(), NULL, NULL, NULL);

if(result == SQLITE_OK)
{
  // table created successfully
}
else
{
  // table was NOT created successfully
}
```

#### Querying Data
When you want information from your database you must execute a *select* query to
get it. A *select* query is a *read-only* query. You don't have to worry about
accidentally modifying your game data when running these types of queries. An example
*select* query;

```cpp
std::string key = "Brown";

std::string sql = "SELECT NAME " +
std::string(" FROM ") +
std::string("Master") +
std::string(" WHERE id='") +
std::string(key.c_str()) +
std::string("' LIMIT 1;");

sqlite3_stmt* statement;

if (sqlite3_prepare_v2(&pdb, sql.c_str(), -1, &statement, 0) == SQLITE_OK)
{
  int result = 0;

  while(true)
  {
      result = sqlite3_step(statement);

      if(result == SQLITE_ROW)
      {
          // do something with the row.
      }
      else
      {
          break;
      }
  }
}
```

#### Inserting Data
You may need to insert data into your database to use again at a later time. Use
an *insert* query to do this. Example:

```cpp


```

#### Updating Data


### Closing The Database
