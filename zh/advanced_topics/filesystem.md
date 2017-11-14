# 文件系统接入

尽管你可以使用 _stdio.h_ 中的函数来访问文件，但是由于以下原因可能会很不方便：

* 获取文件的绝对路径时，需要调用系统的特定 API
* 安装后，资源文件将打包到 .apk 文件中，绝对路径并不适用
* 想根据屏幕分辨率不同，自动加载不同的分辨率资源，如图片

Cocos2d-x 已经提供了 `FileUtils` 类来解决这些问题。`FileUtils` 是一个用于访问 _Resources_ 目录下文件的帮助类。它也能做一些辅助性的事情，比如检查一个文件是否存在。

## 读文件

这是一些读文件的函数，不同的函数读不同类型的文件，返回不同的数据类型

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

## 管理文件

这些函数是用来管理文件，目录的：

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
