
fid = fopen('mixed.txt', 'w');
str1 = "hello world";
bytes1 = unicode2native(str1, 'ISO-8859-1');
fwrite(fid, bytes1, 'uint8');

str2 = "您好，世界";
bytes2 = unicode2native(str2, 'GB2312');
% bytes2 = unicode2native(str2, 'Shift-JIS');
fwrite(fid, bytes2, 'uint8');
fclose(fid);