z = (0 : 0.2 : 1)';
format long
besseli(1, z);


%%
X = 0 : 0.01 : 5;
I = zeros(5, 501);
for i = 0 : 4
    I(i+1, :) = besseli(i, X);
end

plot(X, I, 'LineWidth', 1.5);