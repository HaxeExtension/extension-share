#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
haxelib remove openfl-share
haxelib local openfl-share.zip
