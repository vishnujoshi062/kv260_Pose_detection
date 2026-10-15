# kv260-seg-pose-detect

Run the Vitis AI 3.0 **`seg_and_pose_detect`** demo on the **AMD Kria KV260** Vision AI Starter Kit.

The demo runs two neural networks at the same time on the board's DPU:

- **Segmentation + car detection** (multi-task network) on a road video
- **Person detection + pose estimation** (SSD pedestrian detector + pose network) on a second video or a USB camera

Both results are drawn in one window. This repo is the working flow for the KV260: where to get the videos, how to copy them to the board, how to build and run the demo, and what to expect.

## Requirements

- Kria KV260 booted from the **DPU Vitis AI 3.0 SD card image** (the demo and models are already on it under `~/Vitis-AI`)
- A monitor on the board (HDMI or DisplayPort) showing the desktop
- A PC on the same network as the board, with an SSH client (MobaXterm, PuTTY or `ssh`)
- Optional: a USB camera (`/dev/video0`) for the pose input

## Quick start

1. **Get the videos** (on your PC):
   ```
   sh scripts/download_videos.sh
   ```
2. **Copy them to the board** (Windows CMD / PowerShell; replace the IP):
   ```
   scp videos/seg_960_540.avi videos/pose_960_540.avi root@192.168.0.12:~/Vitis-AI/examples/vai_library/apps/seg_and_pose_detect/
   ```
3. **Build** (on the board, only if `seg_and_pose_detect_x` is missing):
   ```
   cd ~/Vitis-AI/examples/vai_library/apps/seg_and_pose_detect
   sh build.sh
   ```
4. **Run** (on the board, X mode):
   ```
   export DISPLAY=:0
   ./seg_and_pose_detect_x seg_960_540.avi pose_960_540.avi -t 3 -t 3
   ```
   With a USB camera as the second input:
   ```
   ./seg_and_pose_detect_x seg_960_540.avi 0 -t 3 -t 3
   ```

The full walkthrough is in [`docs/setup.md`](docs/setup.md).

## Command line

```
./seg_and_pose_detect_x <video1> <video2|0> -t <threads1> -t <threads2>
```

- The first two arguments are the inputs: one video per network. `0` means the camera and is only valid as the **second** input.
- `-t 3 -t 3` sets the number of threads for each network.
- `seg_and_pose_detect_x` shows the result in an OpenCV window (X mode). `seg_and_pose_detect_drm` draws directly to a DisplayPort monitor and needs exclusive control of the display, so it fails while the desktop is running. Use X mode.

## Expected result

One window showing, for each stream, the original frame and the processed frame stacked: the road video with segmentation colours and car boxes, and the person video or camera with person boxes and pose lines. The terminal prints detections like `box.x ... box.score ...`. The `GStreamer-CRITICAL ... gst_query_set_position` messages are harmless and repeat each time the looping video restarts.

See [`results/`](results/) for output.

## Models

The demo loads its models by name from `/usr/share/vitis_ai_library/models/` on the board. Xmodels are compiled for a specific DPU, so models for the VCK190 or VEK280 do not work on the KV260. See [`docs/models.md`](docs/models.md).

## Repo layout

```
src/        original demo source from the board
scripts/    download_videos.sh, run_video.sh, run_camera.sh
docs/       setup.md, models.md
results/    output video and screenshots
```

## License

The scripts and docs in this repo are MIT licensed (see [`LICENSE`](LICENSE)). The demo source in `src/` is from the Vitis AI repository, Copyright Xilinx Inc., licensed under the Apache License 2.0; its license header is kept in the file.
