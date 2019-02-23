fsurf( @(x,y) sin(x) + cos(y) )

%%
f1 = @(x,y) erf(x)+cos(y);
fsurf( f1, [-5 0 -5 5] )
hold on;
f2 = @(x, y) sin(x) + cos(y);
fsurf( f2, [0 5 -5 5])
hold off;

%%
r = @(u, v) 2 + sin(7.*u + 5.*v);
funx = @(u,v) r(u,v) .* cos(u) .* sin(v);
funy = @(u,v) r(u,v) .* sin(u) .* sin(v);
funz = @(u,v) r(u,v) .* cos(v);
fsurf(funx, funy, funz, [0 2*pi 0 pi])
camlight

%%
fsurf( @(x,y) y.*sin(x) - x.*cos(y), [-2*pi 2*pi])
title('ysin(x) - xcos(y) for x and y in [-2\pi, 2\pi]')
xlabel('x');
ylabel('y');
zlabel('z');
box on

ax = gca;
ax.XTick = -2*pi : pi/2 : 2*pi;
ax.XTickLabel = {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};

ax.YTick = -2*pi : pi/2 : 2*pi;
ax.YTickLabel = {'-2\pi', '-3\pi/2', '-\pi', '-\pi/2', '0', '\pi/2', '\pi', '3\pi/2', '2\pi'};

%%
funx = @(u,v) u.*sin(v);
funy = @(u,v) -u.*cos(v);
funz = @(u,v) v;

fsurf(funx, funy, funz, [-5 5 -5 -2], '--', 'EdgeColor', 'g')
hold on;
fsurf(funx, funy, funz, [-5 5 -2 2], 'EdgeColor', 'none');
hold off;

%%
clear
x = @(u,v) exp(-abs(u)/10) .* sin(5*abs(v));
y = @(u,v) exp(-abs(u)/10) .* cos(5*abs(v));
z = @(u,v) u;
fs = fsurf(x, y, z);
% fs
fs.URange = [-30 30];
fs.FaceAlpha = .5;

%%
f = @(x,y) 3*(1-x).^2 .* exp(-(x.^2) - (y+1)^2)...
    - 10*(x/5 - x.^3 - y.^5) .* exp(-x.^2 - y.^2)...
    - 1/3*exp(-(x+1).^2 - y.^2);
fsurf(f, [-3 3], 'ShowContours', 'on');

%%
subplot(2,1,1)
fsurf( @(s,t) sin(s),  @(s,t) cos(s),  @(s,t) t/10 .* sin(1./s));
view(-172, 25);
title('Default MeshDensity = 35');

subplot(2, 1, 2);
fsurf( @(s,t) sin(s),  @(s,t) cos(s),  @(s,t) t/10 .* sin(1./s), 'MeshDensity', 40);
view(-172, 25);
title('Increase MeshDensity = 40')
