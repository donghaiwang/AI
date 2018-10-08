% imageLabeler
% ����imageLabeler���߲����ı�ע����
% ��ͼƬ������Ƶ���Ӧ���ļ����£��ļ��������������
% ֱ��  ֱ����ת  ֱ����ת  ��ת  ��ת  ����ת  ���� ��ͷ

imageClasses = {'zx', 'zxzz', 'zzyz', 'zz', 'yz', 'zyz', 'lx', 'dt'};

labelResultPath = 'result';  % ��ע����Ĵ��·��

labelRawPath = 'lane';
% labelImages = dir(labelRawPath);

if ~exist(labelResultPath, 'dir')
    mkdir(labelResultPath);
else  % ����Ѿ����ھ����Ŀ¼
    rmdir(labelResultPath, 's');
    mkdir(labelResultPath);
end

% �½�����ļ���
for classIndex=1:length(imageClasses)
    mkdir(fullfile(labelResultPath, imageClasses{classIndex}));
end

labelData = gTruth.LabelData;
labelData = table2array(labelData);
dataSource = gTruth.DataSource;
[imgNum, classNum] = size(labelData);
for imgIndex=1:imgNum
    for classIndex=1:classNum
        if labelData(imgIndex, classIndex) == true
            copyfile(dataSource.Source{imgIndex}, ...
                fullfile(labelResultPath, imageClasses{classIndex}));
        end
    end
end







