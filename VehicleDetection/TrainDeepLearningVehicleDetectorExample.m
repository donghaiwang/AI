%% Train a Deep Learning Vehicle Detector
% This example shows how to train a vision-based vehicle detector using
% deep learning.
%
% Copyright 2016 The MathWorks, Inc.

%% Overview
% Vehicle detection using computer vision is an important component for
% tracking vehicles around the ego vehicle. The ability to detect and track
% vehicles is required for many autonomous driving applications, such as
% for forward collision warning, adaptive cruise control, and automated
% lane keeping. Automated Driving System Toolbox(TM) provides pretrained
% vehicle detectors (|vehicleDetectorFasterRCNN| and |vehicleDetectorACF|)
% to enable quick prototyping. However, the pretrained models might not
% suit every application, requiring you to train from scratch. This example
% shows how to train a vehicle detector from scratch using deep learning.
%
% Deep learning is a powerful machine learning technique that automatically
% learns image features required for detection tasks. There are several
% techniques for object detection using deep learning. This example uses a
% the Faster R-CNN [1] technique, which is implemented in the
% |trainFasterRCNNObjectDetector| function.
%
% The example has the following sections:
%
% * Load a vehicle data set.
% * Design the convolutional neural network (CNN).
% * Configure training options.
% * Train a Faster R-CNN object detector.
% * Evaluate the trained detector.
%
% Note: This example requires Computer Vision System Toolbox(TM), Image
% Processing Toolbox(TM), and Neural Network Toolbox(TM).
%
% Using a CUDA-capable NVIDIA(TM) GPU with compute capability 3.0 or higher
% is highly recommended for running this example. Use of a GPU requires
% Parallel Computing Toolbox(TM).

%% Load Data Set
% This example uses a small vehicle data set that contains 295 images. Each
% image contains 1 to 2 labeled instances of a vehicle. A small data set is
% useful for exploring the Faster R-CNN training procedure, but in
% practice, more labeled images are needed to train a robust detector. To
% label additional videos or images for training, you can use the
% |groundTruthLabeler| app.

% Load vehicle data set
data = load('fasterRCNNVehicleTrainingData.mat');
vehicleDataset = data.vehicleTrainingData;

%%
% The training data is stored in a table. The first column contains the
% path to the image files. The remaining columns contain the ROI labels for
% vehicles. 

% Display first few rows of the data set.
vehicleDataset(1:4,:)

%%
% Display one of the images from the data set to understand the type of
% images it contains.

% Add full path to the local vehicle data folder.
dataDir = fullfile(toolboxdir('vision'),'visiondata');
vehicleDataset.imageFilename = fullfile(dataDir, vehicleDataset.imageFilename);

% Read one of the images.
I = imread(vehicleDataset.imageFilename{10});

% Insert the ROI labels.
I = insertShape(I, 'Rectangle', vehicleDataset.vehicle{10});

% Resize and display image.
I = imresize(I, 3);
figure
imshow(I)

%%
% Split the data set into a training set for training the detector, and a
% test set for evaluating the detector. Select 60% of the data for
% training. Use the rest for evaluation.

% Split data into a training and test set.
idx = floor(0.6 * height(vehicleDataset));
trainingData = vehicleDataset(1:idx,:);
testData = vehicleDataset(idx:end,:);

%% Create a Convolutional Neural Network (CNN)
% A CNN is the basis of the Faster R-CNN object detector. Create the CNN
% layer by layer using Neural Network Toolbox(TM) functionality.
%
% Start with the |imageInputLayer| function, which defines the type and
% size of the input layer. For classification tasks, the input size is
% typically the size of the training images. For detection tasks, the CNN
% needs to analyze smaller sections of the image, so the input size must be
% similar in size to the smallest object in the data set. In this data set
% all the objects are larger than [16 16], so select an input size of [32
% 32]. This input size is a balance between processing time and the amount
% of spatial detail the CNN needs to resolve.

% Create image input layer.
inputLayer = imageInputLayer([32 32 3]);

%%
% Next, define the middle layers of the network. The middle layers are made
% up of repeated blocks of convolutional, ReLU (rectified linear units),
% and pooling layers. These layers form the core building blocks of
% convolutional neural networks.

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

%%
% You can create a deeper network by repeating these basic layers. However,
% to avoid downsampling the data prematurely, keep the number of pooling
% layers low. Downsampling early in the network discards image information
% that is useful for learning.
% 
% The final layers of a CNN are typically composed of fully connected
% layers and a softmax loss layer. 

