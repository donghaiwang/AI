p = gcp();
f = parfeval(p, @magic, 1, 10);
value = fetchOutputs(f);

%%
p = gcp();
for idx = 1 : 10
    f(idx) = parfeval(p, @magic, 1, idx);
end

magicResults = cell(1, 10);
for idx = 1 : 10
    [completedIdx, value] = fetchNext(f);
    magicResults{completedIdx} = value;
    fprintf('Got result with index: %d.\n', completedIdx);
end
