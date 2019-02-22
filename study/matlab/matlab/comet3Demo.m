t = -10*pi : pi/250 : 10*pi;
x = (cos(2*t).^2) .* sin(t);
y = (sin(2*t).^2) .* sin(t);
comet3(x, y, t);