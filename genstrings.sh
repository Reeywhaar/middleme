#!/bin/zsh
function convert {
    for file in $@; do
        print "Converting $file to UTF-8"
        iconv -f utf-16 -t utf-8 $file > temp
        rm $file; mv temp $file
    done
}
genstrings -o en.lproj ./**/*.swift
convert en.lproj/*.strings