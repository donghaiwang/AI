%% initial matlab after matlab installation
if ispc
    homeProjectPath = fullfile('d:', 'workspace');
    customPath = fullfile(homeProjectPath, 'tools', 'matlab', 'custom');
    addpath(customPath);
    savepath;
else  % change userpath to custom directory in linux: userpath('CUSTOM_PATH');
    homePath = fileparts(fileparts(userpath));
    homeProjectPath = fullfile(homePath, 'workspace', 'AI');
    customPath = fullfile(homeProjectPath, 'tools', 'matlab', 'custom');
    userpath(customPath);
end


