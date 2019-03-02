
tempFile = fullfile(tempdir, 'myfile.txt');

X = magic(3);
dlmwrite(tempFile, [X*5 X/5], ' ');

dlmwrite(tempFile, X, '-append', ...
    'roffset', 1, 'delimiter', ' ');

type(tempFile);

%%
M = dlmread(tempFile);
M2 = importdata(tempFile);

%%
% which dlmlist.txt
% str = "test max min direction
% 10 27.7 12.4 12
% 11 26.9 13.5 18
% 12 27.4 16.9 31
% 13 25.1 12.7 29 ";
filename = fullfile(tempdir, 'dlmlist.txt');
M = dlmread(filename, ' ', 1, 0);

%%
M = dlmread(filename, ' ', [3 0 4 3]);

m = [3 6 9 12 15; 5 10 15 20 25; ...
     7 14 21 28 35; 11 22 33 44 55];

 csvFilename = fullfile(tempdir, 'csvlist.dat');
 
 csvwrite(csvFilename, m);
 
 type(csvFilename);
 
 %%
 csvwrite(csvFilename, m, 0, 2);
 type(csvFilename);