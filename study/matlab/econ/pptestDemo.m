load Data_GDP.mat
logGDP = log(Data);

h = pptest(logGDP, 'model', 'TS', 'lags', 0:2);