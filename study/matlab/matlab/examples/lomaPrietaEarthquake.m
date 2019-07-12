load quake.mat

whos e n v

Time = (1/200)*seconds(1 : length(e))';
whos Time

%%
varNames = { 'EastWest', 'NorthSouth', 'Vertical' };
quakeData = timetable(Time, e, n, v, 'VariableNames', varNames);
head(quakeData);

plot(quakeData.Time, quakeData.EastWest)
title('East-West Acceleration');

%%
quakeData.Variables = 0.098 * quakeData.Variables;

%%
t1 = seconds(8)*[1;1];
t2 = seconds(15) * [1; 1];
hold on
plot([t1 t2], ylim, 'k', 'LineWidth', 2);
hold off

%% 
tr = timerange(seconds(8), seconds(15));
dataOfInterest = quakeData(tr, :);
head(dataOfInterest);

figure
subplot(3, 1, 1);
plot(dataOfInterest.Time, dataOfInterest.EastWest);
ylabel('East-West');
title('Acceleration');

subplot(3, 1, 2);
plot(dataOfInterest.Time, dataOfInterest.NorthSouth);
ylabel('North-South');

subplot(3, 1, 3);
plot(dataOfInterest.Time, dataOfInterest.Vertical);
ylabel('Vertical');


%%
summary(dataOfInterest);

mn = varfun(@mean, dataOfInterest, 'OutputFormat', 'table');

%%
edot = (1/200) * cumsum(dataOfInterest.EastWest);
edot = edot - mean(edot);

vel = varfun(@velFun, dataOfInterest);
head(vel);

%%
pos = varfun(@velFun, vel);
head(pos);

pos.Properties.VariableNames = varNames;

figure;
subplot(2, 1, 1);
plot(vel.Time, vel.Variables)
legend(quakeData.Properties.VariableNames, 'Location', 'northwest');
title('Velocity');

subplot(2, 1, 2);
plot(vel.Time, pos.Variables);
legend(quakeData.Properties.VariableNames, 'Location', 'northwest');
title('Position');

%%
figure;
plot(pos.NorthSouth, pos.Vertical);
xlabel('North-South');
xlabel('Vertical');

nt = ceil((max(pos.Time) - min(pos.Time)) / 6);
idx = find(fix(pos.Time/nt) == (pos.Time/nt))';
text(pos.NorthSouth(idx), pos.Vertical(idx), char(pos.Time(idx)))

%%
figure
[S, Ax] = plotmatrix(pos.Variables);

for ii = 1 : length(varNames)
    xlabel(Ax(end, ii), varNames{ii});
    ylabel(Ax(ii, 1), varNames{ii});
end

%% 
step = 10;
figure
plot3(pos.NorthSouth, pos.EastWest, pos.Vertical, 'r');
hold on;
plot3(pos.NorthSouth(1:step:end), pos.EastWest(1:step:end), pos.Vertical(1:step:end), '.')
hold off;
box on;
axis tight
xlabel('North-South');
ylabel('East-West');
zlabel('Vertical');
title('Position');
