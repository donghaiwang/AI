Z = peaks(100);

zmin = floor(min(Z(:)));
zmax = ceil(max(Z(:)));
zInc = (zmax - zmin) / 40;
zlevs = zmin : zInc : zmax;

figure;
contour(Z, zlevs);


zindex = zmin : 2 : zmax;
hold on
contour(Z, zindex, 'LineWidth', 2);
hold off

