clear; clc;

n = myAdd(2, 3);
fcnStatus;

% mydialog;
updateAge(37);

%%
function mydialog
    prompt = {'Enter name:', 'Enter birth year:'};
    answer = inputdlg(prompt);
    
    n = answer{1};
    birthyear = str2double(answer{2});
    a = 2050 - birthyear;
    
    assignin('base', 'name', n);
    assignin('base', 'age2050', a);
end

%%
function updateAge(a)
    validateattributes(a, {'numeric'}, {'scalar'});
    fprintf('\tYour age: %d\n', a);
	localfcn
    fprintf('\tYour updated age: %d\n', a);
end

function localfcn
    assignin('caller', 'a', 42);
end