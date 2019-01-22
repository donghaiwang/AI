clc
clear all

%%
N = 1024;
% 大气模式[1-6]；能见度；波长
% p = [6; 5.5; 543.2];
% p = [6; 23; 550];
% 13*36=468
% p = [30; 120];
index = 1;
p = zeros(2, 468);
for zenith = 0 : 5 : 60
    for azimuth = 0 : 10 : 350
        p(1, index) = zenith;
        p(2, index) = azimuth;
        index = index + 1;
    end
end


for pIndex = 1 : 468
    cd TrainingResult

    photonArray = zeros(1024, 1024);
    files = dir('*.net');

    tic
    for i = 1 : N
        disp(pIndex);
        disp(i);
        for j = 1 : N
            fileName = ['net_' num2str(i) '_' num2str(j) '.mat'];
            load (fileName);
            photonNum = sim(net, p(:, pIndex));
            photonArray(i, j) = round(photonNum);
        end
    end
    toc

    cd ..
    cd useNetExistAll

    saveFileName = [num2str(p(1, pIndex)) '_' num2str(p(2, pIndex)) '_' '.dat'];
    save saveFileName photonArray -ascii
    cd ..
end

