% imageLabeler
% 处理imageLabeler工具产生的标注数据
% 将图片按类别复制到相应的文件夹下（文件夹名即类别名）
% 直行  直行左转  直行右转  左转  右转  左右转  菱形 掉头

imageClasses = {'zx', 'zxzz', 'zzyz', 'zz', 'yz', 'zyz', 'lx', 'dt'};

labelResultPath = 'result';  % 标注结果的存放路径

labelRawPath = 'lane';
% labelImages = dir(labelRawPath);

if ~exist(labelResultPath, 'dir')
    mkdir(labelResultPath);
else  % 如果已经存在就清空目录
    rmdir(labelResultPath, 's');
    mkdir(labelResultPath);
end

% 新建类别文件夹
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







