%% the application of vectorization
simLen = 100000;
y = zeros(1, simLen);

tic;
i = 0;
for t = 0 : .01 : simLen
    i = i + 1;
    y(i) = sin(t);
end
toc

tic
t = 0 : .01 : simLen;
y = sin(t);
toc

%% specify task
simLength = 100000;
tic
x = 1 : simLength;
ylength = (length(x) - mod(length(x), 5)) / 5;
y(1 : ylength) = 0;
for n = 5 : 5 : length(x)
    y(n/5) = sum(x(1 : n));
end
toc

tic
x = 1 : simLength;
xsum = cumsum(x);
y = xsum(5 : 5 : length(x));
toc

%% Array Operations
% for n = 1 : 10000
%     V(n) = 1 / 12 * pi * ( D(n)^2) * H(n);
% end

A = [97 89 84; 95 82 92; 64 80 99;76 77 67;...
 88 59 74; 78 66 87; 55 93 85];
mA = mean(A);
B = zeros(size(A));
for n = 1 : size(A, 2)
    B(:, n) = A(:, n) - mA(n);
end

devA = A - mean(A);

x = (-2 : 0.2 : 2)';
y = -1.5 : 0.2 : 1.5;
F = x .* exp( -x.^2 - y.^2 );

%% Logical Array Operation
D = [-0.2 1.0 1.5 3.0 -1.0 4.2 3.14];
% D >= 0
if any(D < 0)
    warning('Not all values of diameter are positive');
end

x = [2 -1 0 3 nan 2 nan 11 4 inf];
xvalid = x(~isnan(x));
% inf == inf
% nan == nan

%% Matrix Operation
A = ones(5, 5) * 10;
v = 1 : 5;
v = repmat(v, 3, 1);

A = repmat(1:3, 5, 2);
B = repmat([1 2; 3 4], 2, 2);

%% Sort
x = [2 1 2 2 3 1 3 2 1 3];
x = repmat(x, 1, 1000000);

tic
x = sort(x);
difference = diff([x, nan]);
y = x(difference ~= 0);
toc

tic
y = unique(x);
toc

%%
x = [2 1 2 2 3 1 3 2 1 3];
x = sort(x);
difference = diff([x, max(x)+1]);
y = x(find(difference));
count = diff(find([1, difference]));

count_nans = sum(isnan(x(:)));
count_infs = sum(isinf(x(:)));

