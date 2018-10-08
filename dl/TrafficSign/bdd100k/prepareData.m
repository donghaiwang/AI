addpath('../tools/jsonlab-1.5/');
labelTrainDir = '../data/bdd100k/labels/100k/train/';
newLabelFilePath = fullfile('..', 'data', 'bdd100k', 'roadObjectDetection.txt');  % ת���Ժ�ı�ע�ļ�
newLabelFileID = fopen(newLabelFilePath, 'a');

varNames = {'Temperature','Time','Station'};
table('VariableNames', varNames);

labelsFilesInfo = dir(labelTrainDir);
for labelIndex = 1 : length(labelsFilesInfo)
    labelItem = labelsFilesInfo(labelIndex);
    
    if ~strcmp(labelItem.name, '.') && ~strcmp(labelItem.name, '..')
        [labelItemFilepath,labelItemName,labelItemExt] = fileparts(labelItem.name);
        imageReletivePath = fullfile('..', 'data', 'bdd100k', 'images', '100k', 'train', [labelItemName '.jpg']);
        newline = strcat(imageReletivePath, '#');  % ��ע�ļ���һ�е�������
        boxsCoordinate = '[';  % ת�����������ʽ[;]
        
        labelFullPath = fullfile(labelItem.folder, labelItem.name);
        labelsInfo = loadjson(labelFullPath);
        if isfield(labelsInfo, 'frames')  % �ṹ�����Ƿ����frames�ֶ�
            frameInfos = labelsInfo.frames{1, 1}.objects;  % ÿһ��ͼƬ���еı�ע��Ϣ
            boxCount = 0;
            imageContent = imread(imageReletivePath);
            for objIndex = 1 : length(frameInfos)
                objInfo = frameInfos{objIndex};  % ÿһ����ע������Ϣ
                if isfield(objInfo, 'box2d') % ֻͳ�Ʊ�ע�����box�����
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