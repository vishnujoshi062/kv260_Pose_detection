#!/bin/sh
# Run from the seg_and_pose_detect folder on the board (videos must be in the same folder).
export DISPLAY=:0
./seg_and_pose_detect_x seg_960_540.avi pose_960_540.avi -t 3 -t 3
