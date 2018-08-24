clear;
clc;

featureFiles = dir('D:\tmp\feature\feature_label_1');
% ��������ǩ
classNames = importdata('D:\tmp\feature\cla1_labels.list');
classNames = classNames';

DEBUG = false;

%%
if DEBUG
    dirCnt = 10;
    fileNum = dirCnt - 2;
else
    dirCnt = length(featureFiles);
    fileNum = length(featureFiles)-2;  % ��ȥ��ǰ�ļ�����һ�ļ���
end

%%
trainData = zeros(fileNum, 1024);

fileCnt = 1;
% for fileIndex = 1 : length(featureFiles)
for fileIndex = 1 : dirCnt
    fileName = featureFiles(fileIndex).name;
    if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
        fileFullPath = fullfile(featureFiles(fileIndex).folder, fileName);
        featureData = importdata(fileFullPath);
        trainData(fileCnt, :) = featureData;
        fileNameSplits = split(fileName, '_');
        label{fileCnt} = char(fileNameSplits{1});
        fileCnt = fileCnt+1;
    end
end

label = label';  % ת�ó�������

% SVMModel = fitcecoc(trainData,label);
% CodingMat = SVMModel.CodingMatrix;
% isLoss = resubLoss(SVMModel);   % ׼ȷ�� 0.0474
% 0.7450 (1)
% 0.9842 (2)


%% ������֤
t = templateSVM('Standardize',1);

Mdl = fitcecoc(trainData, label, 'Learners',t,...
    'ClassNames', classNames);

CVMdl = crossval(Mdl);

oosLoss = kfoldLoss(CVMdl);
% 0.1230 (1)
% 0.0603 (2)

