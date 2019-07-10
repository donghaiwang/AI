function D2 = naneucdist(XI, XJ)

n = size(XI, 2);
sqdx = (XI - XJ).^2;
nstar = sum(~isnan(sqdx), 2);
nstar(nstar == 0) = NaN; % if nstar== 0, then start = NaN
D2squared = nansum(sqdx, 2).*n./nstar;
D2 = sqrt(D2squared);


% D2 = 0;

end
