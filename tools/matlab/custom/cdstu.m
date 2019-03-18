%% cd temporary directory using 'cdtmp' in Command Window
function cdstu()
    projectPath = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    studyPath = fullfile(projectPath, 'study', 'matlab', 'matlab');
    eval(['cd ' studyPath]);
%     if ispc
%         tmp = 'D:/tmp';
%     else
%         tmp = '/tmp';
%     end
%     
%     eval(['cd ' tmp]);
end