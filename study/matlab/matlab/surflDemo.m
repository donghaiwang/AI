[x, y] = meshgrid( -3 : 1/8 : 3);
z = peaks(x, y);
surfl(x, y, z)
shading interp