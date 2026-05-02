# Module 4 — 3D Perception & Sensor Fusion

> **Duration:** 3–4 weeks | **Prerequisites:** Module 1, your existing CV/DL background
> **Why this matters:** Robots need to *see* and *understand* the 3D world. Your CV/DL experience gives you a head start — this module upgrades it to 3D robotics perception, the #1 most-posted skill requirement.

---

## Learning Objectives
- Process 3D point clouds using PCL and Open3D
- Calibrate multi-sensor systems (camera-LiDAR, stereo, IMU)
- Implement 3D object detection and pose estimation
- Build advanced SLAM pipelines beyond basic 2D
- Deploy perception models on edge hardware

---

## Submodule 4.1 — Point Cloud Processing

### Topics
- **Point cloud fundamentals** — PCL data types, `PointXYZ`, `PointXYZRGB`, `PointXYZI`, organized vs. unorganized
- **Filtering** — voxel grid downsampling, passthrough, statistical outlier, radius outlier
- **Normal estimation** — surface normals for segmentation and registration
- **Segmentation** — RANSAC (plane, cylinder, sphere), Euclidean clustering, region growing
- **Registration** — ICP (point-to-point, point-to-plane), NDT, feature-based (FPFH + SAC-IA)
- **Surface reconstruction** — Poisson, greedy triangulation, meshing
- **ROS2 integration** — `sensor_msgs/PointCloud2`, `pcl_conversions`, `pcl_ros`
- **Open3D** — Python-friendly alternative, visualization, ML integration

### Exercises
1. Load a point cloud, downsample, remove outliers, segment the ground plane, cluster remaining objects.
2. Register two overlapping point clouds using ICP. Visualize alignment quality.
3. Build a ROS2 node that subscribes to a depth camera PointCloud2, segments objects, publishes bounding boxes.

### AI Prompt
```
"Explain point cloud processing for robotics using PCL in C++ and ROS2:
1) Subscribing to PointCloud2 and converting to PCL format
2) Voxel grid downsampling and statistical outlier removal
3) RANSAC plane segmentation for ground removal
4) Euclidean clustering for object detection
5) Publishing results as markers in RViz
Include complete ROS2 node code."
```

