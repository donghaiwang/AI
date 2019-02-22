theta = -pi/2 : pi/16 : pi/2;
r = 2 * ones( size( theta ) );

[u, v] = pol2cart(theta, r);
feather(u, v);