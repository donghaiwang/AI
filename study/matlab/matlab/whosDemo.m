% clear;clc;
% whos f*;

whos -regexp o$

%%
saveFileName = fullfile(tempdir, 'myFile.mat');
whos saveFileName

%%
S = whos('-file', saveFileName);
for k = 1 : length(S)
    disp(['  ' S(k).name ...
          '  ' mat2str(S(k).size) ...
          '  ' S(k).class]);
end


