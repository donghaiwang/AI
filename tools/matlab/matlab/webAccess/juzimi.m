% url = 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
% rgb = webread(url);
% whos rgb

url = 'https://www.juzimi.com/totallike?page=49';
pageContents = webread(url);

% views-field-phpcode-1">
pattern = '(?<=views-field-phpcode-1)';
ret = regexp(pageContents, pattern)

