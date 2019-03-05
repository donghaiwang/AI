
parpool('myMJS')
poolobj = gcp('nocreate');
if isempty(poolobj)
    poolSize = 0;
else
    poolSize = poolobj.NumWorkers;
end

delete(poolobj);