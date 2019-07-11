num = containers.Map({1, 2, 3}, {'one', 'two', 'three'});

num(1);
num(1) = 'ONE';
num(1);

%%
num(4) = 'four';
num(4);

keys(num);
values(num);
size(num);

%%
num2 = containers.Map( {10, 20}, {'ten', 'twenty'} );

numMerge = [num; num2];

keys(numMerge);
values(numMerge);

%% remove elements
remove(numMerge, 1);
keys(numMerge);

remove(numMerge, {2, 3});
keys(numMerge);

