x = -10 : 0.01 : 1;
ai = airy(x);

bi = airy(2, x);

figure
plot(x, ai, '-b', x, bi, '-r')
axis([-10 1 -0.6 1.4]);
xlabel('x');
legend('Ai(x)', 'Bi(x)', 'Location', 'NorthWest');

%%
clear; clc;
x = -4 : 0.1 : 4;
z = x + 1i;

w = airy(z);

figure;
plot(x, real(w));
axis([-4 4 -1.5 1])
xlabel('real(z)');


%%
x = -10 : 0.1 : 1;
scaledAi = airy(0, x, 1);
noscaleAi = airy(0, x, 0);

rscaled = real(scaledAi);
rnoscale = real(noscaleAi);
figure
plot(x, rscaled, '-b', x, rnoscale, '-r')
axis([-10 1 -0.60 0.60]);
xlabel('x');
legend('scaled', 'not scaled', 'Location', 'SouthEast');