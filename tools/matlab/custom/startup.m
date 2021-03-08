% run this command when matlab startup

%% Environment variables

%% Require add this path to PATH
% customPath = 'D:\workspace\AI\tools\matlab\custom';
% addpath(customPath, '-end');
% savepath

dbstop if error
if ispc
    tmp = 'D:/tmp';
    workspace_dir = fullfile('D:', 'workspace');
else
    tmp = '/tmp';
    workspace_dir = '/data2/whd/workspace';
end
ai_dir = fullfile(workspace_dir, 'AI');

% workPath = fullfile(ai_dir, 'study', 'matlab', 'matlab');
% eval(['cd ', workPath]);
% clear ai_dir workPath

% 启动matlab时，默认进入进入当前工程的主目录（hart）
cur_workspace_dir = fullfile(workspace_dir, 'sot', 'hart');
eval(['cd ', cur_workspace_dir]);
clear cur_workspace_dir

custom_dir = fileparts(mfilename('fullpath'));
addpath(custom_dir);

% cdtmp();

%% Path
addpath('/data2/whd/workspace/sot/hart/utils');
addpath('/data2/whd/workspace/sot/hart/utils/spm12');
addpath('/data2/whd/workspace/sot/hart/utils/xjview');


%% System Boot
% status = system('C:\Program Files (x86)\EndNote X8\EndNote.exe &');
% system('C:\Program Files\JetBrains\PyCharm Community Edition 2019.3.1\bin\pycharm64.exe &');
% system('D:\software\MobaXterm Personal Edition\MobaXterm.exe &');

% system('C:\Program Files (x86)\Google\Chrome\Application\chrome.exe &');
% system('C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.exe &');
% system('C:\Program Files\Microsoft Office\Office16\WINWORD.EXE& ');

% Select free GPU device if have GPU


%% temporary operation
% cd D:\workspace\data\MOT\devkit\utils
% mex -g clearMOTMex.cpp
% load tmp.mat
% clipboard('copy','clearMOTMex(gtInfo, stateInfo, td, eval3d)')
