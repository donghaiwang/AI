[X, Y] = meshgrid( 1:0.5:10, 1:20);
Z = sin(X) + cos(Y);
C = X .* Y;
surf(X, Y, Z, C);
colorbar;

%%
[X, Y, Z] = peaks(25);
CO(:, :, 1) = zeros(25);  % red
CO(:, :, 2) = ones(25) .* linspace(0.5, 0.6, 25);  % green
CO(:, :, 3) = ones(25) .* linspace(0, 1, 25);  % blue
surf(X, Y, Z, CO);

%%
[X, Y] = meshgrid(-5 : .5 : 5);
Z = Y .* sin(X) - X .* cos(Y);
s = surf(X, Y, Z, 'FaceAlpha', 0.5);

s.EdgeColor = 'none';