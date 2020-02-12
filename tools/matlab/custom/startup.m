% run this command when matlab startup

%% Environment variables
aiPath = fullfile('D:', 'workspace', 'AI');
workPath = fullfile(aiPath, 'study', 'matlab', 'matlab');
eval(['cd ', workPath]);
clear aiPath workPath


%% Require add this path to PATH
% customPath = 'D:\workspace\AI\tools\matlab\custom';
% addpath(customPath, '-end');
% savepath

%%
dbstop if error
if ispc
    tmp = 'D:/tmp';
else
    tmp = '/tmp';
end

currentPath = fileparts(mfilename('fullpath'));
addpath(currentPath);


%% System Boot
status = system('C:\Program Files (x86)\EndNote X8\EndNote.exe &');
system('C:\Program Files\JetBrains\PyCharm Community Edition 2019.3.1\bin\pycharm64.exe &');
system('D:\software\MobaXterm Personal Edition\MobaXterm.exe &');

system('C:\Program Files (x86)\Google\Chrome\Application\chrome.exe &');
system('C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.exe &');
system('C:\Program Files\Microsoft Office\Office16\WINWORD.EXE& ');

% Select free GPU device if have GPU


%% temporary operation
% cd D:\workspace\data\MOT\devkit\utils
% mex -g clearMOTMex.cpp
% load tmp.mat
% clipboard('copy','clearMOTMex(gtInfo, stateInfo, td, eval3d)')