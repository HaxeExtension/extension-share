#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
rm -f extension-share.zip
rm -rf project/obj
lime rebuild . ios && lime rebuild . blackberry
rm -rf project/obj
zip -0r extension-share.zip extension haxelib.json include.xml java ndll project
