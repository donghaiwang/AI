a = magic(3);
c = num2cell(a);

a = ['four';
     'five';
     'nine'];
 c = num2cell(a);
 
 %%
 A = reshape(1:12, 4, 3);
 A(:, :, 2) = A*10;
 
 C = num2cell(A, 1);
 
 C{1}
 
 C = num2cell(A, 2);
 C{1};
 
 C = num2cell(A, 3);
 C{1};
 
 %%
 A = reshape(1:12, 4, 3);
 A(:, :, 2) = A*10;
 c = num2cell(A, [1 3]);
 c{1}
%  c = num2cell(A, [2 3]);
 