%%
% example: 
%       mailme('test', 'Test email');
function mailme(mailtitle, mailcontent)
% 账号设置
mail = 'nongfugengxia@163.com';  % ①邮箱地址
password = 'a5300066'; % ②密码 (need Authorization Code: a5)

% 服务器设置
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.163.com'); % ③SMTP服务器
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% 发送邮件
receiver='1402499358@qq.com'; % ④我的收件邮箱
sendmail(receiver,mailtitle,mailcontent);
end