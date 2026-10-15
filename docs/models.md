# Models

The demo loads two models by name from `/usr/share/vitis_ai_library/models/<model_name>/` on the board:

| Network | Model name used in the source |
|---|---|
| Multi-task segmentation + car detection | `multi_task` |
| Pedestrian detection | `ssd_pedestrian_pruned_0_97` |
| Pose estimation | `sp_net` |

Each model folder contains the compiled `.xmodel` and a `.prototxt` with the same base name as the folder.

## DPU compatibility

An xmodel is compiled for one specific DPU architecture. It loads only on a board with that DPU.

| Board | DPU |
|---|---|
| KV260 | DPUCZDX8G (B3136) |
| VCK190 | DPUCVDX8G |
| VEK280 | DPUCV2DX8G (Vitis AI 3.5 or later) |

The models on the DPU Vitis AI 3.0 SD card image for the KV260 are already compiled for it, so the demo runs without any model work. In the Vitis AI 3.0 Model Zoo, downloads are often labeled for several boards at once (for example ZCU102, ZCU104 and KV260), which means the same xmodel may already work on the KV260. Try the model as it is first.

## Recompiling for the KV260

Only needed if loading fails with a DPU fingerprint mismatch. Do this on a PC inside the Vitis AI Docker container.

1. Take the **quantized** xmodel from the Model Zoo download (the `quantized/` folder), not the already compiled one.
2. Compile it with the KV260 architecture file:
   ```
   vai_c_xir -x /path/to/quantized.xmodel \
             -a /opt/vitis_ai/compiler/arch/DPUCZDX8G/KV260/arch.json \
             -o /path/to/out -n model_name
   ```
3. Copy the output folder to the board as `/usr/share/vitis_ai_library/models/model_name/`.
4. The folder name, the `.xmodel` name and the `.prototxt` name must all match. Take the `.prototxt` from the Model Zoo download.
