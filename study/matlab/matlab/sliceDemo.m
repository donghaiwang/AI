[X, Y, Z] = meshgrid( -2 : 0.2 : 2 );
V = X .* exp( -X.^2 - Y.^2 - Z.^2 );

xslice = [-1.2, 0.8, 2];
yslice = [];
zslice = 0;
slice(X,Y,Z, V, xslice, yslice, zslice)

%%
[xsurf, ysurf] = meshgrid( -2 : 0.2 : 2);
zsurf = xsurf.^2 - ysurf.^2;
slice( X,Y,Z, V, xsurf,ysurf,zsurf);

%%
[X, Y, Z] = meshgrid( -2 : 2);
V = X .* exp( -X.^2 - Y.^2 - Z.^2);
xslice = 0.8;
yslice = [];
zslice = [];
slice( X,Y,Z, V, xslice, yslice, zslice, 'nearest');