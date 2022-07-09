#!/bin/bash

cd "$(dirname "$0")"

sizes=(16 32 64 128 256 512 1024)
for i in ${sizes[@]}
do
	convert out/Logo.png -resize $ix$i out/logo-$i.png
done
