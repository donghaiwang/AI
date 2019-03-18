S = 100 * exp(0.10 * [1 : 19]');
R = price2ret(S);

P = ret2price(R, 100);
% [S P];

%%
load Data_EquityIdx.mat

figure;
plot(ret2price(price2ret([DataTable.NASDAQ DataTable.NYSE]), 100));
ylabel('Prices');
legend('Nasdaq', 'NYSE', 'Location', 'Best');
axis tight