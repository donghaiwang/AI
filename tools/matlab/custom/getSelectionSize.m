%% add comment for a script by press "Alt + 2"
% Home -> Favorites -> New Favorite -> 
% Label: size
% Code:  getSelectionSize
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.

%% 
% test code:
% container = zeros(2, 3, 'single', 'gpuArray');
% disp(container);

% ws: 'base' or caller
evalin('caller', 'addpath(pwd)');  % TODO: solve 'underfine function' defined in m script

activeEditor = matlab.desktop.editor.getActive;

selectedText = activeEditor.SelectedText;

clc;
eval(['size(', selectedText, ')']);

