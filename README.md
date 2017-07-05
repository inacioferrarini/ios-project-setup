# ios-project-setup

## About

This script can be use to add common libraries and tools to an already existing Xcode project. 
As a safety measure, if a file already exists, like 'Podfile', it will not be override. If the file does not exists, it will be created by the script, using default values.

## Content
This script will execute basic setup creating some configuration files, but will not override existing files.

Created files will assure that target names, directory references and so matches the project's files, targets and directory names.

Steps:

1. Setup rbenv or RVM. If neither is configured, configures rbenv.
2. Installs Bundler
3. If Gemfile file does not exist, creates a default Gemfile.
4. If Podfile does not exist, executes pod init
5. If Rakefile does not exists, creates a default Rakefile.
6. Executes rake install
7. If .clang-format file does not exist, creates a default .clang-format.
8. If .slather.yml file does not exists, creates a default .slather.yml file.


## Executing it
1. CD to the directory having the .xcodeproj file.
2. Execute
```
sh <(curl https://raw.githubusercontent.com/inacioferrarini/ios-project-setup/master/bootstrap.sh)
```
