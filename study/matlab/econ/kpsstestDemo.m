load Data_NelsonPlosser.mat

logGNPR = log(DataTable.GNPR);

lags = (0:8)';
[~, pValue, stats] = kpsstest(logGNPR, 'Lags', lags, 'Trend', true);
result = [lags pValue stats];

%%
load Data_NelsonPlosser.mat
wages = DataTable.WN;
T = sum(isfinite(wages));
sqrtT = sqrt(T);

plot(dates, wages);
title('Wages');
axis tight;

logWages = log(wages);

%%
logWages = log(wages);
plot(dates, logWages);
title('Log Wages');
axis tight;

%%
[h, pValue] = kpsstest(logWages, 'lags', [7:10]);


