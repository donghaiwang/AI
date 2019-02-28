%% cd temporary directory using 'cdtmp' in Command Window
function cdtmp()
    if ispc
        tmp = 'D:/tmp';
    else
        tmp = '/tmp';
    end
    
    eval(['cd ' tmp]);
end