A = uint32(hex2dec('12345678'));
B = dec2hex( swapbytes(A) );

%%
X = uint16([0 1 128 65535]);
dec2hex(X);
Y = swapbytes(X);
dec2hex(Y);

format hex;
% X, Y

%%
format hex
A = uint16(magic(3) * 150);
A(:, :, 2) = A * 40;