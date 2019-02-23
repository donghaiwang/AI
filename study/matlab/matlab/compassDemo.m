rng(0, 'twister');
M = randn(20, 20);
Z = eig(M);

figure;
compass(Z);

