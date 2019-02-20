C = {(1),   [2 3 4]; ...
    [5; 9], [6 7 8; 10 11 12]};
A = cell2mat(C);

%%
s1.a = [1 2 3 4];
s1.b = 'Good';
s2.a = [5 6; 7 8];
s2.b = 'Morning';
c = {s1, s2};
d = cell2mat(c);

d(1).a;
d(2).b;
