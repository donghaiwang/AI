Z = magic(5);
b = bar3(Z);
colorbar

for k = 1 : length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
