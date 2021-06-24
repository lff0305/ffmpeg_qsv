# This is a prebuilt ffmpeg with
- Intel QSV
- X264
- X265
- libmp3lame

# Requirement: 
- GCC 2.29 +
- A recent Intel Video Adapter which supports iHD driver

# My environment (On Ubuntu 20.04 LTS):
- `uname -a` : `Linux linux 5.4.0-74-generic #83-Ubuntu SMP Sat May 8 02:35:39 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux`
- lspci | grep VGA: `0b:00.0 VGA compatible controller: Intel Corporation UHD Graphics 605 (rev 06)`
```

# ffmpeg info:

ffmpeg version n4.4 Copyright (c) 2000-2021 the FFmpeg developers
  built with gcc 9 (Ubuntu 9.3.0-17ubuntu1~20.04)
  configuration: --enable-gpl --disable-shared --enable-libmp3lame --enable-libx264 --enable-libx265 --disable-x86asm --disable-lzma --enable-pic --extra-cflags=-fPIC --extra-cxxflags=-fPIC --enable-libmfx --enable-nonfree --enable-encoder=h264_qsv --enable-decoder=h264_qsv --enable-encoder=hevc_qsv --enable-decoder=hevc_qsv --prefix=/opt/ffmpeg --libdir=/opt/ffmpeg/lib
  libavutil      56. 70.100 / 56. 70.100
  libavcodec     58.134.100 / 58.134.100
  libavformat    58. 76.100 / 58. 76.100
  libavdevice    58. 13.100 / 58. 13.100
  libavfilter     7.110.100 /  7.110.100
  libswscale      5.  9.100 /  5.  9.100
  libswresample   3.  9.100 /  3.  9.100
  libpostproc    55.  9.100 / 55.  9.100
Hyper fast Audio and Video encoder
usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...

Use -h to get full help or, even better, run 'man ffmpeg'
```