### Resources
- [PCL Tutorials](https://pcl.readthedocs.io/projects/tutorials/en/latest/)
- [Open3D Documentation](http://www.open3d.org/docs/release/)

---

## Submodule 4.2 — Sensor Calibration

### Topics
- **Camera intrinsics** — pinhole model, distortion coefficients, OpenCV calibration
- **Stereo calibration** — rectification, disparity, depth from stereo
- **Camera-LiDAR extrinsic calibration** — checkerboard-based, target-less methods
  - Projection: 3D LiDAR points → 2D camera image
- **IMU calibration** — bias estimation, scale factor, axis alignment
- **Hand-eye calibration** — camera mounted on robot end-effector (AX=XB problem)
- **Time synchronization** — hardware triggers, PTP, software sync, timestamp alignment

### Exercises
1. Calibrate a simulated stereo camera. Generate disparity maps and 3D point clouds.
2. Implement camera-LiDAR calibration using a checkerboard target. Project LiDAR points onto image.
3. Perform hand-eye calibration for a camera mounted on a robot arm (simulated).

---

## Submodule 4.3 — 3D Object Detection & Pose Estimation

### Topics
- **3D bounding box detection** — from point clouds (PointPillars, CenterPoint, VoxelNet)
- **RGB-D object detection** — lifting 2D detections to 3D using depth
- **6-DOF pose estimation** — PnP, ICP-based, learning-based (PoseCNN, FoundationPose)
- **Category-level pose estimation** — NOCS, shape completion
- **Sensor fusion for detection** — early fusion vs. late fusion (camera + LiDAR)
- **Real-time considerations** — TensorRT optimization, model pruning, quantization

### Exercises
1. Implement a pipeline: 2D YOLO detection + depth camera → 3D bounding boxes in `base_link` frame.
2. Use PnP to estimate 6-DOF pose of a known object from RGB image + 3D model.
3. Benchmark inference time of a 3D detector on GPU vs. CPU. Apply TensorRT optimization.

### AI Prompt
```
"Explain 6-DOF object pose estimation for robotic grasping:
1) What is pose estimation (position + orientation)
2) Classical approach: feature matching + PnP
3) Deep learning approach: PoseCNN or FoundationPose overview
4) Integration with ROS2: subscribing to camera, publishing PoseStamped
5) How this feeds into MoveIt2 for grasp planning"
```

---

## Submodule 4.4 — Advanced SLAM

### Topics
- **Visual SLAM** — ORB-SLAM3, LSD-SLAM, RTAB-Map
  - Feature-based vs. direct methods
  - Loop closure, relocalization, map merging
- **LiDAR SLAM** — LOAM, LeGO-LOAM, LIO-SAM, FAST-LIO2
  - LiDAR-inertial odometry for robust performance
- **Visual-Inertial SLAM** — VINS-Fusion, Kimera, ORB-SLAM3 VI mode
- **Dense reconstruction** — TSDF volumes, voxel grids, NeRF-based mapping
- **Multi-session mapping** — saving, loading, and merging maps
- **Comparison framework** — EVO tool for trajectory evaluation (APE, RPE metrics)

### Exercises
1. Run ORB-SLAM3 or RTAB-Map with a simulated stereo camera. Evaluate trajectory accuracy.
2. Set up LIO-SAM with simulated LiDAR + IMU. Compare with 2D SLAM (slam_toolbox).
3. Use EVO to quantitatively compare different SLAM approaches on the same dataset.
4. Implement multi-session mapping: save a map, restart, relocalize in the saved map.

### 🔌 Optional Hardware
- Run visual SLAM on RPi 4 using ESP32-CAM feed — benchmark real-time performance.

---

## Submodule 4.5 — Perception for Manipulation

### Topics
- **Bin picking perception** — instance segmentation in cluttered scenes
- **Transparent/reflective object handling** — multi-modal sensing approaches
- **Deformable object perception** — cloth, cables, food items
- **Scene understanding** — spatial relationships, affordances, occupancy prediction
- **Foundation models for perception** — SAM, Grounding DINO, CLIP for open-vocabulary detection
- **Synthetic data for perception** — training on rendered data (links to Module 5)

### Exercises
1. Use SAM (Segment Anything) + depth to segment objects in a cluttered bin.
2. Implement an affordance prediction pipeline: given an image, predict where to grasp.
3. Generate synthetic training data using Gazebo + domain randomization for a custom detector.

---

## 🏗️ Module 4 Project: 3D Perception Pipeline for Object Manipulation

### Description
Build a complete **3D perception system** that detects, localizes, and estimates poses of objects for robotic grasping.

### Requirements
1. **Sensors:** RGB-D camera (+ optional LiDAR) in simulation
2. **Pipeline:**
   - Point cloud preprocessing (downsample, filter, segment ground)
   - Object detection/segmentation (2D + depth lift or 3D method)
   - 6-DOF pose estimation for at least 3 known objects
   - Publish results as TF frames and/or PoseArray
3. **Integration:** Feeds directly into MoveIt2 (from Module 2) planning scene
4. **Evaluation:** Measure pose estimation accuracy vs. ground truth (from simulator)
5. **ROS2 node architecture:** Lifecycle managed, configurable via parameters

### Deliverables
- [ ] ROS2 perception package with documented pipeline
- [ ] Accuracy metrics: position error (mm), rotation error (degrees) per object
- [ ] Integration demo with MoveIt2 (perception → grasp planning)
- [ ] Performance analysis: FPS, latency breakdown by stage
- [ ] GitHub repo

---

*Previous: [Module 3](module_03_control_systems.md) | Next: [Module 5](module_05_isaac_sim.md)*
