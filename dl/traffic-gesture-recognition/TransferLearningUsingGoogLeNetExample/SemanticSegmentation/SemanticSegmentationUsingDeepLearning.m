%% Setup
% vgg16();

pretrainedURL = 'https://www.mathworks.com/supportfiles/vision/data/segnetVGG16CamVid.mat';
pretrainedFolder = fullfile('pretrainedSegNet');
pretrainedSegNet = fullfile(pretrainedFolder,'segnetVGG16CamVid.mat'); 
if ~exist(pretrainedFolder,'dir')
    mkdir(pretrainedFolder);
    disp('Downloading pretrained SegNet (107 MB)...');
    websave(pretrainedSegNet,pretrainedURL);
end

%% Download CamVid Dataset
imageURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/files/701_StillsRaw_full.zip';
labelURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/data/LabeledApproved_full.zip';

outputFolder = fullfile('CamVid');

if ~exist(outputFolder, 'dir')
   
    mkdir(outputFolder)
    labelsZip = fullfile(outputFolder,'labels.zip');
    imagesZip = fullfile(outputFolder,'images.zip');   
    
    disp('Downloading 16 MB CamVid dataset labels...'); 
    websave(labelsZip, labelURL);
    unzip(labelsZip, fullfile(outputFolder,'labels'));
    
    disp('Downloading 557 MB CamVid dataset images...');  
    websave(imagesZip, imageURL);       
    unzip(imagesZip, fullfile(outputFolder,'images'));    
end
% unzip(labelsZip, fullfile(outputFolder,'labels'));
% unzip(imagesZip, fullfile(outputFolder,'images'));  


%% Load CamVid Images
imgDir = fullfile(outputFolder,'images','701_StillsRaw_full');
imds = imageDatastore(imgDir);
I = readimage(imds,1);
I = histeq(I);
% imshow(I)


%% Load CamVid Pixel-Labeled Images
% Use |pixelLabelDatastore| to load CamVid pixel label image data. A
% |pixelLabelDatastore| encapsulates the pixel label data and the label ID
% to a class name mapping.
%
% Following the procedure used in original SegNet paper [1], group the 32
% original classes in CamVid to 11 classes. Specify these classes.
%%
classes = [
    "Sky"
    "Building"
    "Pole"
    "Road"
    "Pavement"
    "Tree"
    "SignSymbol"
    "Fence"
    "Car"
    "Pedestrian"
    "Bicyclist"
    ];
%% 
% To reduce 32 classes into 11, multiple classes from the orignal dataset
% are grouped together. For example, "Car" is a combination of "Car",
% "SUVPickupTruck", "Truck_Bus", "Train", and "OtherMoving". Return the
% grouped label IDs by using the supporting function |camvidPixelLabelIDs|,
% which is listed at the end of this example.

labelIDs = camvidPixelLabelIDs();
%% 
% Use the classes and label IDs to create the |pixelLabelDatastore|:

