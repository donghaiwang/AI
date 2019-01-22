clc
clear all

%%
load useNN_30_120.dat
N = 1024;

fid = fopen('PSF_030_120_useNN.dat', 'w');

for i = 1 : N
    for j = 1 : N
        fprintf(fid, '%5d%5d%10d\n', i, j, useNN_30_120(i, j));
    end
end

% close(fid);

% save PSF_030_120_useNN.dat photonArray -ascii
