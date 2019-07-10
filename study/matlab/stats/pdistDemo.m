rng('default');
X = rand(3, 2);

D2 = pdist(X, @naneucdist);