labelDir = fullfile(outputFolder,'labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
%% 
% Read and display one of the pixel-labeled images by overlaying it on top 
% of an image.

C = readimage(pxds, 1);

cmap = camvidColorMap;
B = labeloverlay(I,C,'ColorMap',cmap);

figure
imshow(B)
pixelLabelColorbar(cmap,classes);
%% 
% Areas with no color overlay do not have pixel labels and are not used 
% during training.

%% Analyze Dataset Statistics
% To see the distribution of class labels in the CamVid dataset, use |countEachLabel|. 
% This function counts the number of pixels by class label.
%%
tbl = countEachLabel(pxds)
%% 
% Visualize the pixel counts by class.

frequency = tbl.PixelCount/sum(tbl.PixelCount);

figure
bar(1:numel(classes),frequency)
xticks(1:numel(classes)) 
xticklabels(tbl.Name)
xtickangle(45)
ylabel('Frequency')
%% 
% Ideally, all classes would have an equal number of observations. However,
% the classes in CamVid are imbalanced, which is a common issue in
% automotive datasets of street scenes. Such scenes have more sky,
% building, and road pixels than pedestrian and bicyclist pixels because
% sky, buildings and roads cover more area in the image. If not handled
% correctly, this imbalance can be detrimental to the learning process
% because the learning is biased in favor of the dominant classes. Later on
% in this example, you will use class weighting to handle this issue.

%% Resize CamVid Data
% The images in the CamVid data set are 720 by 960. To reduce training time
% and memory usage, resize the images and pixel label images to 360 by 480.
% |resizeCamVidImages| and |resizeCamVidPixelLabels| are supporting
% functions listed at the end of this example.
%%
imageFolder = fullfile(outputFolder,'imagesReszed',filesep);
imds = resizeCamVidImages(imds,imageFolder);

labelFolder = fullfile(outputFolder,'labelsResized',filesep);
pxds = resizeCamVidPixelLabels(pxds,labelFolder);

%% Prepare Training and Test Sets 
% SegNet is trained using 60% of the images from the dataset. The rest of the 
% images are used for testing. The following code randomly splits the image and 
% pixel label data into a training and test set.
%%
[imdsTrain, imdsTest, pxdsTrain, pxdsTest] = partitionCamVidData(imds,pxds);
%% 
% The 60/40 split results in the following number of training and test 
% images:

numTrainingImages = numel(imdsTrain.Files)
numTestingImages = numel(imdsTest.Files)

%% Create the Network
% Use |segnetLayers| to create a SegNet network initialized using VGG-16 weights. 
% |segnetLayers| automatically performs the network surgery needed to transfer 
% the weights from VGG-16 and adds the additional layers required for semantic 
% segmentation.

imageSize = [360 480 3];
numClasses = numel(classes);
lgraph = segnetLayers(imageSize,numClasses,'vgg16');

%% 
% The image size is selected based on the size of the images in the
% dataset. The number of classes is selected based on the classes in
% CamVid.

%% Balance Classes Using Class Weighting
% As shown earlier, the classes in CamVid are not balanced. To improve
% training, you can use class weighting to balance the classes. Use the
% pixel label counts computed earlier with |countEachLabel| and calculate
% the median frequency class weights [1].

imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq
%% 
% Specify the class weights using a |pixelClassificationLayer|.

pxLayer = pixelClassificationLayer('Name','labels','ClassNames', tbl.Name, 'ClassWeights', classWeights)

%% 
% Update the SegNet network with the new |pixelClassificationLayer| by
% removing the current |pixelClassificationLayer| and adding the new layer.
% The current |pixelClassificationLayer| is named 'pixelLabels'. Remove it 
% using |removeLayers|, add the new one using|addLayers|, and connect the 
% new layer to the rest of the network using |connectLayers|.

lgraph = removeLayers(lgraph, 'pixelLabels');
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph, 'softmax' ,'labels');

%% Select Training Options
% The optimization algorithm used for training is stochastic gradient
% decent with momentum (SGDM). Use |trainingOptions| to specify the
% hyperparameters used for SGDM.

options = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 1e-3, ...
    'L2Regularization', 0.0005, ...
    'MaxEpochs', 100, ...  
    'MiniBatchSize', 4, ...
    'Shuffle', 'every-epoch', ...
    'VerboseFrequency', 2);
%% 
% A mini-batch size of 4 is used to reduce memory usage while training. You
% can increase or decrease this value based on the amount of GPU memory you
% have on your system.

%% Data Augmentation
% Data augmentation is used during training to provide more examples to the
% network because it helps improve the accuracy of the network. Here,
% random left/right reflection and random X/Y translation of +/- 10 pixels
% is used for data augmentation. Use the |imageDataAugmenter| to specify
% these data augmentation parameters.

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation', [-10 10], 'RandYTranslation',[-10 10]);
%% 
% |imageDataAugmenter| supports several other types of data augmentation.
% Choosing among them requires empirical analysis and is another level of
% hyperparameter tuning.

%% Start Training
% Combine the training data and data augmentation selections using |pixelLabelImageSource|. 
% The |pixelLabelImageSource| reads batches of training data, applies data 
% augmentation, and sends the augmented data to the training algorithm.

datasource = pixelLabelImageSource(imdsTrain,pxdsTrain,...
    'DataAugmentation',augmenter);
%% 
% Startl training using |trainNetwork| if the |doTraining| flag is true. Otherwise, 
% load a pretrained network. Note: Training takes about 5 hours on an NVIDIA(TM) 
% Titan X and can take even longer depending on your GPU hardware.

doTraining = false;
if doTraining    
    [net, info] = trainNetwork(datasource,lgraph,options);
else
    data = load(pretrainedSegNet);
    net = data.net;
end
%% Test Network on One Image
% As a quick sanity check, run the trained network on one test image. 
%%
I = read(imdsTest);
C = semanticseg(I, net);
%% 
% Display the results.

