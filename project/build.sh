#!/bin/bash
dir=`dirname "$0"`
cd "$dir"

haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
haxelib run hxcpp Build.xml -Diphonesim
