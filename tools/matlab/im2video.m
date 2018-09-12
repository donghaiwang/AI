clc;
% clear all
close all;
% pic=dir('C:\Users\DELL\Downloads\detectron-vehicle-image');% 图像序列路径
sourceImgPath = 'C:\Users\DELL\Downloads\X-101-64x4d-FPN_red_only_vehicle';
pic=dir(sourceImgPath);% 图像序列路径
% WriterObj = VideoWriter('D:\tmp\vehicleDetectron.avi', 'Uncompressed AVI');% xxx.avi表示待合成的视频
WriterObj = VideoWriter('D:\workspace\VehicleDetection\avi\e2e_faster_rcnn_X-101-64x4d-FPN_1x_red_only_vehicle.avi');
WriterObj.FrameRate = 5;
% WriterObj.Quality = 100;  % 文件大小相比于没有设置大10倍左右

open(WriterObj);
for i=3:length(pic)             % 从3开始表示去除"."和".."目录
    imageFullfile = fullfile(sourceImgPath, pic(i).name);
    frame=imread(imageFullfile);    % 读取图像，放在变量frame中
    writeVideo(WriterObj,frame);  % 将frame放到变量WriterObj中
end
close(WriterObj);