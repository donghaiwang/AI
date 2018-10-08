
%% 
isResize = true;  % 包含两个操作：1.对图片做压缩；2.做框坐标进行缩放
resizeScale = 1 / 6.0;  % 图片的缩放比例(缩小6倍，不然需要内存17G）
% WIDTH = 540;
% HEIGHT = 452;

%% 系统环境测试 
% 判断是否支持GPU
gpuNum = gpuDeviceCount;
disp([num2str(gpuNum) ' GPUs found']);
if gpuNum > 0
    disp('Use GPU');
    useGPU = true;
else
    disp('Use CPU');
    useGPU = 'no';
end

% 查找核心数
coresNum = feature('numCores');
disp([num2str(coresNum) ' cores found']);

% 查找CPU的数目
import java.lang.*;
runtime = Runtime.getRuntime;
cpusNum = runtime.availableProcessors;
disp([num2str(cpusNum) ' cpus found']);

% 计算机信息
[archstr,maxsize,endian]=computer;
disp([...
    'This is a ' archstr ...
    ' computer that can have up to ' num2str(maxsize) ...
    ' elements in a matlab array and uses ' endian ...
    ' byte ordering.'...
    ]);

% 如果有必要开启并行池
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local');
else
    poolSize = poolobj.NumWorkers;
    poolInfo = sprintf('matlab pool already started, pool size is: %d', poolSize);
    disp(poolInfo);
end

%%
addpath(fullfile('tools'));  % 第三方库路径

%% 读取xml文件（过滤后的数据）进行识别和分类
dataDir = fullfile('data', 'fasterRCNN');  % 图片和相应的标注文件(.xml)所在的路径
dirFiles = dir([dataDir '\*.xml']);  % 获取目录下的所有文件

%% 训练数据预分配内存
detectCategoryNames = {'imageFilename', 'light','sign','lane'};
sz = [length(dirFiles), 4];  % 每个xml（对应一张图片）一行，第一列为图片所在路径，第2-4列分别为交通灯、交通标志、车道线箭头的候选框的坐标
varTypes = {'cell','cell','cell', 'cell'};

rowIndex = cell(length(dirFiles), 1);  % 表的行索引用1-n表示
for fileIndex = 1 : length(dirFiles)
    rowIndex{fileIndex} = num2str(fileIndex);
end

trafficDataSet = table('Size', sz, 'VariableTypes', varTypes,...
    'VariableNames', detectCategoryNames, 'RowNames', rowIndex);
for fileIndex = 1 : length(dirFiles)    
    fileItem = dirFiles(fileIndex);
    fileName = fileItem.name;
    if ~strcmp(fileName, '.') && ~strcmp(fileName, '..')
        labelFullPath = fullfile(dataDir, fileName);
        
        [labelFilePath, labelFileName, labelFileExt] = fileparts(labelFullPath);
        imageFilenameCell{1} = [fullfile(labelFilePath, labelFileName) '.jpg'];
        if isResize  % 对图片做压缩
            rawImage = imread(imageFilenameCell{1});
            resizedImage = imresize(rawImage, resizeScale);
            resizedImageName = [fullfile(labelFilePath, labelFileName) '_resized.jpg'];
            imwrite(resizedImage, resizedImageName);
            imageFilenameCell{1} = resizedImageName;
        end
        trafficDataSet(num2str(fileIndex), :).imageFilename = imageFilenameCell;  % 图片的路径（和其对应标注文件在同一目录，仅后缀名改为.jpg
        
        labelContents = xml2struct(labelFullPath);  % 将xml文件转化为struct（调用第三方库）
        
        allObjects = labelContents.annotation.object;
        lightBoxs = [];  % 一张图片中交通灯候选框的坐标数组(N x 4)
        signBoxs = [];
        laneBoxs = [];
        for objectIndex = 1 : length(allObjects)
            objectItem = allObjects(objectIndex);
            objName = objectItem{1}.name.Text;  % 候选框的类型：light、sign、lane
            bndbox = objectItem{1}.bndbox;
            xmin = str2double(bndbox.xmin.Text);  ymin = str2double(bndbox.ymin.Text);  % 候选框左上角像素坐标(xmin, ymin)
            xmax = str2double(bndbox.xmax.Text);  ymax = str2double(bndbox.ymax.Text);  % 候选框右下角像素坐标(xmax, ymax)
            objWidth = xmax - xmin;
            objHeight = ymax - ymin;
            
            if isResize  % 对框的坐标进行缩放
                xmin = uint32(xmin * resizeScale);  ymin = uint32(ymin * resizeScale);
                objWidth = uint32(objWidth * resizeScale);  objHeight = uint32(objHeight * resizeScale);
            end
            
            if strcmp(objName, 'light')  % 收集交通灯类别的候选框
                lightBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            elseif strcmp(objName, 'sign')
                signBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            elseif strcmp(objName, 'lane')
                laneBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            end
        end
        
        % 左边为table中的一个元素，右边为Nx4的double数组
        lightBoxsCell{1} = lightBoxs; % 将double数组放在Cell里
        trafficDataSet{num2str(fileIndex), 'light'} = lightBoxsCell;
        signBoxsCell{1} = signBoxs;
        trafficDataSet(num2str(fileIndex), 'sign') = signBoxsCell;
        laneBoxsCell{1} = laneBoxs;
        trafficDataSet(num2str(fileIndex), 'lane') = laneBoxsCell;
    end
end


%% 展示示例一张
% Read one of the images.
I = imread(trafficDataSet.imageFilename{3});

% Insert the ROI labels.
I = insertShape(I, 'Rectangle', trafficDataSet.lane{3}, 'Color', 'red', 'LineWidth', 5);

% Resize and display image.
I = imresize(I,3);
% figure
% imshow(I)


%% Split data into a training and test set.
idx = floor(0.7 * height(trafficDataSet));
trainingData = trafficDataSet(1:idx,:);
testData = trafficDataSet(idx+1:end,:);

%% Create a Convolutional Neural Network (CNN)
% Create image input layer.
inputLayer = imageInputLayer([32 32 3]);

% Define the convolutional layer parameters.
filterSize = [3 3];
numFilters = 32;

% Create the middle layers.
middleLayers = [
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)    
    ];

