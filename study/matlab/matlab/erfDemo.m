erf(0.76);

V = [0.5 0, 1 0.72];
erf(V);

M = [0.29 -0.11; 3.1    -2.9];
erf(M);

%%
x = -3 : 0.1 : 3;
y = (1/2) * (1+erf(x/sqrt(2)));
plot(x,y);
grid on;


%%
clear;clc;
x = -4 : 0.01 : 6;
t = [0.1 5 100];
a = 5;
k = 2;
b = 1;
figure(1)
hold on;
for i = 1 : 3
    u(i, :) = (a/2) * (erf((x-b)/sqrt(4*k*t(i))));
    plot(x, u(i, :));
end