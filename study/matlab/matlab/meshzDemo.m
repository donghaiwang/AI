figure;
[X, Y] = meshgrid(-3 : .125 : 3);
Z = peaks(X, Y);
meshz(Z);

%%
[X, Y] = meshgrid( -3 : .0125 : 3);
Z = peaks(X, Y);
C = gradient(Z);

figure;
meshz( X,Y,Z, C)