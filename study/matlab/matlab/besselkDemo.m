z = (0 : 0.2 : 1)';
format long
besselk(1, z);

%%
X = 0 : 0.01 : 5;

K = zeros(5, 501);
for i = 0 : 4
    K(i+1, :) = besselk(i, X);
end
plot(X, K, 'LineWidth', 1.5);
axis([0 5 0 8])
% grid on
% legend('K_0','K_1','K_2','K_3','K_4','Location','Best')
% title('Modified Bessel Functions of the Second Kind for v = 0,1,2,3,4')
% xlabel('X')
% ylabel('K_v(X)')