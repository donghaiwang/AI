theta = [0.1 1.1 5.4 3.4 2.3 4.5 3.2 3.4 5.6 2.3 2.1 3.5 0.6 6.1];
polarhistogram(theta, 6);
% histogram(theta)

%%
clear;clc;
theta = atan2(rand(100000, 1) - 0.5, 2*(rand(100000, 1) - 0.5));
polarhistogram(theta, 25);


%%
theta = atan2(rand(100000, 1) - 0.5, 2*(rand(100000, 1) - 0.5));
polarhistogram(theta, 25, 'FaceColor', 'red', 'FaceAlpha', 0.3);

%%
theta = atan2(rand(100000, 1) - 0.5, 2*(rand(100000, 1) - 0.5));
h = polarhistogram(theta, 25);
h.DisplayStyle = 'stairs';



