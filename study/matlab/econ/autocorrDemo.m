rng(1);
Md1 = arima('MA', {-0.5 0.4}, 'Constant', 0, 'Variance', 1);

y = simulate(Md1, 1000);

[acf, lags, bounds] = autocorr(y, 'NumMA', 2);
bounds;

autocorr(y);

%%
Md1 = arima('AR', {0.75, 0.15}, 'SAR', {0.9, -0.5, 0.5}, ...
    'SARLags', [12, 24, 36], 'MA', -0.5, 'Constant', 2, ...
    'Variance', 1);

rng(1);
y = simulate(Md1, 1000);

figure;
autocorr(y);

%%
figure;
autocorr(y, 'NumLags', 40, 'NumSTD', 3);

%%
rng(1);
y = randn(1000, 1);

[normalizedACF, lags] = autocorr(y, 'NumLags', 10);
unnormalizedACF = normalizedACF * var(y, 1);
[lags normalizedACF unnormalizedACF];