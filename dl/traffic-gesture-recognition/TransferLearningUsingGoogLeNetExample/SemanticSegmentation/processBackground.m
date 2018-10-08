
%% read RGB value
% test_RGB_image_path = 'D:\workspace\traffic-gesture-recognition\TransferLearningUsingGoogLeNetExample\chinese_traffic_gesture_dataset\stop\1_1_1_0.png';
% test_RGB_image = imread(test_RGB_image_path);

%%


%%
label_main_path = [pwd '\label'];
raws_path = [label_main_path '\raw\'];
processed_result_path = [label_main_path, '\processed_result\'];

gTruth = load([label_main_path '\label_result\gTruth.mat']);
dataSource = gTruth.gTruth.DataSource.Source;
labelData = gTruth.gTruth.LabelData;
for i = 1 : size(dataSource)
    back_layer = read(datastore(dataSource{i}));
    labeledImgPath = labelData(i, 'PixelLabelData');  % get a table
    labeledImgPath = labeledImgPath{1, 1};  % get a cell
    labeledImgPath = labeledImgPath{1, 1};
    fore_layer = read(datastore(labeledImgPath));
    
    image_size = size(back_layer);
    width = image_size(1);
    height = image_size(2);
    for j = 1:width
        for k = 1 : height
            if fore_layer(j,k) == 1
                back_layer(j, k, 1) = 30;
                back_layer(j, k, 2) = 100;
                back_layer(j, k, 3) = 54;
            end
        end
    end
    cellstr = strsplit(dataSource{i}, '\');
    [m, n] = size(cellstr);
    saveFileName = cellstr{1, n};
    imwrite(back_layer, [processed_result_path 'processed_' saveFileName]);
%     pixelLabelDataPath = labelData(i, 'PixelLabelData');
end

% raw_dir = dir(fullfile(raws_path, '*.jpg'));
% for i = 1 : size(raw_dir)
%     testImgPath = [raws_path, raw_dir(i).name];
%     labeledImgPath = [label_main_path '\label_result\PixelLabelData\Label_1.png'];
% end
% labeledImgPath = 'D:\workspace\traffic-gesture-recognition\TransferLearningUsingGoogLeNetExample\SemanticSegmentation\label\result\PixelLabelData\Label_1.png';
% 
% ds = datastore(testImgPath);
% back_layer = read(ds);
% 
% labeledDataStore = datastore(labeledImgPath);
% fore_layer = read(labeledDataStore);
% 
% image_size = size(back_layer);
% width = image_size(1);
% height = image_size(2);
% 
% for i = 1:width
%     for j = 1 : height
%         if fore_layer(i,j) == 1
%             back_layer(i, j, 1) = 30;
%             back_layer(i, j, 2) = 100;
%             back_layer(i, j, 3) = 54;
%         end
%     end
% end
% 
% % B = labeloverlay(back_layer,fore_layer);
% figure
% imshow(back_layer)
% imwrite(back_layer, 'D:\tmp\processed.jpg');



% cmap = camvidColorMap;
% B = labeloverlay(I,C, 'Colormap', cmap, 'Transparency', 0.2);
% 
% figure
% imshow(B)


function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    30 100 54   % background(1)
    23 23 23       % foreground(2)
%     192 192 192   % Pole
%     128 64 128    % Road
%     60 40 222     % Pavement
%     128 128 0     % Tree
%     192 128 128   % SignSymbol
%     64 64 128     % Fence
%     64 0 128      % Car
%     64 64 0       % Pedestrian
%     0 128 192     % Bicyclist
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end