finalLayers = [

    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)

    % Add ReLU nonlinearity.
    reluLayer

    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or to the background. This
    % measurement is made using the subsequent loss layers.
    fullyConnectedLayer(width(vehicleDataset))

    % Add the softmax loss layer and classification layer.
    softmaxLayer
    classificationLayer
    
    ];

%%
% Combine the input, middle, and final layers.
layers = [
    inputLayer
    middleLayers
    finalLayers
    ]

%% Configure Training Options
% |trainFasterRCNNObjectDetector| trains the detector in four steps. The first
% two steps train the region proposal and detection networks used in Faster
% R-CNN. The final two steps combine the networks from the first two steps
% such that a single network is created for detection [1]. Each training
% step can have different convergence rates, so it is beneficial to specify
% independent training options for each step. To specify the network
% training options use |trainingOptions| from Neural Network Toolbox(TM).

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

%%
% Here, the learning rate for the first two steps is set higher than the
% last two steps. Because the last two steps are fine-tuning steps, the
% network weights can be modified more slowly than in the first two steps.
%
% In addition, |'CheckpointPath'| is set to a temporary location for all
% the training options. This name-value pair enables the saving of
% partially trained detectors during the training process. If training is
% interrupted, such as from a power outage or system failure, you can
% resume training from the saved checkpoint.

%% Train Faster R-CNN
% Now that the CNN and training options are defined, you can train the
% detector using |trainFasterRCNNObjectDetector|.
%
% During training, image patches are extracted from the training data. The
% |'PositiveOverlapRange'| and |'NegativeOverlapRange'| name-value pairs
% control which image patches are used for training. Positive training
% samples are those that overlap with the ground truth boxes by 0.6 to 1.0,
% as measured by the bounding box intersection over union metric. Negative
% training samples are those that overlap by 0 to 0.3. The best values for
% these parameters should be chosen by testing the trained detector on a
% validation set. To choose the best values for these name-value pairs,
% test the trained detector on a validation set.
%
% For Faster R-CNN training, *the use of a parallel pool of MATLAB workers is
% highly recommended to reduce training time*. |trainFasterRCNNObjectDetector|
% automatically creates and uses a parallel pool based on your <http://www.mathworks.com/help/vision/gs/computer-vision-system-toolbox-preferences.html parallel preference settings>. Ensure that the use of
% the parallel pool is enabled prior to training.
%
% A CUDA-capable NVIDIA(TM) GPU with compute capability 3.0 or higher is
% highly recommended for training.
%
% To save time while running this example, a pretrained network is loaded
% from disk. To train the network yourself, set the |doTrainingAndEval|
% variable shown here to true.

% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network. 
doTrainingAndEval = false;

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

%%
% To quickly verify the training, run the detector on a test image.

% Read a test image.
I = imread(testData.imageFilename{1});

% Run the detector.
[bboxes, scores] = detect(detector, I);

% Annotate detections in the image.
I = insertObjectAnnotation(I, 'rectangle', bboxes, scores);
figure
imshow(I)

%% Evaluate Detector Using Test Set
% Testing a single image showed promising results. To fully evaluate the
% detector, testing it on a larger set of images is recommended. Computer
% Vision System Toolbox(TM) provides object detector evaluation functions
% to measure common metrics such as average precision
% (|evaluateDetectionPrecision|) and log-average miss rates
% (|evaluateDetectionMissRate|). Here, the average precision metric is
% used. The average precision provides a single number that incorporates
% the ability of the detector to make correct classifications (precision)
% and the ability of the detector to find all relevant objects (recall).
%
% The first step for detector evaluation is to collect the detection
% results by running the detector on the test set. To avoid long evaluation
% time, the results are loaded from disk. Set the |doTrainingAndEval| flag
% from the previous section to true to execute the evaluation locally.

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
    results = data.results;
end

% Extract expected bounding box locations from test data.
expectedResults = testData(:, 2:end);

% Evaluate the object detector using average precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

%%
% The precision/recall (PR) curve highlights how precise a detector is at
% varying levels of recall. Ideally, the precision would be 1 at all recall
% levels. In this example, the average precision is 0.6. The use of
% additional layers in the network can help improve the average precision,
% but might require additional training data and longer training time.

% Plot precision/recall curve
figure
plot(recall, precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f', ap))

%% Summary
% This example showed how to train a vehicle detector using deep learning.
% You can follow similar steps to train detectors for traffic signs,
% pedestrians, or other objects.
%
% <matlab:helpview('vision','deepLearning') Learn more about Deep Learning for Computer Vision>.

%% References
% [1] Ren, Shaoqing, et al. "Faster R-CNN: Towards Real-Time Object
% detection with Region Proposal Networks." _Advances in Neural Information
% Processing Systems._ 2015.

