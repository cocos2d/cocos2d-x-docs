## 解决方案常见问题

### Windows
#### Needing to re-target the Windows SDK

### XCode
#### XCode PNG Compression issue
It is possible that your PNG images contain incorrect color profiles. You can
convert color profiles using __ImageMagick__ and the following
command:

```sh
find . -type f -name "*.png" -exec convert {} \;
```

### Android
#### generateJsonModelDebug FAILED
To solve this issue, please import the project into __Android Studio__, click
`Build/Refresh Linked C++ Projects`.
