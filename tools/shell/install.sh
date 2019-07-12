
ffmpeg
xz -d ffmpeg-3.1.11.tar.xz
tar -xf ffmpeg-3.1.11.tar
./configure --prefix=/usr/local/ffmpeg --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-pthreads --enable-libfaac --enable-libtheora --enable-libx264 --enable-x11grab
