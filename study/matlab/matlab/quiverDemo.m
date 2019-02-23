[x,y] = meshgrid(0:0.2:2, 0:0.2:2);
u = cos(x) .* y;
v = sin(x) .* y;

figure
quiver(x,y, u,v);

%%
[X,Y] = meshgrid(-2:0.2:2);
Z = X .* exp( -X.^2 - Y.^2);
[DX, DY] = gradient(Z, 0.2, 0.2);
figure
contour(X, Y, Z);
hold on;
quiver(X, Y, DX, DY);
hold off