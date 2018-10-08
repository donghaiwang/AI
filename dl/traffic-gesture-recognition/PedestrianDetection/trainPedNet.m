%   This script demonstrates training for pedestrian detection network.
%   Images of pedestrians and non-pedestrians are to be placed in
%   pedestrian and non-pedestrian folders respectively.
%   
%   Copyright 2017 The MathWorks, Inc.

PedDatasetPath = ('input folder path'); % Input folder should contain pedestrian and non-pedestrian folders.
categories = {'Ped', 'NonPed'};

PedData = imageDatastore(fullfile(PedDatasetPath, categories), 'LabelSource', 'foldernames');

minSetCount = min(PedData.countEachLabel{:,2});
trainSamples = round(minSetCount * 0.7);

[trainPedData,testPedData] = splitEachLabel(PedData, ...
    trainSamples,'randomize');

layers = [imageInputLayer([64 32 3])
    convolution2dLayer(5,20)
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)
    crossChannelNormalizationLayer(5,'K',1);
    convolution2dLayer(5,20)
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(512)
    fullyConnectedLayer(2)
    softmaxLayer()
    classificationLayer()];

options = trainingOptions('sgdm','MaxEpochs',20, ...
    'InitialLearnRate',0.001);

PedNet = trainNetwork(trainPedData,layers,options);





