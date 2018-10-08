%% 层次遍历（广度优先遍历）
% 使用例子：
% str = 'D:\workspace\TrafficSign\data\fasterRCNN';
% mFiles2 = RangTraversal(str)
function [ mFiles ] = widthTraversal( strPath )
    %定义两数组，分别保存文件和路径
    mFiles = cell(0,0);
    mPath  = cell(0,0);
    
    mPath{1}=strPath;
    [r,c] = size(mPath);
    while c ~= 0
        strPath = mPath{1};
        Files = dir(fullfile( strPath,'*.*'));
        LengthFiles = length(Files);
        if LengthFiles == 0
            break;
        end
        mPath(1)=[];
        iCount = 1;
        while LengthFiles>0
            if Files(iCount).isdir==1
                if Files(iCount).name ~='.'
                    filePath = [strPath  Files(iCount).name '/'];
                    [r,c] = size(mPath);
                    mPath{c+1}= filePath;
                end
            else
                filePath = [strPath  Files(iCount).name];
                [row,col] = size(mFiles);
                mFiles{col+1}=filePath;
            end
 
            LengthFiles = LengthFiles-1;
            iCount = iCount+1;
        end
        [r,c] = size(mPath);
    end
 
    mFiles = mFiles';
end