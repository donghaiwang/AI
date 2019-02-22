f = @(x,y) sin(x) + cos(y);
fcontour(f);


%%
fcontour( @(x,y) erf(x) + cos(y), [-5 0 -5 5]);
hold on;
fcontour( @(x,y) sin(x) + cos(y), [0 5 -5 5]);
hold on;
grid on;

%%
f = @(x,y) x.^2 - y.^2;
fcontour(f, '--', 'LineWidth', 2);

%%
fcontour( @(x,y) sin(x) + cos(y) );
hold on;
fcontour( @(x,y) x-y);
hold off;

%%
f = @(x,y) exp(-(x/2).^2 - (y/2).^2) + exp(-(x+2).^2 - (y+2).^2);
fc = fcontour(f);

fc.LineWidth = 1;
fc.LineStyle = '--';
fc.LevelList = [1 0.9 0.8 0.2 0.1];
colorbar;

%%
f = @(x,y) erf((y+2).^3) - exp(-0.65*((x-2).^2 + (y-2).^2));
fcontour(f, 'Fill', 'on');

%%
f = @(x,y) sin(x) + cos(y);
fcontour(f, 'LevelList', [-1 0 1]);

%%
f = @(x,y) sin(x) .* sin(y);
subplot(2,1, 1);
fcontour(f);
title('Default Mesh Density (71)');

subplot(2, 1, 2);
fcontour(f, 'MeshDensity', 200);
title('Custom Mesh Density (200)');

%%
clear; clc;
fcontour( @(x,y) x.^sin(y) - y.*cos(x), [-2*pi 2*pi], 'LineWidth', 2);
grid on;
title({'xsin(y) - ycos(x)', ...
    '-2\pi < x < 2\pi and -2\pi < y < 2\pi'});
xlabel('x');
ylabel('y');