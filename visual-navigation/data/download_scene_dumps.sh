#!/usr/bin/env bash

cd data
rm -f *.h5
wget http://vision.stanford.edu/yukezhu/thor_v1_scene_dumps.zip
unzip thor_v1_scene_dumps.zip
rm thor_v1_scene_dumps.zip
cd ..
