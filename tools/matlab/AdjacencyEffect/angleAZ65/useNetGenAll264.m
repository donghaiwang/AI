clc
clear all

%%
N = 512;
% 大气模式[1-6]；能见度；波长
% p = [6; 5.5; 543.2];
% p = [6; 23; 550];
% p = zeros(3, 264);
cd Input
load ('input.txt');
p = input';
cd ..

for sample = 1 : 264
    cd TrainingResult
    files = dir('*.net');
    photonArray = zeros(512, 1);
    tmpPattern = p(:, sample);
    for i = 1 : N
        fileName = ['net_' num2str(i)];
        load (fileName);
        photonNum = sim(net, tmpPattern);
        photonArray(i, 1) = round(photonNum);
    end
    cd ..
    cd All264Result
%     path = sprintf('useNN_%d_%d_%d.dat', tmpPattern(1,1), tmpPattern(2, 1), tmpPattern(3, 1));
    path = sprintf('useNN_%d.dat', sample);
    save(path, 'photonArray', '-ascii');
    cd ..
end


% tic
% for i = 1 : N
%     fileName = ['net_' num2str(i)];
%     load (fileName);
%     photonNum = sim(net, p);
%     disp(photonNum);
%     photonArray(i, 1) = photonNum;
% end
% toc
% 
% plot(photonArray);
% % title('1976 US Standard;  VIS=23;  wavelength=550nm');
% % xlabel('x');
% % ylabel('photon number');
% 
% %%
% cd ..
% 
% cd UseNNResult
% 
% save useNN_6_23_550.dat photonArray -ascii
% 
% cd ..

