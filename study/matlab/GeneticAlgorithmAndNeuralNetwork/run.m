%% 
clear;clc;
populationSize = 60;
crossRatio = 0.3;
mutationRatio = 0.2;

%% main function
global net
net= constructNeuralNetwork();
options = optimoptions(@ga, 'PopulationSize', populationSize, 'CrossoverFcn', ...
    {@crossoverintermediate, crossRatio}, 'MutationFcn', {@mutationuniform, mutationRatio}, ...
    'UseParallel', false);
optimalSolution = ga(@neuralNetworkFunc, 3, [],[],[],[],[],[], @myConstraints, options);
disp(optimalSolution);
minValue = net(optimalSolution');
disp(minValue);

%% GA function
function f= neuralNetworkFunc(x)
    global net;
    f = net(x');
end

function [c, ceq] = myConstraints(x)
    c = x(1)^2 + x(2)^2 + x(3)^2 - 10;
    ceq = [];
end

%% Generate function output randomly
function net = constructNeuralNetwork()
    if exist('net.mat', 'file')
        net = load('net.mat');
        net = net.net;
        return;
    end
    MAX_X_SAMPLE = 2000;
    MAX_RANDOM_SAMPLE = 2000;
    nnInput = zeros(3, MAX_X_SAMPLE);
    nnOutput = zeros(1, MAX_X_SAMPLE);
    R = sqrt(10);       % the radius of sphere
    for i = 1 : MAX_X_SAMPLE
        x1 = random('Uniform', -R, R);
        x2_range = sqrt(10 - x1^2);     % the range of x_2 according  to x_1
        x2 = random('Uniform', -x2_range, x2_range);
        x3_range = sqrt(10 - x1^2 - x2^2);
        x3 = random('Uniform', -x3_range, x3_range);
        nnInput(1, i) = x1; nnInput(2, i) = x2; nnInput(3, i) = x3;
        sum = 0;
        for j = 1 : MAX_RANDOM_SAMPLE
            epsilon1 = random('Uniform', 1, 2);
            epsilon2 = random('Normal', 3, 1);
            epsilon3 = random('Exponential', 4);       % exprnd(4)
            sum = sum + sqrt((x1-epsilon1)^2 + (x2-epsilon2)^2 + (x3-epsilon3)^2);
        end
        nnOutput(i) = sum / MAX_RANDOM_SAMPLE;
    end
    hiddenNum = 5;
    net = fitnet(hiddenNum);       % construct neural network(threee input unit, five hidden unit, one output unit)
    net = train(net, nnInput, nnOutput);        % train the  neural network
end