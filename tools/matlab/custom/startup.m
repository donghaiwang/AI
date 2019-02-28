% run this command when matlab startup
% Require add this path to PATH
% dbstop if error
if ispc
    tmp = 'D:/tmp';
else
    tmp = '/tmp';
end

currentPath = fileparts(mfilename('fullpath'));
addpath(currentPath);
% addpath(fullfile(currentPath, 'customCommand'));

%% 
% addpath('D:\software\matlab_third\dl');
% cd D:\workspace\tracking\DeepCC

%% temporary operation
% cd D:\workspace\data\MOT\devkit\utils
% mex -g clearMOTMex.cpp
% load tmp.mat
% clipboard('copy','clearMOTMex(gtInfo, stateInfo, td, eval3d)')