
# Demo

编译成独立的应用（applicationCompiler）并运行：

    ./run_magicsquare.sh matlab_2018a_MCR 7
    # or:
    export LD_LIBRARY_PATH=.:matlab_2018a_MCR/runtime/glnxa64/:matlab_2018a_MCR/sys/opengl/lib/glnxa64/:matlab_2018a_MCR/sys/os/glnxa64/:matlab_2018a_MCR/bin/glnxa64/
    
不需要安装的MCR保存在百度网盘：install/matlab/2018a/MCR/matlab_2018a_MCR.tar.gz (3.1G)
    
## 问题
使用ldd拷贝相关库文件或者仅仅拷贝有关的库文件目录都运行失败了，还是需要整个MCR环境。