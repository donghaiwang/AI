%% 
clc;
clear;
isTestMyData = false;
%% ��¼��Ƶ��Ϣ
videoName = 'video/gesture.avi';
fps = 25;  % ֡��
HEIGHT = 1600;
WIDTH = 1080;
aviobj=VideoWriter(videoName);  %����һ��avi��Ƶ�ļ����󣬿�ʼʱ��Ϊ��
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
% ����ͼƬ��������Ϣ
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
        
        for height=1: HEIGHT  % ��ʼ����ɫ����ͼƬ
            for width = 1 : WIDTH
                background(height, width, 1) = uint8(0);
                background(height, width, 2) = uint8(0);
                background(height, width, 3) = uint8(0);
            end
        end
        currentFrame = imread(files{j});
        currentFrameSize = size(currentFrame);
        % ��ͼƬ�ӵ���ɫ����ͼƬ�ϲ�д����Ƶ
        for height = 1 : currentFrameSize(1)
            for width = 1 : currentFrameSize(2)
                background(height, width, 1) = currentFrame(height, width, 1);
                background(height, width, 2) = currentFrame(height, width, 2);
                background(height, width, 3) = currentFrame(height, width, 3);
            end
        end
        % ��������
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
close(aviobj);% �رմ�����Ƶ



% [YPred,probs] = classify(net,augimdsValidation);



% accuracy = mean(YPred == imdsValidation.Labels)
% [YPred,probs] = classify(net,augimdsValidation);
% accuracy = mean(YPred == imdsValidation.Labels)
% `