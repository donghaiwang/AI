clc;
% clear all
close all;
pic=dir('C:\Users\DELL\Downloads\detectron-vehicle-image');% 图像序列路径
WriterObj=VideoWriter('D:\tmp\vehicleDetectron.avi', 'Uncompressed AVI');% xxx.avi表示待合成的视频
% WriterObj.FrameRate = 25;
% WriterObj.Quality = 100;
 
open(WriterObj);
for i=3:length(pic)             % 从3开始表示去除"."和".."目录
  frame=imread(pic(i).name);    % 读取图像，放在变量frame中
  writeVideo(WriterObj,frame);  % 将frame放到变量WriterObj中
end
close(WriterObj);