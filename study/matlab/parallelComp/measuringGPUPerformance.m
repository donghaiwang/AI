gpu = gpuDevice();
fprintf('Using a %s GPU.\n', gpu.Name);
sizeOfDouble = 8;
sizes = power(2, 14:28);

%%
sendTimes = inf(size(sizes));
gatherTimes = inf(size(sizes));

for ii = 1 : numel(sizes)
    numElements = sizes(ii) / sizeOfDouble;
    hostData = randi([0 9], numElements, 1);
    gpuData = randi([0, 9], numElements, 1, 'gpuArray');
    % Time sending to GPU
    sendFcn = @() gpuArray(hostData);
    sendTimes(ii) = gputimeit(sendFcn);
    % Time gathering back from GPU
    gatherFcn = @() gather(gpuData);
    gatherTimes(ii) = gputimeit(gatherFcn);
end
sendBandWidth = (sizes ./ sendTimes) / 1e9;
[maxSendBandwidth, maxSendIdx] = max(sendBandWidth);
fprintf('Achieved peak send speed of %g GB/s\n', maxSendBandwidth);
gatherBandWidth = (sizes ./ gatherTimes) / 1e9;
[maxGatherBandwidth, maxGatherIdx] = max(gatherBandWidth);
fprintf('Achieved peak gather speed of %g GB/s\n', max(gatherBandWidth));

%%
hold off
semilogx(sizes, sendBandWidth, 'b.-', sizes, gatherBandWidth, 'r.-');
hold on
semilogx(sizes(maxSendIdx), maxSendBandwidth, 'bo-', 'MarkerSize', 10);
semilogx(sizes(maxGatherIdx), maxGatherBandwidth, 'ro-', 'MarkerSize', 10);
grid on
title('Data Transfer Bandwidth')
xlabel('Array size (bytes)')
ylabel('Transfer speed (GB/s)')
legend('Send to GPU', 'Gather from GPU', 'Location', 'northeast')

%%
memoryTimesGPU = inf(size(sizes));
for ii = 1 : numel(sizes)
    numElements = sizes(ii) / sizeOfDouble;
    gpuData = randi([0, 9], numElements, 1, 'gpuArray');
    plusFcn = @() plus(gpuData, 1.0);
    memoryTimesGPU(ii) = gputimeit(plusFcn);
end
memoryBandwidthGPU = 2*(sizes ./ memoryTimesGPU) / 1e9;
[maxBWGPU, maxBWIdGPU] = max(memoryBandwidthGPU);
fprintf('Achieved peak read+write speed on the GPU: %g GB/s\n', maxBWGPU)


memoryTimeHost = inf(size(sizes));
for ii = 1 : numel(sizes)
    numElements = sizes(ii) / sizeOfDouble;
    hostData = randi([0 9], numElements, 1);
    plusFcn = @() plus(hostData, 1.0);
    memoryTimeHost(ii) = timeit(plusFcn);
end
memoryBandwidthHost = 2*(sizes ./ memoryTimeHost) / 1e9;
[maxBWHost, maxBWIdxHost] = max(memoryBandwidthHost);
fprintf('Achieved peak read-write speed on the host: %g GB/s\n', maxBWHost)


% Plot CPU and GPU 
hold off
semilogx(sizes, memoryBandwidthGPU, 'b.-', ...
    sizes, memoryBandwidthHost, 'r.-');
hold on

%% Testing computationally intensive operations
% matrix-matrix multiply
% N multiply, N-1 add for each output matrix element
% FLOP(N) = 2N^3 - N^2 = (N + (N-1)) * N^2
sizes = power(2, 12:2:24);
N = sqrt(sizes);
mmTimeHost = inf(size(sizes));
mmTimeGPU = inf(size(sizes));
for ii = 1 : numel(sizes)
    % First do it on the host
    A = rand( N(ii), N(ii) );
    B = rand( N(ii), N(ii) );
    mmTimeHost(ii) = timeit( @() A*B );
    % Now on the GPU
    A = gpuArray(A);
    B = gpuArray(B);
    mmTimeGPU(ii) = gputimeit( @() A*B );
end
%%
mmGFlopHost = (2*N.^3 - N.^2) ./ mmTimeHost / 1e9;
[maxGFlopsHost, maxGFlopHostIdx] = max(mmGFlopHost);
mmGFlopGPU = (2*N.^3 - N.^2) ./ mmTimeGPU / 1e9;
[maxGFlopGPU, maxGFlopGPUIdx] = max(mmGFlopGPU);
fprintf(['Achieved peak calculation rates of ', ...
    '%1.1f GFLOPS (host), %1.1f GFLOPS (GPU)\n'], ...
    maxGFlopsHost, maxGFlopGPU);

hold off
semilogx(sizes, mmGFlopGPU, 'b.-', sizes, mmGFlopHost, 'r.-');
hold on
semilogx(sizes(maxGFlopGPUIdx), maxGFlopGPU, 'bo-', 'MarkerSize', 10);
semilogx(sizes(maxGFlopHostIdx), maxGFlopsHost, 'ro-', 'MarkerSize', 10);
grid on
title('Double precision matrix-matrix multiply')
xlabel('Matrix size (numel)')
ylabel('Calculation Rate (GFLOPS)');
legend('GPU', 'Host', 'Location', 'northwest')


