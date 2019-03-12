logL1 = -681.4724;
logL2 = -632.3158;
logL3 = -663.4615;
logL4 = -605.9439;

numParam1 = 12;
numParam2 = 27;
numParam3 = 18;
numParam4 = 45;

%%
aic = aicbic([logL1, logL2, logL3, logL4], ...
    [numParam1, numParam2, numParam3, numParam4]);


%%
rng(1);
T = 100;
DGP = arima('Constant', -4, 'AR', [0.2, 0.5], ...
    'Variance', 2);