#!/bin/bash

if [ ! -f Gemfile ]; then
  curl -O https://raw.githubusercontent.com/inacioferrarini/ios-project-setup/master/Gemfile
  bundle install
fi

if [ ! -f Rakefile ]; then
  curl -O https://raw.githubusercontent.com/inacioferrarini/ios-project-setup/master/Rakefile
fi

if [ ! -f Podfile ]; then
  bundle exec pod init
  bundle exec pod install
fi
