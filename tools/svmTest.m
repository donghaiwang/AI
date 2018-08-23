clear;
clc;

featureFiles = dir('D:\tmp\feature\feature_label_2');
DEBUG = false;

%%
if DEBUG
    dirCnt = 10;
    fileNum = dirCnt - 2;
else
    dirCnt = length(featureFiles);
    fileNum = length(featureFiles)-2;  % 除去当前文件和上一文件夹
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

label = label';  % 转置成列向量

SVMModel = fitcecoc(trainData,label);

CodingMat = SVMModel.CodingMatrix;

isLoss = resubLoss(SVMModel);   % 准确率 0.0474
% 0.7450
% 

%% 交叉验证
% t = templateSVM('Standardize',1)
% 
% Mdl = fitcecoc(trainData, label, 'Learners',t,...
%     'ClassNames',{'setosa','versicolor','virginica'});
% 
% CVMdl = crossval(Mdl);
% 
% oosLoss = kfoldLoss(CVMdl)

