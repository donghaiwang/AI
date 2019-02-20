clc; clear;

S.Name = {'CLARK';'BROWN';'MARTIN'};
S.Gender = {'M';'F';'M'};
S.SystolicBP = [124;122;130];
S.DiastolicBP = [93;80;92];
S;

T = struct2table(S);
T.Properties.RowNames = T.Name;
T.Name = [];

%%
S(1,1).Name = 'CLARK';
S(1,1).Gender = 'M';
S(1,1).SystolicBP = 124;
S(1,1).DiastolicBP = 93;

S(2,1).Name = 'BROWN';
S(2,1).Gender = 'F';
S(2,1).SystolicBP = 122;
S(2,1).DiastolicBP = 80;

S(3,1).Name = 'MARTIN';
S(3,1).Gender = 'M';
S(3,1).SystolicBP = 130;
S(3,1).DiastolicBP = 92;
S;
T = struct2table(S);


%%
clear
S.name = 'John Doe';
S.billing = 127.00;
S.test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];
S;
T = struct2table(S, 'AsArray', true)