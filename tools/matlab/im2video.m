clc;
% clear all
close all;
pic=dir('C:\Users\DELL\Downloads\detectron-vehicle-image');% ͼ������·��
WriterObj=VideoWriter('D:\tmp\vehicleDetectron.avi', 'Uncompressed AVI');% xxx.avi��ʾ���ϳɵ���Ƶ
% WriterObj.FrameRate = 25;
% WriterObj.Quality = 100;
 
open(WriterObj);
for i=3:length(pic)             % ��3��ʼ��ʾȥ��"."��".."Ŀ¼
  frame=imread(pic(i).name);    % ��ȡͼ�񣬷��ڱ���frame��
  writeVideo(WriterObj,frame);  % ��frame�ŵ�����WriterObj��
end
close(WriterObj);