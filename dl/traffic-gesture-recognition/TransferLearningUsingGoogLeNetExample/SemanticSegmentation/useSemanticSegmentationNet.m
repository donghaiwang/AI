
% testImgPath = 'D:\workspace\traffic-gesture-recognition\TransferLearningUsingGoogLeNetExample\test_data\my\stop\xiongjingjing\184.jpg';
% testImgPath = 'D:\workspace\traffic-gesture-recognition\TransferLearningUsingGoogLeNetExample\SemanticSegmentation\CamVid\images\701_StillsRaw_full\0001TP_008220.png';
testImgPath = 'D:\workspace\traffic-gesture-recognition\TransferLearningUsingGoogLeNetExample\test_data\my\go_straight\wanghaidong\244.jpg';
load('SemanticSegmentationNet.mat', 'net');

ds = datastore(testImgPath);
I = read(ds);
C = semanticseg(I, net);
%% 
% Display the results.

cmap = camvidColorMap;
B = labeloverlay(I, C, 'Colormap', cmap, 'Transparency', 0.2);
figure
imshow(B)
% pixelLabelColorbar(cmap, classes);



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