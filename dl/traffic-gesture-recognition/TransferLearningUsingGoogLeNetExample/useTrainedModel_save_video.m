%% 
clc;
clear;
isTestMyData = false;
%% 记录视频信息
videoName = 'video/gesture.avi';
fps = 25;  % 帧率
HEIGHT = 1600;
WIDTH = 1080;
aviobj=VideoWriter(videoName);  %创建一个avi视频文件对象，开始时其为空
aviobj.FrameRate=fps;
open(aviobj);

for height=1: HEIGHT
    for width = 1 : WIDTH
        background(height, width, 1) = uint8(0);
        background(height, width, 2) = uint8(0);
        background(height, width, 3) = uint8(0);
    end
end


%%
load('My_net_add_My_1.mat', 'net');
% img = imread('test_data/go_straight/1_3_1_0.png');

inputSize = net.Layers(1).InputSize;

% labels = ['go_straight', 'stop'];
if isTestMyData == true
    labels = {'stop'};
%     labels = {'go_straight', 'stop'};
else
%     labels = {'go_straight', 'park_right', 'turn_right'};
    labels = {'go_straight', 'park_right', 'stop', 'turn_right'};
end
% 插入图片的文字信息
insertPosition = [0 0];
% text_str = cell(4,1);
% conf_val = [85.212 98.76 78.342]; 
% for ii=1:4
%    text_str{ii} = ['Action: ' labels{i}];
% end

labels_dims = size(labels);
sum = 0; correctPredicted = 0;
for i=1:labels_dims(2)
    disp(labels{i});
    class_correct_predicted = 0;
    class_sum = 0;
    if isTestMyData == true
%         testDataPath = 'SemanticSegmentation/label/processed_result/';
        testDataPath = 'test_data/';
    else
        testDataPath = 'test_data/my/';
    end
    imdsValidation = imageDatastore(strcat(testDataPath, labels{i}), 'IncludeSubfolders', true);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2), imdsValidation);
    files = imdsValidation.Files;
%     imshow(files{1});stop
    [YPred,probs] = classify(net,augimdsValidation);
    for j = 1 : size(YPred)
        class_sum = class_sum + 1;
        sum = sum + 1;
        if YPred(j) == labels{i}
            class_correct_predicted = class_correct_predicted + 1;
            correctPredicted = correctPredicted + 1;
        end
        
        for height=1: HEIGHT  % 初始化黑色背景图片
            for width = 1 : WIDTH
                background(height, width, 1) = uint8(0);
                background(height, width, 2) = uint8(0);
                background(height, width, 3) = uint8(0);
            end
        end
        currentFrame = imread(files{j});
        currentFrameSize = size(currentFrame);
        % 将图片加到黑色背景图片上并写入视频
        for height = 1 : currentFrameSize(1)
            for width = 1 : currentFrameSize(2)
                background(height, width, 1) = currentFrame(height, width, 1);
                background(height, width, 2) = currentFrame(height, width, 2);
                background(height, width, 3) = currentFrame(height, width, 3);
            end
        end
        % 加入文字
        insertedText = cell(1,1);
        insertedText{1} = ['Action: ' char(YPred(j))];   
        if YPred(j) == labels{i}
            RGB = insertText(background, insertPosition, insertedText, 'FontSize',50, 'TextColor','green');
        else
            RGB = insertText(background, insertPosition, insertedText, 'FontSize',50, 'TextColor','red');
        end
%         imshow(RGB);
        writeVideo(aviobj, RGB);
    end
    fprintf('class sum: %d, predicted corrected: %d, accuracy: %f\n', class_sum, class_correct_predicted, class_correct_predicted/class_sum);
end

fprintf('Sum: %d, predicted corrected: %d, accuracy: %f\n', sum, correctPredicted, correctPredicted/sum);
close(aviobj);% 关闭创建视频



% [YPred,probs] = classify(net,augimdsValidation);



% accuracy = mean(YPred == imdsValidation.Labels)
% [YPred,probs] = classify(net,augimdsValidation);
% accuracy = mean(YPred == imdsValidation.Labels)
% `