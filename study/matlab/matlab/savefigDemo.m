figure;
surf(peaks);
savefig('PeaksFile.fig');


%%
openfig('PeaksFile.fig');

%%
h(1) = figure;
z = peaks;
surf(z);

h(2) = figure;
plot(z)

savefig(h, 'TwoFigureFile.fig');

figs = openfig('TwoFigureFile.fig');

%%
h = figure;
surf(peaks);
savefig(h, 'PeaksFile.fig', 'compact');

openfig('PeaksFile.fig');

%%
h = findobj(gca, 'Type', 'line');

%%
plot(1:10);
txt = xlabel('My x-axis label');
txt.HandleVisibility;

a = findall(gcf, 'Type', 'text');

%%
h = surf(peaks);
colormap hsv

%%
get(groot);