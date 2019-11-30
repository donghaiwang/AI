%% Suppress entries in a vector
x = 1:10;
x(3:5) = [];

%% Reverse a vector
x = 1 : 10;
x = x(end : -1 : 1);

%% 
tic; fft(rand(500)); disp(['it takes ' num2str(toc) 's.']);

%% 
tic; NaN*ones(2000, 2000); toc;
tic; repmat(NaN, 2000, 2000); toc;
% tic; NaN(2000, 2000); toc;

%% column first
x = randn(2,3);
xv = x(:);




