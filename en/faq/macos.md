## MacOS

### XCode PNG Compression issue
It is possible that your PNG images contain incorrect color profiles. You can
convert color profiles using __ImageMagick__ and the following
command:

   ```sh
   find . -type f -name "*.png" -exec convert {} \;
   ```
