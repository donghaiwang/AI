[x, y] = meshgrid(0:0.1:1, 0:0.1:1);
u = x;
v = -y;

figure;
quiver(x, y, u, v)

startx = .1 : .1 : 1;
starty = ones(size(startx));
streamline(x, y, u, v, startx, starty);