x = linspace( -2*pi, 2*pi );
y = linspace( 0, 4*pi );
[X, Y] = meshgrid(x, y);
Z = sin(X) + cos(Y);

figure;
contour( X, Y, Z );


%%
[X, Y, Z] = peaks;
figure;
contour(X, Y, Z, 20)

%%
x = -2 : 0.2 : 2;
y = -2 : 0.2 : 3;
[X, Y] = meshgrid(x, y);
Z = X .* exp( -X.^2 - Y.^2 );

figure;
contour(X, Y, Z, 'ShowText','on');

%%
x = -3 : 0.125 : 3;
y = -3 : 0.125 : 3;
[X, Y] = meshgrid(x, y);
Z = peaks(X, Y);
v = [1, 1];

figure;
contour(X, Y, Z, v);

