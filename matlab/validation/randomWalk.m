%% 随机行走验证
% L A B C D E R 
transformMatrix = [
    0,  0, 0, 0, 0, 0, 0; ...                   % L
    0.5,    0,  0.5,    0,  0, 0, 0; ...        % A
    0,      0.5,    0, 0.5, 0, 0, 0; ...       % B
    0,  0,  0.5,    0,  0.5,    0,  0; ...      % C
    0,  0,  0,  0.5,    0,  0.5,    0; ...      % D
    0,  0,  0,  0,  0.5,    0,     0.5; ...    % E
    0,  0,  0,  0,  0,  0,  0; ...         % F
    ];
sum = 0;
for i = 5 : 111111
    if mod(i, 2) == 0
        continue;
    end
    sum = sum + transformMatrix ^ i;
end
disp(sum);
% destinationPos = transformMatrix ^ 11111