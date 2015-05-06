#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
haxelib remove extension-share
haxelib local extension-share.zip
