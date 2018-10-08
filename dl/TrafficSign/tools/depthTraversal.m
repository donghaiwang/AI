%% 深度优先遍历
%   Input:
%    strPath: the directory of the file   
%    mFiles:  save the directory of the files
%    iTotalCount: the count of the walked files
%   Ouput:
%    mResFiles: the full directory of every file   
%    iTCount:   the total file count in the directory which your hava input
%  使用例子：
%-------------------------------------------------------
% str = 'D:\workspace\TrafficSign\data\fasterRCNN';
% mFiles = [];
% [mFiles, iFilesCount] = DeepTravel(str,mFiles,0)
% mFiles = mFiles';
%-------------------------------------------------------
 
function [ mResFiles, iTCount ] = depthTraversal( strPath, mFiles, iTotalCount )
    iTmpCount = iTotalCount;
    path=strPath;
    Files = dir(fullfile( path,'*.*'));
    LengthFiles = length(Files);
    if LengthFiles <= 2
        mResFiles = mFiles;
        iTCount = iTmpCount;
        return;
    end
 
 
    for iCount=2:LengthFiles
        if Files(iCount).isdir==1  
            if Files(iCount).name ~='.'  
                filePath = [strPath  Files(iCount).name '/'];  
                [mFiles, iTmpCount] = depthTraversal( filePath, mFiles, iTmpCount);
            end  
        else  
            iTmpCount = iTmpCount + 1;
            filePath = [strPath  Files(iCount).name]; 
            mFiles{iTmpCount} = filePath;
        end 
    end
    mResFiles = mFiles;
    iTCount = iTmpCount;
end