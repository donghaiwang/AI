S.f1 = 1 : 10;
S.f2 = [2; 4; 6];
S.f3 = [];

A = structfun(@mean, S);

%% 
clear S;
S.X = rand(1, 10);
S.Y = rand(1, 10);
S.Z = rand(1, 10);

figure
hold on;
p = structfun(@plot, S);
p(1).Marker = 'o';
p(2).Marker = '+';
p(3).Marker = 's';
hold off;

%% 
clear S;
S.f1 = 1:10;
S.f2 = [2 3; 4 5; 6 7];
S.f3 = rand(4, 4);
A = structfun(@mean, S, 'UniformOutput', false);

%% 
clear S;
S.f1 = 1:10;
S.f2 = [2 3; 4 5; 6 7];
S.f3 = rand(4, 4);
[nrows, ncols] = structfun(@size, S);

%%
S = spdiags([1:4]', 0, 4, 4);
f = spfun(@exp, S);
full(S);
full(exp(S));
%% 
