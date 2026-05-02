# Module 5 — Simulators: NVIDIA Isaac Sim

> **Duration:** 3–4 weeks | **Prerequisites:** Modules 1, 2, 3, 4
> **Why this matters:** Isaac Sim is NVIDIA's flagship robotics simulator built on Omniverse. It's the industry leader for photorealistic simulation, synthetic data generation, and digital twins. Proficiency here signals you're ready for cutting-edge robotics roles.

---

## Learning Objectives
- Set up and navigate NVIDIA Isaac Sim and Omniverse
- Import robots via URDF and configure them in Isaac Sim
- Bridge Isaac Sim with ROS2 for seamless data flow
- Generate synthetic training data using Isaac Replicator
- Build digital twin environments for testing robotics stacks
- Use Isaac ROS for GPU-accelerated perception on the edge

---

## Submodule 5.1 — Isaac Sim Fundamentals

### Topics
- **Omniverse platform** — what it is, OpenUSD format, Nucleus for asset management
- **Installation** — Omniverse Launcher, system requirements (NVIDIA RTX GPU required)
- **Isaac Sim UI** — viewport, stage, property panel, timeline, physics
- **USD basics** — prims, schemas, layers, composition arcs
  - Why USD matters for robotics (standardized scene description)
- **Physics simulation** — PhysX 5 integration, rigid body dynamics, articulated bodies
- **Environments** — warehouse, office, outdoor — pre-built environments

### Exercises
1. Install Isaac Sim via Omniverse Launcher. Explore the UI, load sample scenes.
2. Create a simple USD scene: ground plane, table, objects with physics properties.
3. Run a pre-built robot demo (e.g., Carter or Franka) and observe the physics.

