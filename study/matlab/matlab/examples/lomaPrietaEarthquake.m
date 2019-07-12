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
