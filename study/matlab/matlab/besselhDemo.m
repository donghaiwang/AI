[X, Y] = meshgrid(-4:0.025:2, -1.5:0.025:1.5);

H = besselh(0, 1, X+1i * Y);
contour(X, Y, abs(H), 0:0.2:3.2);

hold on;
contour(X, Y, (180/pi)*angle(H), -180:10:180)
hold off;