filename = 'topography.mat';
m = matfile(filename);

topo = m.topo;

%%
x = magic(20);
saveFileName = fullfile(tempdir, 'myFile.mat');
save(saveFileName, 'x');

m = matfile(saveFileName, 'Writable', true);

y = magic(15);

m.y = y;

whos('-file', saveFileName);