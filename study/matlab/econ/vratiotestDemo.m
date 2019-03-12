load Data_GlobalIdx1.mat
logSP = log(DataTable.SP);

figure;
plot(diff(logSP));
axis tight

%%
q = [2 4 8 2 4 8];
flag = logical([1 1 1 0 0 0]);
[h, pValue, stat, cValue, ratio] = ...
    vratiotest(logSP, 'period', q, 'IID', flag);
