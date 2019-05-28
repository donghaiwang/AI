%% initial matlab after matlab installation
if ispc
    homeProjectPath = fullfile('d:', 'workspace');
else
    homePath = fileparts(fileparts(userpath));
    homeProjectPath = fullfile(homePath, 'workspace', 'AI');
end
customPath = fullfile(homeProjectPath, 'tools', 'matlab', 'custom');
addpath(customPath);
savepath;

