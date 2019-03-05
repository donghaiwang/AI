function show_attributes
persistent p;
global g;
p = 1;
g = 2;
s = sparse(eye(5));
c = [4+5i 9-3i 7+6i];
whos
end