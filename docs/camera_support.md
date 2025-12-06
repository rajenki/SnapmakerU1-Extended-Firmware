# Camera Support

**Available in: Extended firmware only**

The extended firmware includes hardware-accelerated camera support.

## Features

- Hardware-accelerated camera stack (Rockchip MPP/VPU)
- v4l2-mpp: MIPI CSI and USB camera support
- WebRTC low-latency streaming
- Hot-plug detection for USB cameras

## Accessing Cameras

### Internal Camera

Access the native camera at:
```
http://<printer-ip>/webcam/
```

### USB Camera

Access USB camera at:
```
http://<printer-ip>/webcam2/
```

You need to add USB camera in Fluidd. Use the following
settings for the best performance:

<img src="images/usb_cam.png" alt="Fluidd USB camera" width="300"/>

## Configuring Camera Streaming

The internal camera defaults to WebRTC streaming for low latency. You can switch between streaming modes via SSH.

### Switch to MJPEG Adaptive (better compatibility)

```bash
cat > /home/lava/printer_data/config/moonraker/webcam.cfg << 'EOF'
[webcam case]
service: mjpegstreamer-adaptive
stream_url: /webcam/stream.mjpg
snapshot_url: /webcam/snapshot.jpg
aspect_ratio: 16:9
EOF
/etc/init.d/S61moonraker restart
```

### Switch to WebRTC (low latency)

```bash
cat > /home/lava/printer_data/config/moonraker/webcam.cfg << 'EOF'
[webcam case]
service: webrtc-camerastreamer
stream_url: /webcam/webrtc
snapshot_url: /webcam/snapshot.jpg
aspect_ratio: 16:9
EOF
/etc/init.d/S61moonraker restart
```

### Available Services

| Service | Description |
|---------|-------------|
| `webrtc-camerastreamer` | Low-latency WebRTC (recommended) |
| `mjpegstreamer-adaptive` | MJPEG with adaptive framerate |
| `mjpegstreamer` | Basic MJPEG streaming |
| `ipstream` | Direct stream embedding |

## Enable Snapmaker's Camera Stack

By default, the extended firmware uses a custom hardware-accelerated camera stack.
If you prefer to use Snapmaker's original camera stack instead, create:

```bash
touch /oem/.camera-native
```

Note: Only one camera stack can be operational at a time.

## Enable Camera Logging

To enable syslog logging for camera services (useful for debugging), create:

```bash
touch /oem/.camera-log
```

This will enable the `--syslog` flag for all camera-related services. Logs will then be available in `/var/log/messages`.

## Timelapse Support

Fluidd timelapse plugin is included (no settings support).

Note: Time-lapses are not available via mobile app in cloud mode.
