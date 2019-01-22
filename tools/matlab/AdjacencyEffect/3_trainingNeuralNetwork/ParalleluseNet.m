clear all;
clc;
cd TrainingResult

%%
N = 128*128;
p = [555; 56; 6; 4];
photonArray = zeros(128, 128);

% nets = struct{128, 128};
% nets(128, 128).name = 'Function Fitting Neural Network';
% for i = 1 : 128
%     for j = 1 : 128
%         fileName = ['net_' num2str(i) '_' num2str(j) '.mat'];
%         nets(i, j) = load(fileName);
%         disp(fileName);
%     end
% end

%%
tic
for i = 1 : 128
    for j = 1 : 128
        fileName = ['net_' num2str(i) '_' num2str(j) '.mat'];
%         nets(i, j) = load(fileName);
        load(fileName);
        
        photonNum = sim(net, p);
        disp(i);
        disp(j);
        disp(photonNum);
        photonArray(i, j) = photonNum;
    end
end
toc

%%
% plot(photonArray);
cd ..
cd UseNNResult
photonArray = round(photonArray);
save photonArray.txt photonArray -ascii
% Elapsed time is 295.117951 seconds.

% title('1976 US Standard;  VIS=23;  wavelength=550nm');
% xlabel('x');
% ylabel('photon number');

%%












%%
% N = 512;
% p = [6; 4; 550];
% photonArray = zeros(512, 1);
% 
% % nets = struct(512, 1);
% nets(512, 1).name = 'net';
% % files = dir('*.net');
% for i = 1 : N
%     fileName = ['net_' num2str(i)];
%     nets(i, 1) = load(fileName);
% end
% 
% %%
% tic
% for i = 1 : N
% %     fileName = ['net_' num2str(i)];
% %     load (fileName);
%     photonNum = sim(nets(i, 1), p);
%     disp(photonNum);
%     photonArray(i, 1) = photonNum;
% end
% toc
% 
% plot(photonArray);
% title('1976 US Standard;  VIS=23;  wavelength=550nm');
% xlabel('x');
% ylabel('photon number');
% 
% %%
% cd ..
