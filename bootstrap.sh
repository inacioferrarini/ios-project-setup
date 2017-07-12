#!/bin/bash

echo 'Execute this script inside a Xcode project folder.'

# Variables
export RUBY_ENV='RBENV'
export PROJECT_NAME=`basename "$PWD"`
export WORKSPACE_NAME=`basename "$PWD"`
export TEST_SCHEMA_NAME=`basename "$PWD"`
export TESTS_TARGET=$PROJECT_NAME'Tests'
export RUBY_VERSION=2.3.3

# Functions

function setup_rbenv {
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
    source ~/.bash_profile
    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
    rbenv local $RUBY_VERSION    
}

function setup_rvm {
    rvm install $RUBY_VERSION
    rvm local $RUBY_VERSION
}

function install_rbenv {
    brew install rbenv ruby-build
}


# Main

if which rbenv >/dev/null; then
    echo 'Using rbenv'
    export RUBY_ENV='RBENV'
    setup_rbenv
elif which rvm >/dev/null; then
    echo 'Using rvm'
    export RUBY_ENV='RVM'
    setup_rvm
else
    install_rbenv
    setup_rbenv
fi

gem install bundler

if [ ! -f Gemfile ]; then
echo "source \"https://rubygems.org\"

ruby '$RUBY_VERSION'
gem 'cocoapods', '1.0.1'
gem 'slather'
gem 'rake'
gem 'xcodeproj'" >> Gemfile
fi 

bundle install

if [ ! -f Podfile ]; then
bundle exec pod init
fi

if [ ! -f Rakefile ]; then
echo "
desc \"Executes pod install and fix files messed up by Cocoapods.\"
task :install do
sh \"bundle exec pod install\"
end

desc \"Executes pod update and fix files messed up by Cocoapods.\"
task :update do
sh \"bundle exec pod update\"
end

desc \"Generates Slather Code Coverage Report.\"
task :slather do
sh \"killall -9 'Simulator' || true\"
sh \"killall -9 'iOS Simulator' || true\"
sh \"killall -9 com.apple.CoreSimulator.CoreSimulatorService || true\"
sh \"rm -rf ~/Library/Developer/Xcode/DerivedData/* || true\"
sh \"rm -rf ~/Library/Developer/CoreSimulator/* || true\"
sh \"rm -rf slather-report || true\"
sh \"xcodebuild clean build -workspace $WORKSPACE_NAME.xcworkspace -scheme $TEST_SCHEMA_NAME -destination 'platform=iOS Simulator,name=iPhone 5s' VALID_ARCHS=x86_64 test | xcpretty\"
sh \"bundle exec slather > /dev/null\"
sh \"open slather-report/index.html > /dev/null\"
end

desc \"Generates Code Style Report.\"
task :oclint do
sh \"echo oclint ... \"
end
" >> Rakefile
fi

rake install

if [ ! -f .clang-format ]; then
echo "Language:        Cpp
AccessModifierOffset: 0
AlignAfterOpenBracket: Align
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignEscapedNewlinesLeft: true
AlignOperands:   true
AlignTrailingComments: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortBlocksOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: None
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: All
AlwaysBreakAfterReturnType: All
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: false
BinPackArguments: true
BinPackParameters: true
BraceWrapping:
  AfterClass:      false
  AfterControlStatement: false
  AfterEnum:       false
  AfterFunction:   false
  AfterNamespace:  false
  AfterObjCDeclaration: false
  AfterStruct:     false
  AfterUnion:      false
  BeforeCatch:     false
  BeforeElse:      false
  IndentBraces:    false
BreakBeforeBinaryOperators: None
BreakBeforeBraces: Attach
BreakBeforeTernaryOperators: false
BreakConstructorInitializersBeforeComma: false
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit:     100
CommentPragmas:  ''
ConstructorInitializerAllOnOneLineOrOnePerLine: true
ConstructorInitializerIndentWidth: 0
ContinuationIndentWidth: 0
Cpp11BracedListStyle: false
DerivePointerAlignment: true
DisableFormat:   false
ExperimentalAutoDetectBinPacking: false
ForEachMacros:   [ foreach, Q_FOREACH, BOOST_FOREACH ]
IncludeCategories:
  - Regex:           '^\"(llvm|llvm-c|clang|clang-c)/'
    Priority:        2
  - Regex:           '^(<|\"(gtest|isl|json)/)'
    Priority:        3
  - Regex:           '.*'
    Priority:        1
IncludeIsMainRegex: '$'
IndentCaseLabels: false
IndentWidth:     4
IndentWrappedFunctionNames: false
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLinesAtTheStartOfBlocks: true
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: Inner
ObjCBlockIndentWidth: 4
ObjCSpaceAfterProperty: true
ObjCSpaceBeforeProtocolList: true
PenaltyBreakBeforeFirstCallParameter: 100
PenaltyBreakComment: 100
PenaltyBreakFirstLessLess: 0
PenaltyBreakString: 100
PenaltyExcessCharacter: 1
PenaltyReturnTypeOnItsOwnLine: 20
PointerAlignment: Right
ReflowComments:  true
SortIncludes:    true
SpaceAfterCStyleCast: false
SpaceBeforeAssignmentOperators: true
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles:  false
SpacesInContainerLiterals: false
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard:        Cpp11
TabWidth:        4
UseTab:          Never
" >> .clang-format
fi

if [ ! -f .slather.yml ]; then
echo "
workspace: $PROJECT_NAME.xcworkspace
xcodeproj: $PROJECT_NAME.xcodeproj
scheme: $PROJECT_NAME
output_directory: slather-report
source_directory: $PROJECT_NAME
coverage_service: html
ignore:
  - Pods/*
  - $TESTS_TARGET/*
" >>  .slather.yml
fi
