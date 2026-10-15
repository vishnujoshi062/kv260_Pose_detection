#!/bin/sh
# Download and extract the Vitis AI Library video package, keeping the two videos needed by the demo.
# Run on a PC (or on the board if it has internet). Needs wget and tar.
# Usage: sh download_videos.sh [OUTPUT_DIR]   (default: ./videos)
URL="https://www.xilinx.com/bin/public/openDownload?filename=vitis_ai_library_r3.0.0_video.tar.gz"
OUT="${1:-./videos}"
mkdir -p "$OUT/pkg" || exit 1
wget "$URL" -O "$OUT/video.tar.gz" || { echo "Download failed. Open the URL in a browser, or find vitis_ai_library_r3.0.0_video.tar.gz on the Vitis AI Library docs page."; exit 1; }
tar -xzf "$OUT/video.tar.gz" -C "$OUT/pkg" || exit 1
find "$OUT/pkg" \( -name seg_960_540.avi -o -name pose_960_540.avi \) -exec cp {} "$OUT"/ \;
ls -l "$OUT"/*.avi
