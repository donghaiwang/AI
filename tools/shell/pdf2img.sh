#!/bin/bash
# 将pdf转化为图片
curDir=pwd
for element in `ls detectron-vehicle`
do
    dir_or_file=$1"/"$element
    if [ -d $dir_or_file ]
    then
        getdir $dir_or_file
    else
        sourcePath="detectron-vehicle/"
        sourceFulllfile=${sourcePath}${dir_or_file}
        #echo $sourceFullfile
        dirPrefix="detectron-vehicle-image/"
        imageSuffix=".jpg"
        imageFullfile=${dirPrefix}${dir_or_file}${imageSuffix}
        sudo convert -density 300 -quality 100 detectron-vehicle/"$dir_or_file" detectron-vehicle-image/"$dir_or_file".jpg
        #echo $imageFullfile
    fi
done