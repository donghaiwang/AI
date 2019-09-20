function A = binary_numbers(n)

A = zeros(2^n, n);
for i = 1 : 2^n
    value = i - 1;  % current line value
    for j = 1 : n
        posVal = 2^(n-j);
        A(i, j) = fix(value / posVal);
        value = mod(value, posVal);
    end
end
% A = n;