B = labeloverlay(I, C, 'Colormap', cmap, 'Transparency',0.4);
figure
imshow(B)
pixelLabelColorbar(cmap, classes);
%% 
% Compare the results in |C| with the expected ground truth stored in |pxdsTest|. 
% The green and magenta regions highlight areas where the segmentation results 
% differ from the expected ground truth.

expectedResult = read(pxdsTest);
actual = uint8(C);
expected = uint8(expectedResult);
imshowpair(actual, expected)

%% 
% Visually, the semantic segmentation results overlap well for classes such 
% as road, sky, and building. However, smaller objects like pedestrians and cars 
% are not as accurate. The amount of overlap per class can be measured using the 
% intersection-over-union (IoU) metric, also known as the Jaccard index. Use the 
% |jaccard| function to measure IoU.

iou = jaccard(C, expectedResult);
table(classes,iou)
%% 
% The IoU metric confirms the visual results. Road, sky, and building classes 
% have high IoU scores, while classes such as pedestrian and car have low scores. 
% Other common segmentation metrics include the <matlab:doc('dice') Dice index> 
% and the <matlab:doc('bfscore') Boundary-F1> contour matching score.
%% Evaluate Trained Network 
% To measure accuracy for multiple test images, run |semanticseg| on the entire 
% test set. 
%%
pxdsResults = semanticseg(imdsTest,net,'WriteLocation',tempdir,'Verbose',false);
%% 
% |semanticseg| returns the results for the test set as a |pixelLabelDatastore| 
% object. The actual pixel label data for each test image in |imdsTest| is written 
% to disk in the location specified by the |'WriteLocation'| parameter. Use |evaluateSemanticSegmentation| 
% to measure semantic segmentation metrics on the test set results. 

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);

%% 
% |evaluateSemanticSegmentation| returns various metrics for the entire 
% dataset, for individual classes, and for each test image. To see the dataset 
% level metrics, inspect |metrics.DataSetMetrics| .

metrics.DataSetMetrics
%% 
% The dataset metrics provide a high-level overview of the network performance. 
% To see the impact each class has on the overall performance, inspect the per-class 
% metrics using |metrics.ClassMetrics|.

metrics.ClassMetrics
%% 
% Although the overall dataset performance is quite high, the class metrics 
% show that underrepresented classes such as |Pedestrian|, |Bicyclist|, and |Car|
% are not segmented as well as classes such as |Road|, |Sky|, and |Building| . 
% Additional data that includes more samples of the underrepresented classes might 
% help improve the results.
%% References
% [1] Badrinarayanan, Vijay, Alex Kendall, and Roberto Cipolla. "SegNet: 
% A Deep Convolutional Encoder-Decoder Architecture for Image Segmentation." _arXiv 
% preprint arXiv:1511.00561_, 2015.
%
% [2] Brostow, Gabriel J., Julien Fauqueur, and Roberto Cipolla. "Semantic object 
% classes in video: A high-definition ground truth database." _Pattern Recognition 
% Letters_ Vol 30, Issue 2, 2009, pp 88-97.
% 
%% Supporting Functions
%%
function labelIDs = camvidPixelLabelIDs()
% Return the label IDs corresponding to each class.
%
% The CamVid dataset has 32 classes. Group them into 11 classes following
% the original SegNet training methodology [1].
%
% The 11 classes are:
%   "Sky" "Building", "Pole", "Road", "Pavement", "Tree", "SignSymbol",
%   "Fence", "Car", "Pedestrian",  and "Bicyclist".
%
% CamVid pixel label IDs are provided as RGB color values. Group them into
% 11 classes and return them as a cell array of M-by-3 matrices. The
% original CamVid class names are listed alongside each RGB value. Note
% that the Other/Void class are excluded below.
labelIDs = { ...
    
    % "Sky"
    [
    128 128 128; ... % "Sky"
    ]
    
    % "Building" 
    [
    000 128 064; ... % "Bridge"
    128 000 000; ... % "Building"
    064 192 000; ... % "Wall"
    064 000 064; ... % "Tunnel"
    192 000 128; ... % "Archway"
    ]
    
    % "Pole"
    [
    192 192 128; ... % "Column_Pole"
    000 000 064; ... % "TrafficCone"
    ]
    
    % Road
    [
    128 064 128; ... % "Road"
    128 000 192; ... % "LaneMkgsDriv"
    192 000 064; ... % "LaneMkgsNonDriv"
    ]
    
    % "Pavement"
    [
    000 000 192; ... % "Sidewalk" 
    064 192 128; ... % "ParkingBlock"
    128 128 192; ... % "RoadShoulder"
    ]
        
    % "Tree"
    [
    128 128 000; ... % "Tree"
    192 192 000; ... % "VegetationMisc"
    ]
    
    % "SignSymbol"
    [
    192 128 128; ... % "SignSymbol"
    128 128 064; ... % "Misc_Text"
    000 064 064; ... % "TrafficLight"
    ]
    
    % "Fence"
    [
    064 064 128; ... % "Fence"
    ]
    
    % "Car"
    [
    064 000 128; ... % "Car"
    064 128 192; ... % "SUVPickupTruck"
    192 128 192; ... % "Truck_Bus"
    192 064 128; ... % "Train"
    128 064 064; ... % "OtherMoving"
    ]
    
    % "Pedestrian"
    [
    064 064 000; ... % "Pedestrian"
    192 128 064; ... % "Child"
    064 000 192; ... % "CartLuggagePram"
    064 128 064; ... % "Animal"
    ]
    
    % "Bicyclist"
    [
    000 128 192; ... % "Bicyclist"
    192 000 192; ... % "MotorcycleScooter"
    ]
    
    };
