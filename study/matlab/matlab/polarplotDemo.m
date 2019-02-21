theta = 0 : 0.01 : 2*pi;
weight = 4;
rho = sin(weight*theta) .* cos(weight*theta);
polarplot(theta, rho);

%%
theta = linspace(0, 360, 50);
rho = 0.005 * theta / 10;

thetaRadians = deg2rad(theta);
polarplot(thetaRadians, rho);

%%
theta = linspace(0, 6*pi);
rho1 = theta / 10;
polarplot(theta, rho1);

rho2 = theta / 12;
hold on;
polarplot(theta, rho2, '--')
hold off;

%%
rho = 10 : 5 : 70;
polarplot(rho, '-o')

%%
theta = linspace(0, 2*pi);
rho = sin(theta);
polarplot(theta, rho)

rlim([-1 1])

%%
theta = linspace(0, 2*pi, 25);
rho = 2 * theta;
polarplot(theta, rho, 'r-o')

%%
theta = linspace(0, 2*pi, 25);
rho = 2*theta;
p = polarplot(theta, rho);

p.Color = 'magenta';
p.Marker = 'square';
p.MarkerSize = 8;

%%
Z = [2+3i 2 -1+4i 3-4i 5+2i -4-2i, -2+3i -2 -3i 3i-2i];
polarplot(Z, '*')

