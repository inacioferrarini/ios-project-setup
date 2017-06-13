# ios-project-setup

## About

This script can be use to add common libraries and tools to an already existing Xcode project. 
As a safety measure, if a file already exists, like 'Podfile', it will not be override. If the file does not exists, it will be created by the script, using default values.

## Content



## Executing it
1. CD to the directory having the .xcodeproj file.
2. Execute
```
sh <(curl https://raw.githubusercontent.com/inacioferrarini/ios-project-setup/master/bootstrap.sh)
```
