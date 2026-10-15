#!/bin/sh
# Run from the seg_and_pose_detect folder on the board.
# Second input is the USB camera (/dev/video0). Camera "0" is only valid as the second input.
export DISPLAY=:0
ls /dev/video* >/dev/null 2>&1 || { echo "No /dev/video* found. Plug in a USB camera."; exit 1; }
./seg_and_pose_detect_x seg_960_540.avi 0 -t 3 -t 3
