%% ��ÿ���ļ���Ӧһ��������1024x1�����ļ����ڵ��ļ���ת��Ϊ
%   C���԰��SVM��ѵ�����������ݸ�ʽ��svmTrainData.txt
% ��[label]   [Index1]:[value1]  [index2]:[value2]  [index3]:[value3]��
%    1 1:0.280000 2:0.330000

featureFiles = dir('D:\tmp\feature_label');
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
trainDataFp = fopen('svmTrainData.txt', 'w');  % �½�������ļ�����
% for fileIndex = 1 : length(featureFiles)

labelMap = containers.Map({'black', 'green', 'red', 'yellow'}, {'1', '2', '3', '4'});

for fileIndex = 1 : dirCnt
    fileName = featureFiles(fileIndex).name;
    if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
        fileFullPath = fullfile(featureFiles(fileIndex).folder, fileName);
        featureData = importdata(fileFullPath);
        trainData(fileCnt, :) = featureData;
        fileNameSplits = split(fileName, '_');
        label{fileCnt} = char(fileNameSplits{1});
        
        fprintf(trainDataFp, '%c', labelMap(label{fileCnt}));
        for valueIndex = 1 : 1024
            fprintf(trainDataFp, ' %d:%6f', valueIndex, featureData(valueIndex));
        end
        fprintf(trainDataFp, '\n');
        
        fileCnt = fileCnt+1;
    end
    disp(fileIndex);
end
fclose(trainDataFp);

% label = label';  % ת�ó�������