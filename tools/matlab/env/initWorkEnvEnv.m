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

AIProgramDir = fullfile(workspaceDir, 'AI');
if ~exist(AIProgramDir, 'dir')
    !git clone https://github.com/donghaiwang/AI
else
    disp('AI Program exist');
end

