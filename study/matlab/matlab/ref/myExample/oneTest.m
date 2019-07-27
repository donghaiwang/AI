%% Test double class
expClass = 'double';
act = ones;
assert(isa(act, expClass));

%% 
expClass = 'single';
act = ones('single');
assert(isa(act, expClass));

%%
expClass = 'uint16';
act = ones('uint16');
assert(isa(act, expClass));

%%
expSize = [7 13];
act = ones([7 13]);
assert(isequal(size(act), expSize));

%%
act = ones(42);
assert(unique(act) == 1);
