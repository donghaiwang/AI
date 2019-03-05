%% Deep Learning Visualization: CAM Visualization
% The example that refers <https://blogs.mathworks.com/deep-learning/2019/01/31/deep-learning-visualizations-cam-visualization/ page> can be helpful in deep learning to help uncover what's going
% on inside your neural network.

%% CAM Visualizations
% This is help answer the questions:"How did my network decide which
% category an image falls under?" With class activation mapping, or CAM,
% you can uncover which region of an image mostly strongly influenced the
% network prediction.

%% Load pretrained network for image classification
% SqueezeNet, GoogleNet, ResNet-18 are good choice, since they're
% relatively fast.
netName = 'squeezenet';
net = eval(netName);
inputSize = net.Layers(1, 1).InputSize;

switch netName
    case 'squeezenet'
        layerName = 'relu_conv10';
    case 'googlenet'
        layerName = 'inception_5b-output';  % DepthConcatenationLayer(139)
    case 'resnet18'
        layerName = 'res5b';
    otherwise
        disp('Not support network');
        return;
end

classes = net.Layers(end).ClassNames;

%% Run this on an image
% The class activation map for a specific class is the activation of the
% ReLU Layer, weighted by how much each activation contributes to the final
% score of the class.
im = imread('peppers.png');
% imshow(im);
imResized = imresize(im, [inputSize(1), NaN]);
imageActivations = activations(net, imResized, layerName);

%%%
% The weights are from the final fully connected layer of the network for
% that class. SqueezeNet doesn't have a final fully connected layer, so the
% output of the ReLU layer is already the class activation map.
scores = squeeze( mean(mean(imageActivations, 1), 2) );
[~, classIds] = maxk(scores, 3);

if strcmpi(netName, 'squeezenet') == 1
    classActivationMap = imageActivations(:, :, classIds(1));
else
    fcWeights = net.Layers(end-2).Weights;
    fcBias = net.Layers(end-2).Bias;
    scores = fcWeights * scores + fcBias;
    
    weightVector = shiftdim( fcWeights(classIds(1), :), -1);
    classActivationMap = sum(imageActivations .* weightVector, 3);
end



%%%
% Calculate the top class labels and the final normalized class scores.
scores = exp(scores) / sum(exp(scores));
maxScores = scores(classIds);
labels = classes(classIds);

%% Visualize results
imshow(im);
CAMshow(im, classActivationMap);
title(string(labels) + "," + string(maxScores));
drawnow;

%% Helper functions
function CAMshow(im, CAM)
    imSize = size(im);
    CAM = imresize(CAM, imSize(1:2));
    CAM = normalizeImage(CAM);
    CAM(CAM < 0.2) = 0;
    cmap = jet(255) .* linspace(0, 1, 255)';
    CAM = ind2rgb(uint8(CAM*255), cmap) * 255;
    
    combinedImage = double(rgb2gray(im))/2 + CAM;
    combinedImage = normalizeImage(combinedImage) * 255;
    imshow(uint8(combinedImage));
end

function N = normalizeImage(I)
    minimum = min(I(:));
    maximum = max(I(:));
    N = (I - minimum) / (maximum - minimum);
end

