[x, y] = meshgrid( -3:.5:3, -3:.1:3 );
z = peaks(x, y);

figure;
ribbon(y, z);