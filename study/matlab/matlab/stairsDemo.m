X = linspace(0, 4*pi, 40);
Y = sin(X);

figure;
stairs(Y);

%%
X = linspace(0, 4*pi, 50)';
Y = [0.5 * cos(X), 2*cos(X)];
figure;
stairs(Y);

%%
X = linspace(0, 4*pi, 40);
Y = sin(X);

figure;
stairs(X, Y);

%% 
X = linspace(0, 4*pi, 50)';
Y = [0.5 * cos(X), 2*cos(X)];

figure;
stairs(X, Y);