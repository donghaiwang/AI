function assignfh
    fh = @(dim)rand(dim);
    assignin('caller', 'fh', fh);
end