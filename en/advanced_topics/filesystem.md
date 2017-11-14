## File System Access
Even though you can use functions in __stdio.h__ to access files it can be
inconvenient for a few reasons:
* You need to invoke system specific API to get full path of a file.
* Resources are packed into .apk file on Android after installing.
* You want to load a resource (such as a picture) based on resolution automatically.

The `FileUtils` class has been created to resolve these issues. `FileUtils` is a
helper class to access files under the location of your `Resources` directory.
This includes reading data from a file and checking file existence.

### Functions to read file content
These functions will read different type of files and will return different data
types:

<table>
 <tr>
  <th>function name</th>
  <th>return type</th>
  <th>support path type</th>
 </tr>
 <tr>
  <td>getStringFromFile</td>
  <td>std::string</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getDataFromFile</td>
  <td>cocos2d::Data</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getFileDataFromZip</td>
  <td>unsigned char*</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>getValueMapFromFile</td>
  <td>cocos2d::ValueMap</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>getValueVectorFromFile</td>
  <td>std::string</td>
  <td>cocos2d::ValueVector</td>
 </tr>

 </table>

### Functions to manage files or directories
These functions will manage a file or a directory:

<table>
 <tr>
  <th>function name</th>
  <th>support path type</th>
 </tr>
 <tr>
  <td>isFileExist</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>isDirectoryExist</td>
  <td>relative path and absolute path</td>
 </tr>
 <tr>
  <td>createDirectory</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>removeDirectory</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>removeFile</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>renameFile</td>
  <td>absolute path</td>
 </tr>
 <tr>
  <td>getFileSize</td>
  <td>relative path and absolute path</td>
 </tr>
 </table>
