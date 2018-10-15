[Action-Decision Networks for Visual Tracking with Deep Reinforcement Learning](https://arxiv.org/pdf/1701.08936.pdf)

[Deep Reinforcement Learning For Visual Objective Tracking](https://arxiv.org/pdf/1701.08936.pdf)

[项目的地址](https://github.com/donghaiwang/VisualTracking_DRL)

出现不能从DVD中进行安装，需要回退到install文件的上一级运行，比如：./matlab_install/install
mkdir matlab
sudo mount -o loop ~/Documents/R2016b_glnxa64_dvd1.iso /media/matlab
sudo umount /media/matlab
sudo mount *_dvd1.iso /media/matlab

2018链接2017失败：
删掉vl_compilenn.m中{'-largeArrayDims'}, 总共三处

找不到libcudart.so.8.0
sudo ldconfig /user/local/cud-8.0/lib64

github上新建工程：
git add 修改的文件
git config --global user.email "1401499358@qq.com"
git config --global user.name "donghaiwang"
git commit -m "first commit"
git remote rm origin
git remote add origin https://github.com/donghaiwang/VisualTracking_DRL.git
git push -u origin master