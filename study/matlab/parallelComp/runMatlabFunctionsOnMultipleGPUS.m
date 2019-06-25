%% 
N = 1000;
r = gpuArray.linspace(0, 4, N);
X = rand(1, N, 'gpuArray');

numIterations = 1000;

%%
parpool(gpuDeviceCount);
% delete(gcp('nocreate'));

%%
numSimulations = 10000;
X = zeros(numSimulations, N, 'gpuArray');

parfor i = 1 : numSimulations
    X(i, :) = rand(1, N, 'gpuArray');
    for n = 1 : numIterations
        X(i, :) = r .* X(i,:) .* (1-X(i,:));
    end
end

%%
figure;
plot(r, X, '.');
