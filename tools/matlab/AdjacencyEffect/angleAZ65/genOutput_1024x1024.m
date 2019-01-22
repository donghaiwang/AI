clear
clc

%% declare variable
% �洢��ʱ����Ĺ��ӷֲ����
psf = zeros(1024, 1024);
% ÿ8*8������ϲ���һ�����񣬴洢ÿ�ζ�����ļ��ĺϲ�
% mergedPSF = zeros(512, 512);




%%
cd PSF
files = dir('PSF*');            % ��¼��������PSF��ͷ���ļ���

outputTable = zeros(468, 1024, 1024);        % �洢���д��������£�ĳ������(i,j)�����յ��Ĺ�����Ŀ��

for i = 1 : length(files)
    fileName = files(i).name;
    content = load(fileName, '-ascii');
    X1 = sprintf('processing %s', fileName);
    disp(X1);
    distribution = zeros(1024, 1024);    
    % ��¼���ӷֲ�
    for j = 1 : 1024 * 1024
        row = content(j, 1)+1;
        col = content(j, 2)+1;
        numPhoton = content(j, 3);
        distribution(row, col) = numPhoton; % ��i�����������µĹ��ӷֲ�
    end
    % ��¼��rowIndex�еĹ���
%     for r = 1 : 1024
    outputTable(i, :, :) = distribution;
%         outputTable(i, :, r) = distribution(128*(rowIndex-1)+r, :);  % 1.�۲�������2.���е��У�3.�ڼ���
%     end
%         outputTable(i, :) = distribution(rowIndex, :);  
end


% ��¼�µ�rowIndex�У����д��������µĹ�������д��Output�ļ���
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
%     for j = 1 : 1024    % outputTable�е�����ÿһ����Ϊһ���ļ�д�룬��ʾ�����ϵ�ĳһ��λ��(x,y)�����д��������µĹ�����Ŀ����Ϊ����������
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








