x = magic(20);

save('myFile.mat', 'x');

m = matfile('myFile.mat', 'Writable', true);
y = magic(15);
m.y = y;

whos('-file', 'myFile.mat')

%%
delete('myFile.mat');
