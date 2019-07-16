X = {5:5:100, 10:10:100, 20:20:100};
Y = {rand(1, 20), rand(1, 10), rand(1, 5)};

figure
hold on
p = cellfun(@plot, X, Y);
p(1).Marker = 'o';
p(2).Marker = '+';
p(3).Marker = 's';
hold off

%% 

C = {1:10, [2; 4; 6], []};
[nrows, ncols] = cellfun(@size, C);


%% 
C = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
A = cellfun(@(x) x(1:3), C, 'UniformOutput', false);

str = ["Saturday", "Sunday"];
B = cellfun(@(x) x(1:3), str, 'UniformOutput', false);

%% 

