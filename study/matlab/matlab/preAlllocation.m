tic
x = 0;
for k = 2 : 1e6
    x(k) = x(k-1) + 5;
end
toc

tic
x = zeros(1, 1e6);
for k = 2 : 1e6
    x(k) = x(k-1) + 5;
end
toc

A = int8(zeros(100));
A = zeros(100, 'int8');
