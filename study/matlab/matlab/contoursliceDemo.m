[X, Y, Z, V] = flow;

zslice = 0;
contourslice(X, Y, Z, V, [], [], zslice);
grid on;

%%
[X, Y, Z] = meshgrid(-2: 0.2 : 2);
V = X .* exp( -X.^2 - Y.^2 - Z.^2 );
% [X, Y] = meshgrid(-2: 0.2 : 2);
% V = X .* exp( -X.^2 - Y.^2);
% 
% surf(X, Y, V);

xslice = [-1.2, 0.8, 2];
yslice = [];
zslice = [];
contourslice(X, Y, Z, V, xslice, yslice, zslice);
view(3);
grid on;
% box on;


%%
[X, Y, Z] = meshgrid(-2 : 0.2 : 2);
V = X .* exp( -X.^2 - Y.^2 - Z.^2);
xslice = [-1.2, 0.8, 2];
lvls = -0.2 : 0.01 : 0.4;

contourslice(X, Y, Z, V, xslice, [], [], lvls);
colorbar
view(3);
grid on

%%
[X, Y, Z] = meshgrid(-5 : 0.2 : 5);
V = X .* exp( -X.^2 - Y.^2 - Z.^2);

[xsurf, ysurf] = meshgrid(-2 : 0.2 : 2);
zsurf = xsurf.^2 - ysurf .^ 2;
contourslice(X, Y, Z, V, xsurf, ysurf, zsurf, 20);
view(3);
grid on;