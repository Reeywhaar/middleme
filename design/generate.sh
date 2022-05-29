#!/bin/bash

cd "$(dirname "$0")"

sizes=(16 32 64 128 256 512 1024)
for i in ${sizes[@]}
do
	convert out/Icon.png -resize $ix$i out/icon-$i.png
done
