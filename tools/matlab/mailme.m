%%
% example: 
%       mailme('test', 'Test email');
function mailme(mailtitle, mailcontent)
% �˺�����
mail = 'nongfugengxia@163.com';  % �������ַ
password = 'a5300066'; % ������ (need Authorization Code: a5)

% ����������
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.163.com'); % ��SMTP������
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% �����ʼ�
receiver='1402499358@qq.com'; % ���ҵ��ռ�����
sendmail(receiver,mailtitle,mailcontent);
end