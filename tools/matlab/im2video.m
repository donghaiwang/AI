clc;
% clear all
close all;
% pic=dir('C:\Users\DELL\Downloads\detectron-vehicle-image');% ͼ������·��
sourceImgPath = 'C:\Users\DELL\Downloads\detectron-vehicle-image';
pic=dir(sourceImgPath);% ͼ������·��
% WriterObj = VideoWriter('D:\tmp\vehicleDetectron.avi', 'Uncompressed AVI');% xxx.avi��ʾ���ϳɵ���Ƶ
WriterObj = VideoWriter('D:\tmp\vehicleDetectron.avi');
WriterObj.FrameRate = 5;
% WriterObj.Quality = 100;

open(WriterObj);
for i=3:length(pic)             % ��3��ʼ��ʾȥ��"."��".."Ŀ¼
    imageFullfile = fullfile(sourceImgPath, pic(i).name);
    frame=imread(imageFullfile);    % ��ȡͼ�񣬷��ڱ���frame��
    writeVideo(WriterObj,frame);  % ��frame�ŵ�����WriterObj��
end
close(WriterObj);