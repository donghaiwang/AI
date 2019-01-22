clc
clear all
cd TrainingResult

%%
N = 1024;
% 大气模式[1-6]；能见度；波长
% p = [6; 5.5; 543.2];
% p = [6; 23; 550];
p = [30; 120];
photonArray = zeros(1024, 1024);
files = dir('*.net');

tic
for i = 1 : N
    disp(i);
    for j = 1 : N
        fileName = ['net_' num2str(i) '_' num2str(j) '.mat'];
        load (fileName);
        photonNum = sim(net, p);
%         disp(photonNum);
        photonArray(i, j) = round(photonNum);
    end
end
toc

cd ..

save useNN_30_120.dat photonArray -ascii



