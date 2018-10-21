%% 将一个目录下的文件夹名写入一个名字叫做list.txt的文本文件中
clear;
sourceDir = 'C:\Users\DELL\Downloads\vot2014';

fid = fopen(fullfile(sourceDir, 'list.txt'), 'wt');
dirInfos = dir(sourceDir);
for i = 1 : length(dirInfos)
    dirItem = dirInfos(i);
    if strcmp(dirItem.name, '.') ~= 1 && strcmp(dirItem.name, '..') ~= 1 && dirItem.isdir == 1
        fprintf(fid, '%s\n', dirItem.name);
    end
end
fclose(fid);
