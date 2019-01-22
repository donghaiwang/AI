clear;clc;
hold all;
load PSF_030_120_useNN.dat
cnt = 0;
num = 1024*1024;
for i = 1 : num
    if PSF_030_120_useNN(i, 3) == 0
        
    else
        plot(PSF_030_120_useNN(i, 1), PSF_030_120_useNN(i, 2));
        cnt = cnt + 1;
    end
end
disp(cnt);