### Resources
- [Isaac Sim Documentation](https://docs.omniverse.nvidia.com/isaacsim/latest/)
- [NVIDIA Omniverse Learning](https://www.nvidia.com/en-us/omniverse/learn/)

---

## Submodule 5.2 — Robot Import & Configuration

### Topics
- **URDF Importer** — converting URDF to USD, joint configurations, mass/inertia
- **Articulation API** — joints, drives, position/velocity control
- **Sensor simulation** — cameras (RGB, depth, segmentation), RTX LiDAR, IMU, contact sensors
  - Camera parameters: resolution, FOV, noise models
  - RTX LiDAR: scan patterns, range, intensity
- **Material & visual properties** — PBR materials for photorealistic rendering
- **Terrain generation** — procedural terrains for outdoor navigation

### Exercises
1. Import your robot URDF from Module 1/2 into Isaac Sim. Verify joint limits and dynamics.
2. Add an RGB-D camera and LiDAR to your robot. Visualize sensor data in Isaac Sim.
3. Create a warehouse environment with shelves, objects, and realistic lighting.

### AI Prompt
```
"Walk me through importing a robot URDF into NVIDIA Isaac Sim:
1) Preparing the URDF (fixing common issues)
2) Using the URDF Importer tool
3) Configuring joint drives (position vs velocity control)
4) Adding sensors (camera, lidar) to the robot
5) Testing with simple joint commands via Python scripting
Include step-by-step instructions."
```

---

## Submodule 5.3 — ROS2 Bridge

### Topics
- **ROS2 Bridge architecture** — how Isaac Sim communicates with ROS2
- **OmniGraph** — visual programming for connecting sensors/actuators to ROS2 topics
  - ROS2 Publish/Subscribe nodes
  - Clock, TF, JointState publishers
- **Python scripting** — `rclpy` nodes within Isaac Sim for advanced control
- **Supported message types** — sensor_msgs, geometry_msgs, nav_msgs, control_msgs
- **Performance** — latency considerations, publish rates, QoS matching

### Exercises
1. Set up the ROS2 Bridge. Publish camera images and LiDAR data to ROS2 topics. Visualize in RViz.
2. Drive a robot from ROS2: publish `cmd_vel` from a teleop node to move the robot in Isaac Sim.
3. Run the full TF tree from Isaac Sim → ROS2. Verify frame relationships in `tf2_echo`.
4. Implement a complete odometry pipeline: wheel encoders → odometry topic.

---

## Submodule 5.4 — Nav2 & MoveIt2 Integration

### Topics
- **Nav2 in Isaac Sim** — costmap from simulated LiDAR, planning and control
  - Replacing Gazebo with Isaac Sim as the simulation backend
- **MoveIt2 in Isaac Sim** — manipulation planning with photorealistic rendering
  - Follow Joint Trajectory action → Isaac Sim articulation
- **Multi-robot simulation** — multiple robots with separate namespaces
- **Performance comparison** — Isaac Sim vs. Gazebo for different use cases

### Exercises
1. Run Nav2 stack with Isaac Sim as backend. Navigate a robot through a warehouse.
2. Set up MoveIt2 with a Franka Panda in Isaac Sim. Execute pick-and-place.
3. Simulate 3 robots in the same environment, each with independent Nav2 stacks.

---

## Submodule 5.5 — Synthetic Data Generation (Isaac Replicator)

### Topics
- **Why synthetic data?** — training perception models without real-world data collection
- **Isaac Replicator** — randomized scene generation, automatic annotation
  - Domain Randomization: pose, texture, lighting, camera viewpoint, distractors
  - Output formats: COCO, KITTI, Pascal VOC, custom
- **Perception pipeline** — training object detectors on synthetic data
- **Sim-to-real gap** — domain randomization strategies to minimize it
- **Automated dataset generation** — scripting large-scale dataset creation

### Exercises
1. Generate a synthetic dataset of 10,000 images for object detection with automatic bounding box annotations.
2. Apply domain randomization: vary lighting, textures, object poses, camera positions.
3. Train a YOLO model on synthetic data. Test on real-world images (evaluate sim-to-real gap).
4. Compare detection accuracy: model trained on synthetic only vs. synthetic + real fine-tuning.

### AI Prompt
```
"Explain synthetic data generation for robotics using NVIDIA Isaac Replicator:
1) Why synthetic data is valuable for perception training
2) Setting up a scene with objects and randomizers
3) Domain randomization: what to randomize and why
4) Generating COCO-format annotations automatically
5) Best practices for minimizing the sim-to-real gap
Include Python scripting examples for Isaac Sim."
```

---

## Submodule 5.6 — Isaac ROS & GPU-Accelerated Perception

### Topics
- **Isaac ROS** — NVIDIA's GPU-accelerated ROS2 packages
  - `isaac_ros_visual_slam` — GPU-accelerated visual SLAM
  - `isaac_ros_dnn_inference` — TensorRT-based inference
  - `isaac_ros_apriltag` — GPU-accelerated fiducial detection
  - `isaac_ros_depth_segmentation` — depth-based segmentation
- **NITROS** — NVIDIA's zero-copy GPU transport for ROS2
- **Deployment on Jetson** — running Isaac ROS on NVIDIA Jetson Orin
- **Performance benchmarking** — CPU vs. GPU perception pipeline comparison

### Exercises
1. Set up `isaac_ros_visual_slam` and compare with ORB-SLAM3 (performance, accuracy).
2. Run DNN inference using `isaac_ros_dnn_inference` with TensorRT for object detection.
3. Benchmark perception pipeline: CPU-only vs. Isaac ROS GPU-accelerated.

---

## 🏗️ Module 5 Project: Digital Twin Warehouse with Autonomous Robots

### Description
Build a **photorealistic digital twin** of a warehouse in Isaac Sim with autonomous mobile robots.

### Requirements
1. **Environment:** Realistic warehouse with shelves, products, aisles, proper lighting
2. **Robot:** Mobile robot with LiDAR + RGB-D camera, imported via URDF
3. **ROS2 Integration:**
   - Full Nav2 stack navigating via Isaac Sim sensor data
   - Perception pipeline processing Isaac Sim camera/LiDAR data
4. **Synthetic Data:** Generate a labeled dataset for product detection using Replicator
5. **Multi-robot:** At least 2 robots operating concurrently
6. **Documentation:** Compare Isaac Sim workflow vs. your previous Gazebo experience

### Deliverables
- [ ] Isaac Sim project files (USD scenes)
- [ ] ROS2 workspace with bridge configuration
- [ ] Synthetic dataset (1000+ images with annotations)
- [ ] Demo video showing navigation + perception
- [ ] Comparison document: Isaac Sim vs. Gazebo

---

*Previous: [Module 4](module_04_perception.md) | Next: [Module 6](module_06_mujoco.md)*
