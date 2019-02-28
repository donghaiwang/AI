examplePackages = fullfile(fileparts(which('rosgenmsg')), 'examples', 'packages');
userFolder = 'D:\software\matlab_third\custom_msgs';
copyfile(examplePackages, userFolder);

folderpath = userFolder;

rosgenmsg(folderpath);

%% 
addpath('D:\software\matlab_third\custom_msgs\matlab_gen\msggen');
savepath

%%
% custommsg = rosmessage('B/Standalone');
custommsg = rosmessage('B/Standalone');
custommsg2 = rosmessage('A/DependsOnB');