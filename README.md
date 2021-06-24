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


# ffmpeg info:
```
ffmpeg version n4.4 Copyright (c) 2000-2021 the FFmpeg developers
  built with gcc 9 (Ubuntu 9.3.0-17ubuntu1~20.04)
  configuration: --enable-gpl --disable-shared --enable-libmp3lame --enable-libx264 --enable-libx265
                 --disable-x86asm --disable-lzma --enable-pic --extra-cflags=-fPIC --extra-cxxflags=-fPIC
                 --enable-libmfx --enable-nonfree --enable-encoder=h264_qsv --enable-decoder=h264_qsv 
                 --enable-encoder=hevc_qsv --enable-decoder=hevc_qsv --prefix=/opt/ffmpeg --libdir=/opt/ffmpeg/lib
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

# Usage

Unzip and create the following `ENV` :
```
export LD_LIBRARY_PATH="<the unzipped directory, which contains ffmpeg binary>"
export LIBVA_DRIVERS_PATH="<the unzipped directory, which contains ffmpeg binary>"
export LIBVA_DRIVER_NAME="iHD"
```

# Check before running ffmpeg
- cd <unzipped directory> and run `./vainfo`
  You should see something like
```
./vainfo
error: XDG_RUNTIME_DIR not set in the environment.
error: can't connect to X server!
libva info: VA-API version 1.11.0
libva info: User environment variable requested driver 'iHD'
libva info: Trying to open /home/lff/ffmpeg_qsv/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_11
libva info: va_openDriver() returns 0
vainfo: VA-API version: 1.11 (libva 2.11.0)
vainfo: Driver version: Intel iHD driver for Intel(R) Gen Graphics - 21.1.3 (bec8e138)
vainfo: Supported profile and entrypoints
      VAProfileNone                   : VAEntrypointVideoProc
      VAProfileNone                   : VAEntrypointStats
      VAProfileMPEG2Simple            : VAEntrypointVLD
      VAProfileMPEG2Main              : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointFEI
      VAProfileH264Main               : VAEntrypointEncSliceLP
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSlice
      VAProfileH264High               : VAEntrypointFEI
      VAProfileH264High               : VAEntrypointEncSliceLP
      VAProfileVC1Simple              : VAEntrypointVLD
      VAProfileVC1Main                : VAEntrypointVLD
      VAProfileVC1Advanced            : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointEncPicture
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline: VAEntrypointFEI
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSliceLP
      VAProfileVP8Version0_3          : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointEncSlice
      VAProfileHEVCMain               : VAEntrypointFEI
      VAProfileHEVCMain10             : VAEntrypointVLD
      VAProfileHEVCMain10             : VAEntrypointEncSlice
      VAProfileVP9Profile0            : VAEntrypointVLD
      VAProfileVP9Profile2            : VAEntrypointVLD
  ```
# Check Intel decoding sample tool is good (root required !!)
```
 ./sample_decode h264 -i sample_outdoor_car_1080p_10fps.h264 -o /tmp/output.yuv -vaapi
libva info: VA-API version 1.11.0
libva info: User environment variable requested driver 'iHD'
libva info: Trying to open /home/lff/ffmpeg_qsv//iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_11
libva info: va_openDriver() returns 0
Decoding Sample Version 8.4.27.0


Input video     AVC 
Output format   NV12
Input:
  Resolution    1920x1088
  Crop X,Y,W,H  0,0,1920,1080
Output:
  Resolution    1920x1080
Frame rate      10.00
Memory type             vaapi
MediaSDK impl           hw
MediaSDK version        1.35

Decoding started
^Came number:   31, fps: 8.734, fread_fps: 0.000, fwrite_fps: 8.928
```

# Check Intel encoding sample tool is good (root required !!)
```
./sample_encode h264 -i /tmp/output.yuv -o /tmp/1.h264 -w 1920 -h 1080 -vaapi
libva info: VA-API version 1.11.0
libva info: User environment variable requested driver 'iHD'
libva info: Trying to open /home/lff/ffmpeg_qsv//iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_11
libva info: va_openDriver() returns 0
Encoding Sample Version 8.4.27.0

Input file format       YUV420
Output video            AVC 
Source picture:
        Resolution      1920x1088
        Crop X,Y,W,H    0,0,1920,1080
Destination picture:
        Resolution      1920x1088
        Crop X,Y,W,H    0,0,1920,1080
Frame rate      30.00
Bit rate(Kbps)  3757
Gop size        256
Ref dist        4
Ref number      3
Idr Interval    0
Target usage    balanced
Memory type     vaapi
Media SDK impl          hw
Media SDK version       1.35

Processing started
Frame number: 31
Encoding fps: 83

Processing finished
```

# FAQs
1. What to do if I have multiple video adapters ?
   for `vainfo` you can try `./vainfo --display drm --device /dev/dri/<card index>`
   For example, `./vainfo --display drm --device /dev/dri/card1`
