C = [0  2   4   6;
     8  10  12  14;
     16 18  20  22];
imagesc(C);
colorbar

%%
x = [5 8];
y = [3 6];
imagesc(x, y, C)

%%
clims = [4  18];
imagesc(C, clims);
colorbar

%%
C = [
    1   2   3;
    4   5   6;
    7   8   9;
    ];
im = imagesc(C);
im.AlphaData = .5;

%%
Z = 10 + peaks;
surf(Z);
hold on
imagesc(Z);