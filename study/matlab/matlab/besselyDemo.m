z = (0 : 0.2 : 1)';
bessely(1,  z);


%%
X = 0 : 0.1 : 20;
Y = zeros(5, 201);
for i = 0 : 4
    Y(i+1, :) = bessely(i, X);
end
plot(X, Y, 'LineWidth', 1.5);
axis([-0.1 20.2 -2 0.6]);

