x = -3 : 0.5 : 3;
y = -3 : 0.5 : 3;
[X, Y] = meshgrid(x, y);
Z = Y.^2 - X.^2;
[U, V, W] = surfnorm(Z);

figure;
quiver3(Z, U, V, W);
view(-35, 45);

%%
[X, Y] = meshgrid( -2:0.25:2, -1 : 0.2 : 1);
Z = X .* exp( -X.^2 - Y.^2 );
[U, V, W] = surfnorm(X, Y, Z);

figure;
quiver3(X, Y, Z, U, V, W, 0.5);

hold on;
surf(X, Y, Z);
view(-35, 45);
axis([-2 2 -1 1 -0.6 0.6]);
hold off;