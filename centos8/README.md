# Requirement

`Centos8` with `root` permission.

# Version

This script is based on:
- Media SDK and Samples: https://github.com/Intel-Media-SDK/MediaSDK/releases/tag/intel-mediasdk-21.1.3
- Driver: https://github.com/intel/media-driver/releases/tag/intel-media-21.1.3
- Gmmlib: https://github.com/intel/gmmlib/releases/tag/intel-gmmlib-21.1.1
- libva: https://github.com/intel/libva/releases/tag/2.11.0
- libva-utils: https://github.com/intel/libva-utils/releases/tag/2.11.1

See https://github.com/Intel-Media-SDK/MediaSDK/releases/tag/intel-mediasdk-21.1.3

# Usage

download `build.sh` to a new directory, run
```
chmod +x build.sh
./build.sh
```
to install required tools (`gcc`, `make`, etc) and libraries, build dependencies and `ffmpeg`.
The `ffmpeg` will be placed at `/opt/ffmpeg/bin`.
