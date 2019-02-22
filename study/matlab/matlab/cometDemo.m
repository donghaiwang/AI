t = 0 : .01 : 2*pi;
x = cos(2*t) .* (cos(t).^2);
y = sin(2*t) .* (sin(t).^2);
comet(x, y);