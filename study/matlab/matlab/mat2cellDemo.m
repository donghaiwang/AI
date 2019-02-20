X = reshape(1:20, 5, 4)';
C = mat2cell(X, [2 2], [3, 2]);
celldisp(C);

%%
C = mat2cell(X, [1 3]);
celldisp(C);