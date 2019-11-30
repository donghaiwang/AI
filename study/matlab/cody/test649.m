%%
x = 'abcde';
y_correct = 'ae';
assert(isequal(stringfirstandlast(x),y_correct))
%%
x = 'a';
y_correct = 'aa';
assert(isequal(stringfirstandlast(x),y_correct))
%%
x = 'codyrocks!';
y_correct = 'c!';
assert(isequal(stringfirstandlast(x),y_correct))
