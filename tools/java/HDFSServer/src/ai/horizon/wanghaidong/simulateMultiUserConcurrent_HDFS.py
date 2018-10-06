#coding=utf-8
'''
Created on Jun 26, 2017

@author: ubuntu
'''
import os
import re
import threading
import time
import urllib
import urllib2
import uuid


def getHtml(url):
    page = urllib.urlopen(url)  #urllib.urlopen()方法用于打开一个URL地址
    html = page.read() #read()方法用于读取URL上的数据
    return html


def getImg(html):
    reg = r'href=\"([^\"]*?)\"'    #正则表达式，得到图片地址????
    imgre = re.compile(reg)     #re.compile() 可以把正则表达式编译成一个正则表达式对象.
    imglist = re.findall(imgre,html)      #re.findall() 方法读取html 中包含 imgre（正则表达式）的    数据
#     print imglist
    #把筛选的图片地址通过for循环遍历并保存到本地
    #核心是urllib.urlretrieve()方法,直接将远程数据下载到本地，图片通过x依次递增命名
    x = 1
    for imgurl in imglist:
        if imgurl == '/download/':
            continue
        imgurl = 'http://10.10.10.184:8080' + imgurl
        urllib.urlretrieve(imgurl,'/data/sdk/getImg/download/%s.jpg' % x)
        x+=1
        
class MyThread(threading.Thread):
    def __init__(self, name=None):
        threading.Thread.__init__(self)
        self.name = name

    def run(self):
        #print self.name
        for i in range(0, 10):
            imgurl1 = 'http://10.10.10.184:8080/download/72c3f1c6-46e6-4ec3-abf6-a137ba80283b/*';
            urllib.urlretrieve(imgurl1,'//home/ubuntu/git/download/%s.jpg' % uuid.uuid1().__str__())
#                 imgurl1 = 'http://10.19.19.22:8080/action.php?fileID=GQwRCw5PUTNOTVFGR1FMSlE9FjMqOBISL0YuFz8cSCoNPz8dHyE/OgoXES9JR09LTklN&dueTime=T0pHR05JSEZJTA=='
#                 urllib2.urlopen(imgurl1).read()
                #urllib.urlretrieve(imgurl1,'/data/sdk/getImg/download/%s.jpg' % uuid.uuid1().__str__())
#                 imgurl2 = 'http://10.19.19.24:8080/action.php?fileID=GQwRCw5PUTNOTVFOTlFOTlE9FjMqOTgSMCETSD8YKDgXPz8dHyE7JxtGTxVNTUxKRk5N&dueTime=T0pHR05KT05NRw=='
                #urllib.urlretrieve(imgurl2,'/data/sdk/getImg/download/%s.jpg' % uuid.uuid1().__str__())
#                 urllib2.urlopen(imgurl2).read()



if __name__=='__main__':
#     path='/home/ubuntu/git/log'
    #path = 'http://10.10.10.184:8080/download/72c3f1c6-46e6-4ec3-abf6-a137ba80283b/'
    path = 'http://10.10.10.184:8080/download/b44aae8f-7048-4455-94fb-3a807c6a7e66/'
    html = getHtml(path)
   # print html
    getImg(html)

#     start_milli_time = int(round(time.time() * 1000))
#     tsk = []
#     for i in range(0, 1):
#         t = MyThread("thread_" + str(i))
#         t.start()
#         tsk.append(t)
#     for tt in tsk:
#         tt.join()
#     end_milli_time = int(round(time.time() * 1000))
#     print (end_milli_time - start_milli_time)
