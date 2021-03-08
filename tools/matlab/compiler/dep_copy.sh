# 根据生成的run_*.sh脚本改编（失败）
# 将必须要的库文件拷贝到lib目录下（必须满足指定目录结构）

# 使用： 
# ./dep_copy.sh matlab_2018a_MCR

exe_name=$0
exe_dir=`dirname "$0"`
echo "------------------------------------------"
if [ "x$1" = "x" ]; then
  echo Usage:
  echo    $0 \<deployedMCRroot\> args
else
  echo Setting up environment variables
  MCRROOT="$1"

  mkdir -p lib/runtime/glnxa64
  cp -r ${MCRROOT}/runtime/glnxa64 lib/runtime/glnxa64
  mkdir -p lib/bin/glnxa64
  cp -r ${MCRROOT}/bin/glnxa64 lib/bin/glnxa64
  mkdir -p lib/sys/os/glnxa64
  cp -r ${MCRROOT}/sys/os/glnxa64 lib/sys/os/glnxa64
  mkdir -p lib/sys/opengl/lib/glnxa64
  cp -r ${MCRROOT}/sys/opengl/lib/glnxa64 lib/sys/opengl/lib/glnxa64

  echo ---
  # LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;
  # LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64 ;
  # LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64;
  # LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64;
  # export LD_LIBRARY_PATH;
  # echo LD_LIBRARY_PATH is ${LD_LIBRARY_PATH};
  # shift 1
  # args=
  #while [ $# -gt 0 ]; do
  #     token=$1
  #    args="${args} \"${token}\""
  #    shift
  # done
  # eval "\"${exe_dir}/magicsquare\"" $args
fi
exit


# 递归拷贝ldd所依赖的库，但是matlab仍然缺少必要的库
# exe="magicsquare"   # 可执行程序
# des="./lib"  # 存放位置

# deplist=$(ldd $exe | awk  '{if (match($3,"/")){ printf("%s "),$3 } }')
# cp $deplist $des
