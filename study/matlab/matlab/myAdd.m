function c = myAdd(a, b)
    c = a+b;
    
    str = sprintf('%s called with %d, %d (%s)', mfilename, a, b, char(datetime));
    assignin('base', 'fcnStatus', str);
end