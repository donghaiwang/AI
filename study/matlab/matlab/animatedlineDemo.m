h = animatedline;
axis([0, 4*pi, -1, 1])

x = linspace(0, 4*pi, 1000);
y = sin(x);
for k = 1 : length(x)
    addpoints(h, x(k), y(k));
    drawnow limitrate;
end