%% Install cudnn after CUDA
clear; clc;
installPackageDir = 'D:\install';
CUDA_dir = 'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0';

cudnnCompressedPackageFullpath = fullfile(installPackageDir, 'cudnn-9.0-windows10-x64-v7.5.0.56.zip');
cudnnFullpath = fullfile(installPackageDir, 'cuda');

dllDstFullPath = fullfile(CUDA_dir, 'bin', 'cudnn64_7.dll');
headerDstFullPath = fullfile(CUDA_dir, 'include', 'cudnn.h');
libDstFullPath = fullfile(CUDA_dir, 'lib', 'x64', 'cudnn.lib');

%% Extract .zip to the folder cudnn
if ~exist(cudnnFullpath, 'dir')
    unzip(cudnnCompressedPackageFullpath, installPackageDir);
else
    disp('extract finished before');
end


%% Copy file to CUDA directory
% copy dll file
if ~exist(dllDstFullPath, 'file')
    copyfile(fullfile(cudnnFullpath, 'bin', 'cudnn64_7.dll'), dllDstFullPath);
else
    disp(['existed dll file in: ' dllDstFullPath]);
end

% copy header file
if ~exist(headerDstFullPath, 'file')
    copyfile(fullfile(cudnnFullpath, 'include', 'cudnn.h'), headerDstFullPath);
    disp(['Copy header file to CUDA directory: ' headerDstFullPath]);
else
    disp(['existed header file in: ' headerDstFullPath]);
end

% copy lib file 
if ~exist(libDstFullPath, 'file')
    copyfile(fullfile(cudnnFullpath, 'lib', 'x64', 'cudnn.lib'), libDstFullPath);
    disp(['Copy lib file to CUDA directory: ' libDstFullPath]);
else
    disp(['existed lib file in: ' libDstFullPath]);
end





