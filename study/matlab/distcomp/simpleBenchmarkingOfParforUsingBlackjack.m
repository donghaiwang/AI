
srcPath = fullfile(matlabroot, 'examples', 'distcomp', 'main');
% copyfile(fullfile(srcPath, 'pctdemo_aux_parforbench.m'), pwd);
addpath(srcPath);

dbtype pctdemo_aux_parforbench

%% Check the Status of the Parallel Pool
% We will use the parallel pool to allow the body of the |parfor| loop to
% run in parallel, so we start by checking whether the pool is open. We
% will then run the benchmark using anywhere between 2 and |poolSize|
% workers from this pool.
p = gcp;
if isempty(p)
    error('error');
end
poolSize = p.NumWorkers;

%% Run the Benchmark: Weak Scaling
% We time the execution of our benchmark calculations using 2 to |poolSize|
% workers. We use weak scaling, that is, we increase the problem size with
% the number of workers.
numHands = 2000;
numPlayers = 6;
fprintf('Simulating each player playing %d hands.\n', numHands);
t1 = zeros(1, poolSize);
for n = 2 : poolSize
    tic;
        pctdemo_aux_parforbench(numHands, n*numPlayers, n);
    t1(n) = toc;
    fprintf('%d workers simulated %d players in %3.2f seconds.\n', ...
        n, n*numPlayers, t1(n));
end

%% Plot the Speedup
% We compare the speedup using |parfor| with different numbers of workers
% to the perfectly linear speedup curve. The speedup achieved by using
% |parfor| depends on the problem size as well as the underlying hardware
% and networking infrastructure.
speedup = (1:poolSize) .* t1(1) ./ t1;
fig = pctdemo_setup_blackjack(1.);
fig = pctdemo_setup_blackjack(1.0);
ax = axes('parent', fig);
x = plot(ax, 1:poolSize, 1:poolSize, '--', ...
    1:poolSize, speedup, 's', 'MarkerFaceColor', 'b');
t = ax.XTick;
t(t ~= round(t)) = []; % Remove all non-integer x-axis ticks.
ax.XTick = t;
legend(x, 'Linear Speedup', 'Measured Speedup', 'Location', 'NorthWest');
xlabel(ax, 'Number of MATLAB workers participating in computations');
ylabel(ax, 'Speedup');

