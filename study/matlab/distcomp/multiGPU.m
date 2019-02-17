parpool('local', 2)

%%
spmd
    gpuDevice
end

%%
spmd
    if labindex == 1
        gpuDevice(1);
    end
end

%% close parpool
poolobj = gcp('nocreate');  % get current parallel pool
delete(poolobj);