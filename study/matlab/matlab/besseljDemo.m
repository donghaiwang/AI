Z = (0 : 0.2 : 1)';

besselj(1, z);

%%
X = 0 : 0.1 : 20;
J = zeros(5, 201);
for i = 0 : 4
    J(i+1, :) = besselj(i, X);
end

plot(X, J, 'LineWidth', 1.5);