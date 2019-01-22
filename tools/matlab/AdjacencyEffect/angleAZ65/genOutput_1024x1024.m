clear
clc

%% declare variable
% 存储临时读入的光子分布表格
psf = zeros(1024, 1024);
% 每8*8个网格合并成一个网格，存储每次读入的文件的合并
% mergedPSF = zeros(512, 512);




%%
cd PSF
files = dir('PSF*');            % 记录下所有以PSF开头的文件名

outputTable = zeros(468, 1024, 1024);        % 存储所有大气条件下，某个网格(i,j)所接收到的光子数目，

for i = 1 : length(files)
    fileName = files(i).name;
    content = load(fileName, '-ascii');
    X1 = sprintf('processing %s', fileName);
    disp(X1);
    distribution = zeros(1024, 1024);    
    % 记录光子分布
    for j = 1 : 1024 * 1024
        row = content(j, 1)+1;
        col = content(j, 2)+1;
        numPhoton = content(j, 3);
        distribution(row, col) = numPhoton; % 第i个大气条件下的光子分布
    end
    % 记录第rowIndex列的光子
%     for r = 1 : 1024
    outputTable(i, :, :) = distribution;
%         outputTable(i, :, r) = distribution(128*(rowIndex-1)+r, :);  % 1.观测条件；2.所有的列；3.第几行
%     end
%         outputTable(i, :) = distribution(rowIndex, :);  
end


% 记录下第rowIndex行，所有大气条件下的光子数，写入Output文件夹
cd ..
cd Output_1024x1024

for i = 1 : 1024
    for j = 1 : 1024
        photonAtXYArr = outputTable(:, i, j);
        photonAtXYFileName = [num2str(i) '_' num2str(j) '.txt'];
        save(photonAtXYFileName, 'photonAtXYArr', '-ascii');
    end
end

% for r = 1 : 468
%     for j = 1 : 1024    % outputTable中的数据每一列作为一个文件写入，表示地面上的某一个位置(x,y)在所有大气条件下的光子数目，作为神经网络的输出
%         photonAtXYArr = outputTable(:, j, 128*(rowIndex-1)+r);
%         photonAtXYFileName = [num2str(128*(rowIndex-1)+r) '_' num2str(j) '.txt'];
%         save(photonAtXYFileName, 'photonAtXYArr', '-ascii');
%     end
% end


cd ..


%     cd ..
% cd PSF
% 
% cd ..



%%
% outputTable = zeros(256, 512);
% row = 0;
% 
% %% 
% cd PSF12
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF14
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF16
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF19
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF22
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF24
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF26
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF29
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF32
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF34
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF36
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF39
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF42
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF44
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF46
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF49
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF52
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF54
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF56
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF59
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF62
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF64
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF66
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% %% 
% cd PSF69
% load 0500.dat
% load 0510.dat
% load 0520.dat
% load 0530.dat
% load 0540.dat
% load 0550.dat
% load 0560.dat
% load 0570.dat
% load 0580.dat
% load 0590.dat
% load 0600.dat
% 
% row = row+1;
% outputTable(row, :) = X0500;
% row = row+1;
% outputTable(row, :) = X0510;
% row = row+1;
% outputTable(row, :) = X0520;
% row = row+1;
% outputTable(row, :) = X0530;
% row = row+1;
% outputTable(row, :) = X0540;
% row = row+1;
% outputTable(row, :) = X0550;
% row = row+1;
% outputTable(row, :) = X0560;
% row = row+1;
% outputTable(row, :) = X0570;
% row = row+1;
% outputTable(row, :) = X0580;
% row = row+1;
% outputTable(row, :) = X0590;
% row = row+1;
% outputTable(row, :) = X0600;
% cd ..
% 
% 
% %%
% mkdir Output
% cd Output
% 
% for i = 1 : 512
%     outputCol = outputTable(:,i);
%     path = sprintf('%d.txt', i);
%     save(path, 'outputCol', '-ascii');
% end
% 
% %%
% cd ..








