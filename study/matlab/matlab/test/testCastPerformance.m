
accIdx = 1;
for scale = 1 : 1000 : 5e4
    disp(scale);
    
    acc(accIdx, 1) = scale;
    a = zeros(scale);
    tic
    aSingle = cast(a, 'single');
    castTime = toc;
    acc(accIdx, 2) = castTime;
    
    tic
    bSingle = single(a);
    singleTime = toc;
    acc(accIdx, 3) = singleTime;
    accIdx = accIdx+1;
end
hold on
plot(acc(:,2));
plot(acc(:,3));
hold off

%%
% num = 5e4;
% a = zeros(num);
% 
% tic
% aSingle = cast(a, 'single');
% toc
% 
% tic
% bSingle = single(a);
% toc

