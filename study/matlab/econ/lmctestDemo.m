load Data_SchwertMacro.mat

UN = DataTableMth.UN;
t1 = find(datesMth == datenum([1948 01 01]));
t2 = find(datesMth == datenum([1985 12 01]));
dUN = diff(UN(t1 : t2 ));

%%
[h1, ~, stat1, cValue] = lmctest(dUN, 'lags', 1, 'test', 'var1');

[h2, ~, stat2, cValue] = lmctest(dUN, 'lags', 1, 'test', 'var2');

