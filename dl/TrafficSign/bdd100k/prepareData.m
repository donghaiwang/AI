addpath('../tools/jsonlab-1.5/');
labelTrainDir = '../data/bdd100k/labels/100k/train/';
newLabelFilePath = fullfile('..', 'data', 'bdd100k', 'roadObjectDetection.txt');  % 转换以后的标注文件
newLabelFileID = fopen(newLabelFilePath, 'a');

varNames = {'Temperature','Time','Station'};
table('VariableNames', varNames);

labelsFilesInfo = dir(labelTrainDir);
for labelIndex = 1 : length(labelsFilesInfo)
    labelItem = labelsFilesInfo(labelIndex);
    
    if ~strcmp(labelItem.name, '.') && ~strcmp(labelItem.name, '..')
        [labelItemFilepath,labelItemName,labelItemExt] = fileparts(labelItem.name);
        imageReletivePath = fullfile('..', 'data', 'bdd100k', 'images', '100k', 'train', [labelItemName '.jpg']);
        newline = strcat(imageReletivePath, '#');  % 标注文件中一行的新内容
        boxsCoordinate = '[';  % 转换后的坐标形式[;]
        
        labelFullPath = fullfile(labelItem.folder, labelItem.name);
        labelsInfo = loadjson(labelFullPath);
        if isfield(labelsInfo, 'frames')  % 结构体中是否存在frames字段
            frameInfos = labelsInfo.frames{1, 1}.objects;  % 每一张图片所有的标注信息
            boxCount = 0;
            imageContent = imread(imageReletivePath);
            for objIndex = 1 : length(frameInfos)
                objInfo = frameInfos{objIndex};  % 每一个标注类别的信息
                if isfield(objInfo, 'box2d') % 只统计标注类别是box的情况
                    boxCount = boxCount + 1;
                    boxCoordinate = objInfo.box2d;
                    boxCoordinateStr = sprintf('%d,%d,%d,%d', uint32(boxCoordinate.x1), ...
                        uint32(boxCoordinate.y1), uint32(boxCoordinate.x2), uint32(boxCoordinate.y2));
                    if boxCount == 1
                        boxsCoordinate = [boxsCoordinate boxCoordinateStr];
                    else
                        boxsCoordinate = [boxsCoordinate ';' boxCoordinateStr];
                    end
                    imageContent = insertShape(imageContent, 'Rectangle', ...
                         [uint32(boxCoordinate.x1), uint32(boxCoordinate.y1), ...
                         uint32(boxCoordinate.x2)-uint32(boxCoordinate.x1), uint32(boxCoordinate.y2)-uint32(boxCoordinate.y1)], ...
                         'Color', 'red', 'LineWidth', 6);
                end
            end
            imshow(imageContent);
        end
        boxsCoordinate = [boxsCoordinate ']'];
        newline = [newline boxsCoordinate];
        newLabelFileID = fopen(newLabelFilePath, 'a');
        fprintf(newLabelFileID, '%s\r\n', newline);
        fclose(newLabelFileID);
    end
end

test = loadjson('../data/bdd100k/labels/100k/train/0000f77c-62c2a288.json');