end
%% 
% 

function pixelLabelColorbar(cmap, classNames)
% Add a colorbar to the current axis. The colorbar is formatted
% to display the class names with the color.

colormap(gca,cmap)

% Add colorbar to current figure.
c = colorbar('peer', gca);

% Use class names for tick marks.
c.TickLabels = classNames;
numClasses = size(cmap,1);

% Center tick labels.
c.Ticks = 1/(numClasses*2):1/numClasses:1;

% Remove tick mark.
c.TickLength = 0;
end
%% 
% 

function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    128 128 128   % Sky
    128 0 0       % Building
    192 192 192   % Pole
    128 64 128    % Road
    60 40 222     % Pavement
    128 128 0     % Tree
    192 128 128   % SignSymbol
    64 64 128     % Fence
    64 0 128      % Car
    64 64 0       % Pedestrian
    0 128 192     % Bicyclist
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end
%% 
% 

function imds = resizeCamVidImages(imds, imageFolder)
% Resize images to [360 480].

if ~exist(imageFolder,'dir') 
    mkdir(imageFolder)
else
    imds = imageDatastore(imageFolder);
    return; % Skip if images already resized
end

reset(imds)
while hasdata(imds)
    % Read an image.
    [I,info] = read(imds);     
    
    % Resize image.
    I = imresize(I,[360 480]);    
    
    % Write to disk.
    [~, filename, ext] = fileparts(info.Filename);
    imwrite(I,[imageFolder filename ext])
end

imds = imageDatastore(imageFolder);
end
%% 
% 

function pxds = resizeCamVidPixelLabels(pxds, labelFolder)
% Resize pixel label data to [360 480].

classes = pxds.ClassNames;
labelIDs = 1:numel(classes);
if ~exist(labelFolder,'dir')
    mkdir(labelFolder)
else
    pxds = pixelLabelDatastore(labelFolder,classes,labelIDs);
    return; % Skip if images already resized
end

reset(pxds)
while hasdata(pxds)
    % Read the pixel data.
    [C,info] = read(pxds);
    
    % Convert from categorical to uint8.
    L = uint8(C);
    
    % Resize the data. Use 'nearest' interpolation to
    % preserve label IDs.
    L = imresize(L,[360 480],'nearest');
    
    % Write the data to disk.
    [~, filename, ext] = fileparts(info.Filename);
    imwrite(L,[labelFolder filename ext])
end

labelIDs = 1:numel(classes);
pxds = pixelLabelDatastore(labelFolder,classes,labelIDs);
end
%% 
% 

function [imdsTrain, imdsTest, pxdsTrain, pxdsTest] = partitionCamVidData(imds,pxds)
% Partition CamVid data by randomly selecting 60% of the data for training. The
% rest is used for testing.
    
% Set initial random state for example reproducibility.
rng(0); 
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% Use 60% of the images for training.
N = round(0.60 * numFiles);
trainingIdx = shuffledIndices(1:N);

% Use the rest for testing.
testIdx = shuffledIndices(N+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
testImages = imds.Files(testIdx);
imdsTrain = imageDatastore(trainingImages);
imdsTest = imageDatastore(testImages);

% Extract class and label IDs info.
classes = pxds.ClassNames;
labelIDs = 1:numel(pxds.ClassNames);

% Create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
testLabels = pxds.Files(testIdx);
pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);
end

