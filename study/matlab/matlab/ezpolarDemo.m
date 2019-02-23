%% easy polar plot (ezpolar)
figure;
ezpolar('1+cos(t)');

%%
ezpolar('t^2*cos(t)');

%%
fh = @(t) t.^2 .* cos(t);
ezpolar(fh);

%%
ezpolar(@(t) myfun(t, 2, 3));

function s = myfun(t, k1, k2)
s = sin(k1*t) .* cos(k2*t);
end