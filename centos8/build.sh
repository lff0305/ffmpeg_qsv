#!/bin/bash	
set -e

echo "Running yum to install needed tools and libraries"
yum install -y git bzip2 gcc gcc-c++ libdrm libdrm-devel autoconf automake libtool
yum update -y libarchive
echo "yum jobs done."

echo "Getting sources from github.com..."
wget https://github.com/Intel-Media-SDK/MediaSDK/archive/refs/tags/intel-mediasdk-21.1.3.tar.gz
wget https://github.com/intel/libva/releases/download/2.11.0/libva-2.11.0.tar.bz2
wget https://github.com/intel/libva-utils/releases/download/2.11.1/libva-utils-2.11.1.tar.bz2
echo "Source code downloaded."

echo "Unzipping source files"
bzip2 -d libva-2.11.0.tar.bz2 
bzip2 -d libva-utils-2.11.1.tar.bz2 
tar xf intel-mediasdk-21.1.3.tar.gz 
tar xf libva-2.11.0.tar 
tar xf libva-utils-2.11.1.tar 
echo "Unzip done"

echo "Building libva..."
cd  libva-2.11.0
./configure --prefix=/opt/intel/libva --libdir=/opt/intel/libva/lib
make
make install
cd ..
echo "Building libva done"
 
echo "Building libva-utils"
cd libva-utils-2.11.1
export PKG_CONFIG_PATH=/opt/intel/libva/lib/pkgconfig 
./configure --prefix=/opt/intel/libva-utils --libdir=/opt/intel/libva-utils/lib 
make
make install
cd ..
echo "Building libva-utils done"

echo "Building intel gmmlib & media-driver"
echo "Checking out gmmlib"
git clone https://github.com/intel/gmmlib.git
cd gmmlib
git checkout 60a7718
cd ..
echo "Checking out media-driver"
git clone https://github.com/intel/media-driver.git
cd media-driver
git checkout bec8e13
cd ..
mkdir build
cd build
echo "Building gmmlib & media-driver"
cmake ../media-driver \
 -DMEDIA_VERSION="2.0.0" \
 -DBUILD_ALONG_WITH_CMRTLIB=1 \
 -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
 -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
 -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
 -DBS_DIR_MEDIA=`pwd`/../media-driver \
 -DCMAKE_INSTALL_PREFIX=/opt/intel/media-driver \
 -DCMAKE_INSTALL_LIBDIR=/opt/intel/media-driver/lib \
 -DINSTALL_DRIVERS_SYSCONF=OFF \
 -DLIBVA_DRIVERS_PATH=/opt/intel/media-driver/lib/dri
make
make install 

export LIBVA_DRIVER_NAME=iHD
export LIBVA_DRIVERS_PATH=/opt/intel/media-driver/lib/dri
cd ..
echo "Building gmmlib & media-driver done"

echo "Checking out fdk-aac"
git clone https://github.com/mstorsjo/fdk-aac.git
echo "Building fdk-aac"
cd fdk-aac
./autogen.sh
./configure
make
make install
cd ..
echo "Building fdk-aac done"

echo "Downloading mp3lame"
wget https://telkomuniversity.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xf lame-3.100.tar.gz
cd lame-3.100
echo "Building mp3lame"
./configure
make
make install
cd ..
echo "Building mp3lame done"


echo "Building mediasdk"
cd MediaSDK-intel-mediasdk-21.1.3/
export PKG_CONFIG_PATH=/opt/intel/libva/lib/pkgconfig
mkdir build && cd build
cmake ..
make
make install
cd ..
cd ..
echo "Building mediasdk done"

echo "Downloading FFMPEG source n4.4"
wget https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n4.4.tar.gz
tar xzf n4.4.tar.gz
cd FFmpeg-n4.4/


export MFX_HOME=/opt/intel/mediasdk/lib/pkgconfig
export PKG_CONFIG_PATH=/opt/intel/libva/lib/pkgconfig:/opt/intel/mediasdk/lib64/pkgconfig

echo "Building FFMPEG n4.4"

./configure --enable-gpl \
              --disable-shared \
	      --disable-ffprobe \
	      --enable-libmp3lame \
              --enable-libfdk-aac \
              --disable-x86asm \
              --disable-lzma \
              --enable-pic \
              --extra-cflags=-fPIC \
              --extra-cxxflags=-fPIC \
              --enable-libmfx \
              --enable-nonfree \
              --enable-encoder=h264_qsv \
              --enable-decoder=h264_qsv \
              --enable-encoder=hevc_qsv \
              --enable-decoder=hevc_qsv \
              --prefix=/opt/ffmpeg \
              --libdir=/opt/ffmpeg/lib
			 

make
make install
echo "FFMPEG building is done." 
export LD_LIBRARY_PATH=/opt/intel/libva/lib:/opt/intel/mediasdk/lib64:/usr/local/lib
cd /opt/ffmpeg/bin
./ffmpeg -version

