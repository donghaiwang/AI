fmesh( @(x, y) sin(x)+cos(y) )

%%
r = @(s,t) 2 + sin(7.*s + 5.*t);
x = @(s,t) r(s,t) .* cos(s) .* sin(t);
y = @(s,t) r(s,t) .* sin(s) .* sin(t);
z = @(s,t) r(s,t) .* cos(t);
fmesh(x,y,z, [0 2*pi 0 pi]);
alpha(0.8);
grid off

%%
fmesh( @(x,y) erf(x)+cos(y), [-5 0 -5 5] )
hold on;
fmesh( @(x,y) sin(x)+cos(y), [0 5 -5 5] )
hold on;

%% 
fmesh( @(x,y) sin(x)+cos(y), 'EdgeColor','red');