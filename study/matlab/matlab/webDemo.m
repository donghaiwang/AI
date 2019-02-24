url = 'https://www.mathworks.com';
web(url);

%%
web(url, '-new', '-notoolbar');

%%
program = fullfile(matlabroot,'help','techdoc',...
          'matlab_env','examples','fourier_demo2.m');
% winopen(program);
copyfile(program);
htmlfile = publish('fourier_demo2.m');

%%
%
web(htmlfile, '-new', '-notoolbar');

%%
web(htmlfile, '-browser');

%%
% email = 'haidong@hnu.edu.cn';
email = '1402499358@qq.com';
url = ['mailto:', email];
web(url, '-browser')

%%
url = 'https://www.mathworks.com';
[stat,h] = web(url);
% web(url, '-browser')
pause(6);
close(h);

%%
web('text://<html><h1>Hello World</h1></html>', '-notoolbar');
