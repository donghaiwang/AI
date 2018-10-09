%{
a = 13;
b = 9.4248;
myVar = 55.3;

a = [10 20.5 11 13.7 15.1 7.7];

matlab.io.saveVariablesToScript('test.m', 'a', ...
'SaveMode', 'Update', 'MaximumArraySize', 50, ...
'MaximumNestingLevel', 5, 'MaximumTextWidth', 82)
%}

%% 将三维数据保存成二维数据切片
clear;
level1 = [1 2; 3 4];
level2 = [5 6; 7 8];
my3Dtable(:, :, 1) = level1;
my3Dtable(:, :, 2) = level2;
matlab.io.saveVariablesToScript('sliceData.m', 'MultidimensionalFormat', [1,3]);
clear;

%% 保存满足指定正则表达式的变量
autoLevelVariable = 13;
matlab.io.saveVariablesToScript('autoVariables.m', 'RegExp', 'autoL*');
clear;


%% 将变量保存成7.3版本的Matlab脚本
p = 49;
q = 35.5;
matlab.io.saveVariablesToScript('version73.m', 'p',...
    'MATFileVersion', 'v7.3');
clear;


%% 返回之前保存的Matlab脚本中变量的变量名列表
autoLevelVariable = 13;
[r1, r2] = matlab.io.saveVariablesToScript('autoVariables.m');

