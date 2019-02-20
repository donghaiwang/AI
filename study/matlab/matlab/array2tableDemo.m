A = [1 4 7; 2 5 8; 3 6 9];
T = array2table(A);

%%
A = [1 12 30.48; 2 24 60.96; 3 36 91.44];
T = array2table(A, ...
    'VariableNames', {'Feet', 'Inches', 'Centimeters'});
T = array2table(A);