finalLayers = [
    
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)

    % Add a ReLU non-linearity.
    reluLayer()

    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or background. This measurement
    % is made using the subsequent loss layers.
    fullyConnectedLayer(width(trafficDataSet))

    % Add the softmax loss layer and classification layer. 
    softmaxLayer()
    classificationLayer()
];

layers = [
    inputLayer
    middleLayers
    finalLayers
    ]

tempdir = 'checkpoint\';
% Options for step 1.
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 256, ...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir);

% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 128, ...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 256, ...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir);

% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 128, ...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir);

options = [
    optionsStage1
    optionsStage2
    optionsStage3
    optionsStage4
    ];

%% Train Faster R-CNN
% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network. 
doTrainingAndEval = true;

if doTrainingAndEval
    % Set random seed to ensure example training reproducibility.
    rng(0);
    
    % Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
    % for finer resolution for multiscale object detection.
    detector = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
        'NegativeOverlapRange', [0 0.3], ...
        'PositiveOverlapRange', [0.6 1], ...
        'BoxPyramidScale', 1.2);
else
    % Load pretrained detector for the example.
    detector = data.detector;
end


% Read a test image.
I = imread(testData.imageFilename{1});

% Run the detector.
[bboxes,scores] = detect(detector,I);

% Annotate detections in the image.
I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)


%% Evaluate Detector Using Test Set
if doTrainingAndEval
    % Run detector on each image in the test set and collect results.
    resultsStruct = struct([]);
    for i = 1:height(testData)
        
        % Read the image.
        I = imread(testData.imageFilename{i});
        
        % Run the detector.
        [bboxes, scores, labels] = detect(detector, I);
        
        % Collect the results.
        resultsStruct(i).Boxes = bboxes;
        resultsStruct(i).Scores = scores;
        resultsStruct(i).Labels = labels;
    end
    
    % Convert the results into a table.
    results = struct2table(resultsStruct);
else
    % Load results from disk.
    results = data.results;
end

% Extract expected bounding box locations from test data.
expectedResults = testData(:, 2:end);

% Evaluate the object detector using Average Precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

% Plot precision/recall curve
figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f', ap))