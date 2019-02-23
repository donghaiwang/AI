pcolor(hadamard(20));
colormap(gray(2));
axis ij
axis square

%%
n = 6;
r = (0:n)'/n;
theta = pi * (-n:n) / n;
X = r * cos(theta);
Y = r * sin(theta);
C = r * cos(2 * theta);
pcolor(X, Y, C);
axis equal tight