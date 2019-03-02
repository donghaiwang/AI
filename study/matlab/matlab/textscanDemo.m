chr = '0.14 8.24 3.57 6.24 9.27';
C = textscan(chr, '%f');

% C{1}
celldisp(C);
% cellplot(C);

C = textscan(chr, '%3.1f %*1d');
celldisp(C);

%%
filename = fullfile(matlabroot, 'examples', 'matlab', 'scan1.dat');
fileID = fopen(filename);
C = textscan(fileID, '%s %s %f32 %d8 %u %f %f %s %f');
fclose(fileID);
C;
celldisp(C);
% close('all');
