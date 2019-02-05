function html=uploadshow(headers,config)
filename_in=headers.Content.imagefile.Filename;
filename_in_html=filename_in(length(config.www_folder)+2:end);
I=double(imread(filename_in))/255;
[pathstr,name,ext] = fileparts(filename_in);
filename_out=[pathstr '/' name 'blur' ext];
J=conv2(mean(I,3),ones(5,5)/25);
imwrite(J,filename_out);
filename_out_html=filename_out(length(config.www_folder)+2:end);

html='<html><head></head><body>';
html=[html 'This html is produced by upload show.m <br><br>'];
html=[html 'You gave your image the title : ' headers.Content.imagetitle.ContentData ' <br><br>'];
html=[html 'Your image<br><img src="../' filename_in_html '" alt="Uploaded image"/> <br>'];
html=[html '<br><br>'];
html=[html '<img src="../' filename_out_html '" alt="Uploaded image"/> <br>'];
html=[html 'Blurred Grey scale version of your image <br>'];
html=[html '</body></html>'];

 