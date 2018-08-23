
clear;
clc;

featureFiles = dir('D:\tmp\feature_label');
fileNum = length(featureFiles)-2;  % 除去当前文件和上一文件夹
trainData = zeros(fileNum, 1024);

fileCnt = 1;
for fileIndex = 1 : length(featureFiles)
    fileName = featureFiles(fileIndex).name;
    if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
        fileFullPath = fullfile(featureFiles(fileIndex).folder, fileName);
        featureData = importdata(fileFullPath);
        trainData(fileIndex, :) = featureData;
        fileNameSplits = split(fileName, '_');
        label{fileCnt}{1} = fileNameSplits{1};
        fileCnt = fileCnt+1;
    end
end

