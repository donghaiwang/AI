th = pi/4 : pi/4 : 2*pi;
r = [19 6 12 18 16 11 15 15];
polarscatter(th, r);

%%
th = linspace(0, 2*pi, 20);
r = rand(1, 20);
sz = 75;
polarscatter(th, r, sz, 'filled');

%%
th = pi/4 : pi/4 : 2*pi;
r = [19 6 12 18 16 11 15 15];
sz = 100 * [6 15 20 3 15 3 6 40];
c = [1 2 2 2 1 1 2 1];
polarscatter(th, r, sz, c, 'filled', 'MarkerFaceAlpha', 0.5);

%%
th = linspace(0, 360, 50);
r = 0.005 * th / 10;
th_radians = deg2rad(th);
polarscatter(th_radians, r);

%%
th = pi/6 : pi/6 : 2*pi;
r1 = rand(12, 1);
polarscatter(th, r1, 'filled');

hold on;
r2 = rand(12, 1);
polarscatter(th, r2, 'filled');
hold off;
legend('Series A', 'Series B');

%%
th = pi/6 : pi/6 : 2*pi;
r = rand(12, 1);
ps = polarscatter(th, r, 'filled');

ps.Marker = 'square';
ps.SizeData = 200;
ps.MarkerFaceColor = 'red';
ps.MarkerFaceAlpha = 0.5;


