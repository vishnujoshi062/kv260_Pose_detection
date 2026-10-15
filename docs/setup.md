# Setup

Step-by-step flow for running `seg_and_pose_detect` on the KV260.

## 1. Get the videos

The demo does not ship with its videos. They come in the Vitis AI Library video package `vitis_ai_library_r3.0.0_video.tar.gz`.

On your PC:

```
sh scripts/download_videos.sh
```

This downloads the package and puts `seg_960_540.avi` and `pose_960_540.avi` in `./videos`. If the download fails, get the package manually from the Vitis AI Library documentation (UG1354, Demo 2: seg_and_pose_detect) and take the two `.avi` files from it.

You can also use your own video; 960x540 is the size the demo is built for.

## 2. Connect the board to your PC

The board needs a working Ethernet link to receive the videos.

On the board, run `ifconfig`. `eth0` must show the `RUNNING` flag and its packet counters must increase. If it shows `UP,BROADCAST,MULTICAST` without `RUNNING` and 0 packets, the link is down: check the cable and port.

If the board is connected directly to the PC, give the PC's Ethernet adapter a static IP in the board's subnet (the board in this setup is `192.168.0.12/24`, so use for example `192.168.0.10`).

Check from the PC:

```
ping 192.168.0.12
```

## 3. Copy the videos to the board

From **Windows CMD or PowerShell** (not WSL, which sits on a different virtual network):

```
scp seg_960_540.avi pose_960_540.avi root@192.168.0.12:~/Vitis-AI/examples/vai_library/apps/seg_and_pose_detect/
```

## 4. Build (only if needed)

The prebuilt binaries `seg_and_pose_detect_x` and `seg_and_pose_detect_drm` may already be in the sample folder. If not, on the board:

```
cd ~/Vitis-AI/examples/vai_library/apps/seg_and_pose_detect
sh build.sh
```

## 5. Run

The desktop shown on the board's monitor is X display `:0`. If you start the demo from an SSH session (for example MobaXterm), point it there so the window appears on the board's monitor:

```
export DISPLAY=:0
cd ~/Vitis-AI/examples/vai_library/apps/seg_and_pose_detect
./seg_and_pose_detect_x seg_960_540.avi pose_960_540.avi -t 3 -t 3
```

Do not redirect the output to `/dev/null` while testing, so errors stay visible.

With a USB camera as the second input (plug it in and check that `ls /dev/video*` lists a device):

```
./seg_and_pose_detect_x seg_960_540.avi 0 -t 3 -t 3
```

The first input must be a video file. Stop the demo with `Ctrl+C`.

The helper scripts `scripts/run_video.sh` and `scripts/run_camera.sh` run the same commands from the sample folder.

## Common errors

| Message | Cause and fix |
|---|---|
| `Can not open video stream!` / `VAILIB_DEMO_VIDEO_OPEN_ERROR` | The `.avi` file is not in the folder you run from. Copy it there. |
| `Aborted` with no other message | The output was redirected. Run without `> /dev/null 2>&1`. |
| `scp: No route to host` | The Ethernet link is down or the IP is wrong. See step 2. |
| Model fails to load, DPU fingerprint mismatch | The xmodel was compiled for another DPU. See [models.md](models.md). |
| Window cropped on a small screen | The demo draws a fixed 1920x1080 window. Use a 1080p monitor. |
