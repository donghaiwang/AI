#!/usr/bin/env bash

# ./data/download_scene_dumps.sh
# 下载场景文件: http://vision.stanford.edu/yukezhu/
cd data
rm -f *.h5
wget http://vision.stanford.edu/yukezhu/thor_v1_scene_dumps.zip
unzip thor_v1_scene_dumps.zip
rm thor_v1_scene_dumps.zip
cd ..
