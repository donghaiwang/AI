f = @(x,y,z) x.^2 + y.^2 - z.^2;
fimplicit3(f);

%%
f = @(x,y,z) x.^2 + y.^2 - z.^2;
interval = [-5 5 -5 5 0 5];
fimplicit3(f, interval);

%%
f = @(x,y,z) x.^2 + y.^2 - z.^2;
fimplicit3(f, 'EdgeColor','none', 'FaceAlpha', .5);

%%
f = @(x,y,z) 1/x.^2 - 1/y.^2 - 1/z.^2;
fs = fimplicit3(f);

fs.XRange = [0 5];
fs.EdgeColor = 'none';
fs.FaceAlpha = 0.8;