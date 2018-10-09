%{
a = 13;
b = 9.4248;
myVar = 55.3;

a = [10 20.5 11 13.7 15.1 7.7];

matlab.io.saveVariablesToScript('test.m', 'a', ...
'SaveMode', 'Update', 'MaximumArraySize', 50, ...
'MaximumNestingLevel', 5, 'MaximumTextWidth', 82)
%}

%% ����ά���ݱ���ɶ�ά������Ƭ
clear;
level1 = [1 2; 3 4];
level2 = [5 6; 7 8];
my3Dtable(:, :, 1) = level1;
my3Dtable(:, :, 2) = level2;
matlab.io.saveVariablesToScript('sliceData.m', 'MultidimensionalFormat', [1,3]);
clear;

%% ��������ָ��������ʽ�ı���
autoLevelVariable = 13;
matlab.io.saveVariablesToScript('autoVariables.m', 'RegExp', 'autoL*');
clear;


%% �����������7.3�汾��Matlab�ű�
p = 49;
q = 35.5;
matlab.io.saveVariablesToScript('version73.m', 'p',...
    'MATFileVersion', 'v7.3');
clear;


%% ����֮ǰ�����Matlab�ű��б����ı������б�
autoLevelVariable = 13;
[r1, r2] = matlab.io.saveVariablesToScript('autoVariables.m');

