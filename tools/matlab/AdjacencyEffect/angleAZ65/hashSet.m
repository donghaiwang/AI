clc;
clear all;
%%
cd TrainingResult

files = dir('net*');
index = 1;
row = 1; col = 1;
count = zeros(1024, 1);

for i = 1 : length(files)
    disp(i);
    
    preFileName = ['net_' num2str(row) '_' num2str(col) '.mat'];
    
    disp(preFileName);
    disp(files(index).name);
    
    S = regexp(files(index).name, '\.', 'split');
    S1 = char(S(1));
    S2 = regexp(S1, '_', 'split');
    rowTmp = char(S2(2));
    colTmp = char(S2(3));
    rowNum = str2num(rowTmp);
    colNum = str2num(colTmp);
    count(rowNum, 1) = count(rowNum, 1)+1;
    
%     disp(S(1));
%     disp(S(2));
    
    index = index + 1;
    col = col+1;
    if col > 1024
        row = row+1;
        col = 1;
    end
end

% trainingResultSet = java.util.HashSet();
% add(trainingResultSet, files(1).name);

% for sample = 1 : 264
%     cd TrainingResult
%     files = dir('*.net');
%     photonArray = zeros(512, 1);
%     tmpPattern = p(:, sample);
%     for i = 1 : N
%         fileName = ['net_' num2str(i)];
%         load (fileName);
%         photonNum = sim(net, tmpPattern);
%         photonArray(i, 1) = round(photonNum);
%     end
%     cd ..
%     cd All264Result
% %     path = sprintf('useNN_%d_%d_%d.dat', tmpPattern(1,1), tmpPattern(2, 1), tmpPattern(3, 1));
%     path = sprintf('useNN_%d.dat', sample);
%     save(path, 'photonArray', '-ascii');
%     cd ..
% end


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

