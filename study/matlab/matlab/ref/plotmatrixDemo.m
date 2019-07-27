X = randn(50, 3);
Y = reshape(1:150, 50, 3);
plotmatrix(X, Y);

%%
X = randn(50, 3);
plotmatrix(X, '*r');

%%
rng default
X = randn(50 ,3);
[S, AX, BigAx, H, HAx] = plotmatrix(X);

S(3).Color = 'g';
S(3).Marker = '*';

H(3).EdgeColor = 'k';
H(3).FaceColor = 'g';

title(BigAx, 'A comparision of Data Sets');
