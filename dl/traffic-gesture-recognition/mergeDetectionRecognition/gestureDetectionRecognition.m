%% ���峣��
roiWidth = 480;
roiHeight = 640;

peopleLabels = {'pedestrian ', 'policeman'};
actionLabels = {'go_straight', 'park_right', 'stop', 'turn_right'};


%% ����ģ��
load('PedNet.mat');  % ��������ʶ��ģ��

isPoliceModel = load('isPoliceman.mat');  % �������־�������˵�ģ��

load('gesture.mat');  % ���ؽ�ͨ���ƶ���ʶ��ģ��
inputSize = net.Layers(1).InputSize;

%% ��������ʶ��
im = imread('test.jpg');    % Load an input image.
im = imresize(im, [480,640]);

selectedBbox = pedDetect_predict(im);

outputImage = insertShape(im,'Rectangle',selectedBbox,'LineWidth',3);
imshow(outputImage);


%% ��¼����Ƶ�ϵĲ���
v = VideoReader('video\outside_yangxuefeng_turn_right_park_right_VID_20180725_102108.mp4');
fps = 0;
frameNum = 0;
while hasFrame(v)
    % Read frames from video
    im = readFrame(v);
    imwrite(im, 'test.jpg');
    frameNum = frameNum+1;
    im = imresize(im,[480, 640]);

    ped_bboxes = pedDetect_predict(im);  % ����ʶ��

    outputImage = insertShape(im,'Rectangle',ped_bboxes,'LineWidth',3);
    
    [roiNum, coordinateNum]  = size(ped_bboxes);
    for roiIndex=1:roiNum
        % Ԥ����������
        roiImg = imcrop(im, [ped_bboxes(roiIndex,1), ped_bboxes(roiIndex,2), ped_bboxes(roiIndex,3), ped_bboxes(roiIndex,4)]);  % �ü�����Ȥ�������ˣ�
        imwrite(roiImg, 'img\roiImg.jpg');
        ids = imageDatastore('img',  'IncludeSubfolders', true);
        augimdsValidation = augmentedImageDatastore(inputSize(1:2), ids);
        
        [isPoliceman, isPolicemanProbs] = classify(isPoliceModel.net, augimdsValidation);  % �����ǲ��Ǿ���
        peopleCategoryMap = containers.Map(peopleLabels, isPolicemanProbs);
        outputImage = insertText(outputImage, [ped_bboxes(roiIndex,1), ped_bboxes(roiIndex,2)], {strcat(char(isPoliceman), '::',  num2str(peopleCategoryMap(char(isPoliceman)))) } );
        
        [actionPredict, actionProbs] = classify(net,augimdsValidation);  % ���ƶ�������ʶ��
        actionCategoryMap = containers.Map(actionLabels, actionProbs);
        outputImage = insertText(outputImage, [ped_bboxes(roiIndex,1), ped_bboxes(roiIndex,2)+20],   {strcat(char(actionPredict), '::',  num2str(actionCategoryMap(char(actionPredict)))) });
    end
    
    imshow(outputImage);
end
disp(frameNum);


%% Ԥ��ʾ����Ƶ
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


