load Data_Canada.mat
Y = DataTable.INF_C;

h = adftest(Y);

%%
load Data_GDP.mat
Y = log(Data);

[h, ~, ~, ~, reg] = adftest(Y, 'model', 'TS', 'lags', 0:2);

reg.names;

