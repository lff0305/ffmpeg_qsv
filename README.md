# Prebuilt files: https://app.box.com/s/1esr0au5hikxbunuuxqeb5aw8ql7w28h

# This is a prebuilt ffmpeg(n4.4) with
- Intel QSV
- X264
- X265
- libmp3lame

# Known issues

For a machine with **multiple** adapters, I have **not** figured out how to let `ffmpeg` call the specific intel video card. For intel provided tools (`vainfo`, `sample_encode`, etc) there is an option like `--device /dev/dri/card<n>` to select the intel card.

If you figured out which parameter can be used in `ffmpeg` to select a video adapter, please let me know (Or create a ticket).

For me, I am doing all the jobs in `Vmware ESXi` environment, set the `Intel Video Card` to `Hardware Pass Through` to the VM, and set `svga.present=FALSE` to disable the default video adapter. So, the intel video adapter will be the only one. But as a result, you will not be able to use the `VM Console` in ESXi Web Console. You have to use a SSH terminal.

# Requirement: 
- GlibC 2.29 + (I compiled `ffmpeg`, `intel mediasdk`, `intel media driver` and all other dependencies in Ubuntu 20.04, and it is linked with GlibC 2.29. So on some other platforms (Like Centos8 which is 2.28) it cannot run. :disappointed:
- A recent Intel Video Adapter which supports iHD driver
- root is strongly recommonded when testing, since all the tools needs to open device & call lower intel driver APIs

# My environment (On Ubuntu 20.04 LTS):
- `uname -a` : `Linux linux 5.4.0-74-generic #83-Ubuntu SMP Sat May 8 02:35:39 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux`
- `lspci | grep VGA`: `0b:00.0 VGA compatible controller: Intel Corporation UHD Graphics 605 (rev 06)`


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

Download the `.tar.gz` file, decompress it, and create the following `ENV` :
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

# Run ffmpeg to encoding the sample video

```
 ./ffmpeg -i sample_outdoor_car_1080p_10fps.h264 -vcodec h264_qsv -acodec libmp3lame /tmp/1.mp4
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
Input #0, h264, from 'sample_outdoor_car_1080p_10fps.h264':
  Duration: N/A, bitrate: N/A
  Stream #0:0: Video: h264 (High), yuv420p(progressive), 1920x1080 [SAR 1:1 DAR 16:9], 10 fps, 10 tbr, 1200k tbn, 20 tbc
Stream mapping:
  Stream #0:0 -> #0:0 (h264 (native) -> h264 (h264_qsv))
Press [q] to stop, [?] for help
Output #0, mp4, to '/tmp/1.mp4':
  Metadata:
    encoder         : Lavf58.76.100
  Stream #0:0: Video: h264 (avc1 / 0x31637661), nv12(tv, progressive), 1920x1080 [SAR 1:1 DAR 16:9], q=2-31, 1000 kb/s, 10 fps, 10240 tbn
    Metadata:
      encoder         : Lavc58.134.100 h264_qsv
    Side data:
      cpb: bitrate max/min/avg: 0/0/1000000 buffer size: 0 vbv_delay: N/A
frame=  600 fps= 39 q=30.0 Lsize=    7348kB time=00:00:59.70 bitrate=1008.2kbits/s speed=3.92x    
video:7339kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.116950%
```


# FAQs
1. What to do if I have multiple video adapters ?
  
    for `vainfo` you can try `./vainfo --display drm --device /dev/dri/<card index>`
    For example, `./vainfo --display drm --device /dev/dri/card1`
  
2. How to control the qsv encoder quality ?
  
    Thanks to this thread `https://superuser.com/questions/1259059/ffmpeg-h264-qsv-encoder-and-crf-issues`
    Users can use `-global_quality and `-look_ahead` like
    ```
    ffmpeg -i in.mp4 -c:v h264_qsv -global_quality 10 -look_ahead 1 out.mp4
    ```
    In my test, a quality `32` is good enough for general usage. It can be set between 1 (Best but biggest size) to 51 (Worse, smallest size)
