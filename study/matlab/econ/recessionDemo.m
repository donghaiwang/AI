load Data_CreditDefaults.mat
X0 = Data(:, 1:4);
T0 = size(X0, 1);

dates = datenum([dates, ones(T0, 2)]);

figure;
plot(dates, X0, 'LineWidth', 2);
ax = gca;
ax.XTick = dates(1:2:end);
datetick('x', 'yyyy', 'keepticks');
xlabel('Year');
ylabel('Level');
axis tight;

%
hBands = recessionplot;
set(hBands, 'FaceColor', 'r', 'FaceAlpha', 0.4);