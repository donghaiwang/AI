h = animatedline;
axis([0, 4*pi, -1, 1])

x = linspace(0, 4*pi, 1000);
y = sin(x);
for k = 1 : length(x)
    addpoints(h, x(k), y(k));
%     drawnow limitrate;
end

%%
[xdata, ydata] = getpoints(h);
clearpoints(h);
drawnow

%% 
x = [1 2];
y = [1 2];
h = animatedline(x, y, 'Color', 'r', 'LineWidth', 3);

%%
clear; clc;
h = animatedline('MaximumNumPoints', 100);
axis([0, 4*pi, -1, 1])

x = linspace(0, 4*pi, 1000);
y = sin(x);
for k = 1 : length(x)
    addpoints(h, x(k), y(k));
    drawnow
end

%%
h = animatedline;
axis([0, 4*pi, -1 1])

numpoints = 100000;
x = linspace(0, 4*pi, numpoints);
y = sin(x);

for k = 1 : 100 : numpoints-99
    xvec = x(k : k+99);
    yvec = y(k : k+99);
    addpoints(h, xvec, yvec)
    drawnow limitrate
end

%%
h = animatedline;
axis([0, 4*pi, -1, 1])
numpoints = 10000;
x = linspace(0, 4*pi, numpoints);
y = sin(x);
a = tic;
for k = 1 : numpoints
    addpoints(h, x(k), y(k));
    b = toc(a);
    if b > (1 / 30)
        drawnow;
        a = tic;
    end
end
drawnow;