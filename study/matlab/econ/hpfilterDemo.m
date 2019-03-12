load Data_GNP.mat
gnpData = dates;
realgnp = DataTable.GNPR;
[t, c] = hpfilter(realgnp, 1600);

% raw time series
ax1 = subplot(2, 2, 1);
plot(gnpData, realgnp);
title(ax1, 'time series');
axis tight

% long term increase trend
ax2 = subplot(2, 2, 2);
plot(gnpData, t);
title(ax2, 'long term increase trend');
axis tight

% short term cyclical componets
ax3 = subplot(2, 1, 2);
plot(gnpData, c);
title(ax3, 'short term cyclical componets');
axis tight
