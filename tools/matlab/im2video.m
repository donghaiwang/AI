clc;
% clear all
close all;
% pic=dir('C:\Users\DELL\Downloads\detectron-vehicle-image');% ͼ������·��
sourceImgPath = 'C:\Users\DELL\Downloads\X-101-64x4d-FPN_red_only_vehicle';
pic=dir(sourceImgPath);% ͼ������·��
% WriterObj = VideoWriter('D:\tmp\vehicleDetectron.avi', 'Uncompressed AVI');% xxx.avi��ʾ���ϳɵ���Ƶ
WriterObj = VideoWriter('D:\workspace\VehicleDetection\avi\e2e_faster_rcnn_X-101-64x4d-FPN_1x_red_only_vehicle.avi');
WriterObj.FrameRate = 5;
% WriterObj.Quality = 100;  % �ļ���С�����û�����ô�10������

open(WriterObj);
for i=3:length(pic)             % ��3��ʼ��ʾȥ��"."��".."Ŀ¼
    imageFullfile = fullfile(sourceImgPath, pic(i).name);
    frame=imread(imageFullfile);    % ��ȡͼ�񣬷��ڱ���frame��
    writeVideo(WriterObj,frame);  % ��frame�ŵ�����WriterObj��
end
close(WriterObj);