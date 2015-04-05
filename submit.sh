#!/bin/sh
rm abe.zip 2> /dev/null
zip -r abe.zip hxml src test extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit abe.zip
