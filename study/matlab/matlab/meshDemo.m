[X, Y] = meshgrid( -8 : 0.01 : 8 );
R = sqrt( X.^2 + Y.^2) + eps;
Z = sin(R) ./ R;
mesh( X, Y, Z )

%%
[X, Y] = meshgrid(-8 : 0.5 : 8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R) ./ R;
C = gradient(Z);

figure;
mesh(X,Y,Z, C);

%%
[X, Y] = meshgrid(-8 : 0.5 : 8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R) ./ R;
C = del2(Z);

figure;
mesh(X,Y,Z, C, 'FaceLighting','gouraud', 'LineWidth',0.3);