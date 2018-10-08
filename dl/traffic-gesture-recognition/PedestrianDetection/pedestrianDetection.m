load('PedNet.mat');
disp(PedNet.Layers);

type('pedDetect_predict.m')

% Load an input image.
im = imread('test.jpg');
im = imresize(im,[480,640]);

selectedBbox = pedDetect_predict(im);

%% 插入预测的 bounding box
outputImage = insertShape(im,'Rectangle',selectedBbox,'LineWidth',3);
imshow(outputImage);


%% 在录制视频上的测试
v = VideoReader('video\outside_yangxuefeng_turn_right_park_right_VID_20180725_102108.mp4');
fps = 0;
while hasFrame(v)
    % Read frames from video
    im = readFrame(v);
    im = imresize(im,[480,640]);
    % Call MEX function for pednet prediction
    tic;
    ped_bboxes = pedDetect_predict(im);
    newt = toc;
    % fps
    fps = .9*fps + .9*(1/newt);
    % display
    outputImage = insertShape(im,'Rectangle',ped_bboxes,'LineWidth',3);
    imshow(outputImage)
%     pause(0.01)
end


%% 预测示例视频
% v = VideoReader('video\LiveData.avi');
% fps = 0;
% while hasFrame(v)
%     % Read frames from video
%     im = readFrame(v);
%     im = imresize(im,[480,640]);
%     % Call MEX function for pednet prediction
%     tic;
%     ped_bboxes = pedDetect_predict(im);
%     newt = toc;
%     % fps
%     fps = .9*fps + .1*(1/newt);
%     % display
%     outputImage = insertShape(im,'Rectangle',ped_bboxes,'LineWidth',3);
%     imshow(outputImage)
%     pause(0.2)
% end


