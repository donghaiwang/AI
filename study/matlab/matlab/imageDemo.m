C = [0 2 4 6; 8 10 12 14; 16 18 20 22];
image(C)
colorbar

%%
image(C, 'CDataMapping', 'scaled')
colorbar

%%
x = [5 8];
y = [3 6];
C = [0 2 4 6; 8 10 12 14; 16 18 20 22];
image(x, y, C)

%%
C = zeros(3, 3, 3);
C(:, :, 1) = [.1 .2 .3;
    .4 .5 .6;
    .7 .8 .9];
image(C)

%%
plot(1:3)
hold on;
C = [1 2 3; 
    4 5 6;
    7 8 9];
im = image(C);
im.AlphaData = 0.5;

%% 
C = imread('ngc6543a.jpg');
image(C);

%%
Z = 10 + peaks;
surf(Z);
hold on;
image(Z, 'CDataMapping', 'scaled');