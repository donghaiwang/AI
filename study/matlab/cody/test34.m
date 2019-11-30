%%
n = 2;
A = binary_numbers(n);
assert(isequal(class(A), 'double'))

%%
n = 3;
A = binary_numbers(n);
assert(all(A(:) == 0 | A(:) == 1))

%%
n = 5;
A = binary_numbers(n);
assert(isequal(size(A),[32 5]))

%%
n = 10;
A = binary_numbers(n);
assert(isequal(size(unique(A,'rows'),1), 1024))

 	
%%
n = 1;
A = binary_numbers(n);
assert(isequal(A,[0;1]) || isequal(A,[1;0]))
