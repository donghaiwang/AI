gridSize = 25;
nu = linspace(100, 150, gridSize);
mu = linspace(0.5, 2, gridSize);
[N, M] = meshgrid(nu, mu);

%%
Z = nan(size(N));
c = surf(N, M, Z);
xlabel('mu Values', 'Interpreter', 'Tex');
ylabel('\nu Values', 'Interpreter', 'Tex');
zlabel('Mean Period of y')
view(137, 30)
axis([100 150 0.3 2 0 500]);

%%
D = parallel.pool.DataQueue;
D.afterEach(@(x) updateSurface(c, x));

%%
parfor ii = 1 : numel(N)
    [t, y] = solveVdp(N(ii), M(ii));
    l = islocalmax(y(:, 2));
    send(D, [ii mean(diff(t(l)))]);
end

%%
function [t, y] = solveVdp(mu, nu)
    f = @(~, y) [nu*y(2); mu*(1-y(1)^2)*y(2)-y(1)];
    [t, y] = ode23s(f, [0, 20*mu], [2; 0]);
end

function updateSurface(s, d)
    s.ZData(d(1)) = d(2);
    drawnow('limitrate');
end