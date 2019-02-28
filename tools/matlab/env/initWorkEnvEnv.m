clear;clc;

if ispc
    workspacePrefix = 'D:\';
end
workspaceDir = fullfile(workspacePrefix, 'workspace');
if ~exist(workspaceDir, 'dir')
    eval(['mkdir ' workspaceDir]);
else
    disp('workspace existed');
end

eval(['cd ' workspaceDir])

AI_projectDir = fullfile(workspaceDir, 'AI');
if ~exist(AI_projectDir, 'dir')
    !git clone https://github.com/donghaiwang/AI
else
    disp('AI project exists');
end

%% Clone note project
noteProjectDir = fullfile(workspaceDir, 'donghaiwang');
if ~exist(noteProjectDir, 'dir')
    !git clone https://github.com/donghaiwang/donghaiwang.git
else
    disp('Note project exists');
end

%%
customPath = fullfile(fileparts(fileparts( mfilename('fullpath') )), 'custom');
eval(['cd ' customPath]);
addpath(customPath);
savepath;
