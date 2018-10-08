
%% 
isResize = true;  % ��������������1.��ͼƬ��ѹ����2.���������������
resizeScale = 1 / 6.0;  % ͼƬ�����ű���(��С6������Ȼ��Ҫ�ڴ�17G��
% WIDTH = 540;
% HEIGHT = 452;

%% ϵͳ�������� 
% �ж��Ƿ�֧��GPU
gpuNum = gpuDeviceCount;
disp([num2str(gpuNum) ' GPUs found']);
if gpuNum > 0
    disp('Use GPU');
    useGPU = true;
else
    disp('Use CPU');
    useGPU = 'no';
end

% ���Һ�����
coresNum = feature('numCores');
disp([num2str(coresNum) ' cores found']);

% ����CPU����Ŀ
import java.lang.*;
runtime = Runtime.getRuntime;
cpusNum = runtime.availableProcessors;
disp([num2str(cpusNum) ' cpus found']);

% �������Ϣ
[archstr,maxsize,endian]=computer;
disp([...
    'This is a ' archstr ...
    ' computer that can have up to ' num2str(maxsize) ...
    ' elements in a matlab array and uses ' endian ...
    ' byte ordering.'...
    ]);

% ����б�Ҫ�������г�
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local');
else
    poolSize = poolobj.NumWorkers;
    poolInfo = sprintf('matlab pool already started, pool size is: %d', poolSize);
    disp(poolInfo);
end

%%
addpath(fullfile('tools'));  % ��������·��

%% ��ȡxml�ļ������˺�����ݣ�����ʶ��ͷ���
dataDir = fullfile('data', 'fasterRCNN');  % ͼƬ����Ӧ�ı�ע�ļ�(.xml)���ڵ�·��
dirFiles = dir([dataDir '\*.xml']);  % ��ȡĿ¼�µ������ļ�

%% ѵ������Ԥ�����ڴ�
detectCategoryNames = {'imageFilename', 'light','sign','lane'};
sz = [length(dirFiles), 4];  % ÿ��xml����Ӧһ��ͼƬ��һ�У���һ��ΪͼƬ����·������2-4�зֱ�Ϊ��ͨ�ơ���ͨ��־�������߼�ͷ�ĺ�ѡ�������
varTypes = {'cell','cell','cell', 'cell'};

rowIndex = cell(length(dirFiles), 1);  % �����������1-n��ʾ
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
        if isResize  % ��ͼƬ��ѹ��
            rawImage = imread(imageFilenameCell{1});
            resizedImage = imresize(rawImage, resizeScale);
            resizedImageName = [fullfile(labelFilePath, labelFileName) '_resized.jpg'];
            imwrite(resizedImage, resizedImageName);
            imageFilenameCell{1} = resizedImageName;
        end
        trafficDataSet(num2str(fileIndex), :).imageFilename = imageFilenameCell;  % ͼƬ��·���������Ӧ��ע�ļ���ͬһĿ¼������׺����Ϊ.jpg
        
        labelContents = xml2struct(labelFullPath);  % ��xml�ļ�ת��Ϊstruct�����õ������⣩
        
        allObjects = labelContents.annotation.object;
        lightBoxs = [];  % һ��ͼƬ�н�ͨ�ƺ�ѡ�����������(N x 4)
        signBoxs = [];
        laneBoxs = [];
        for objectIndex = 1 : length(allObjects)
            objectItem = allObjects(objectIndex);
            objName = objectItem{1}.name.Text;  % ��ѡ������ͣ�light��sign��lane
            bndbox = objectItem{1}.bndbox;
            xmin = str2double(bndbox.xmin.Text);  ymin = str2double(bndbox.ymin.Text);  % ��ѡ�����Ͻ���������(xmin, ymin)
            xmax = str2double(bndbox.xmax.Text);  ymax = str2double(bndbox.ymax.Text);  % ��ѡ�����½���������(xmax, ymax)
            objWidth = xmax - xmin;
            objHeight = ymax - ymin;
            
            if isResize  % �Կ�������������
                xmin = uint32(xmin * resizeScale);  ymin = uint32(ymin * resizeScale);
                objWidth = uint32(objWidth * resizeScale);  objHeight = uint32(objHeight * resizeScale);
            end
            
            if strcmp(objName, 'light')  % �ռ���ͨ�����ĺ�ѡ��
                lightBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            elseif strcmp(objName, 'sign')
                signBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            elseif strcmp(objName, 'lane')
                laneBoxs(end+1, :) = [xmin, ymin, objWidth, objHeight];
            end
        end
        
        % ���Ϊtable�е�һ��Ԫ�أ��ұ�ΪNx4��double����
        lightBoxsCell{1} = lightBoxs; % ��double�������Cell��
        trafficDataSet{num2str(fileIndex), 'light'} = lightBoxsCell;
        signBoxsCell{1} = signBoxs;
        trafficDataSet(num2str(fileIndex), 'sign') = signBoxsCell;
        laneBoxsCell{1} = laneBoxs;
        trafficDataSet(num2str(fileIndex), 'lane') = laneBoxsCell;
    end
end


%% չʾʾ��һ��
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