#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
rm -f openfl-share.zip
zip -0r openfl-share.zip extension haxelib.json include.xml java 
