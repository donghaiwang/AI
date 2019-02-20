format long e
f = flintmax
% f = flintmax('double')
% 1 11 52
dec2bin(f)  % 2^53

f = flintmax('single')
% 1 8 23
dec2bin(f)  % 2^24
class(f)
f1 = f+1
isequal(f, f1)

f2 = f+2
isequal(f, f2)

%%
% 2^24: 23 + 1 (implicit leading bit with value 1)
sig1 = single(16777216);
sig2 = sig1+1;
sig1 == sig2  % 1

