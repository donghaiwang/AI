function html=formshow(headers,config)
html='<html><head></head><body>';
html=[html 'This html is produced by formshow.m <br><br>'];
html=[html 'Your user Credentials<br>'];
ContentForm=headers.Content;
fn=fieldnames(ContentForm);
for i=1:length(fn)
	html=[html 'Your ' fn{i} ' is ' ContentForm.(fn{i}) '<br>'];
end
html=[html '<br><br> <a href="form.html">Back to Previous Page</a><br>'];
html=[html '</body></html>'];

 