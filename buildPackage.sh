#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
rm -f openfl-share.zip
rm -rf project/obj
lime rebuild . ios
rm -rf project/obj
zip -0r openfl-share.zip extension haxelib.json include.xml java ndll project
