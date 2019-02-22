load wind

[sx, sy, sz] = meshgrid(80, 20:10:50, 0:5:15);
streamtube(x,y,z, u,v,w, sx,sy,sz);
view(3);
axis tight
shading interp
camlight;
lighting gouraud

%%
load wind
[sx, sy, sz] = meshgrid(80, 20:10:50, 0:5:15);
verts = stream3( x,y,z, u,v,w, sx,sy,sz);
div = divergence( x,y,z, u,v,w );
streamtube(verts, x,y,z, -div);
view(3);
axis tight
shading interp
camlight
lighting gouraud