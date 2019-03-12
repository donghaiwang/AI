Md1 = arima(2, 1, 2);

%%
Md1 = arima('Constant', 0.05, 'AR', {0.6, 0.2, -0.1}, ...
    'Variance', 0.01);
Md1.Constant = NaN;
Md1.AR = {NaN NaN NaN};
Md1.Variance = NaN;

tdist = struct('Name', 't', 'DoF', 10);
Md1.Distribution = tdist;

%%
Md1 = arima('Constant', 0, 'MALags', [1, 2 12]);

%%
Md1 = arima('Constant', 0, 'D', 1, 'Seasonality', 12, ...
    'MALags', 1, 'SMALags', 12);

%%
Md1 = arima('AR', 0.2, 'D', 1, 'MA', 0.3, 'Beta', 0.5);


%%
Md1 = arima('AR', 0.2, 'D', 1, 'MA', 0.3, 'Beta', 0.5);

%%
Md1 = arima(1, 0, 1);
Md1.Variance = garch(1, 1);