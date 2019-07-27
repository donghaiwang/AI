function y = velFun(x)
    y = (1/200) * cumsum(x);
    y = y - mean(y);
end
