# Module 1 — Intermediate & Advanced ROS2

> **Duration:** 3–4 weeks | **Prerequisites:** Module 0, Basic ROS2
> **Why this matters:** ROS2 is the *lingua franca* of robotics. Advanced fluency separates hobbyists from engineers.

---

## Learning Objectives
- Design lifecycle nodes for production robotics
- Configure DDS middleware and QoS profiles for real-time performance
- Build composable node architectures for zero-copy communication
- Implement Nav2 with custom plugins
- Use ros2_control for hardware abstraction

---

## Submodule 1.1 — ROS2 Architecture Deep Dive

### Topics
- **DDS middleware** — CycloneDDS vs. FastDDS, discovery (SPDP/SEDP), `ROS_DOMAIN_ID`
- **QoS profiles** — Reliability, Durability, History, Deadline, Liveliness, Lifespan
  - Common presets: sensor data, reliable command, parameter events
  - Debugging mismatches: `ros2 doctor`, `ros2 topic info -v`
- **Network config** — multicast issues, `ROS_DISCOVERY_SERVER`, cross-network communication

### Exercises
1. Set up two Docker containers communicating via custom CycloneDDS config.
2. Create nodes with deliberately incompatible QoS — debug and fix.
3. Configure discovery server and test node discovery without multicast.

### AI Prompt
```
"Explain ROS2 DDS QoS profiles in depth. For each policy (reliability, durability, 
history, deadline, liveliness, lifespan): what it controls, when to use each setting, 
C++ code example, and what happens with incompatible settings."
```

---

## Submodule 1.2 — Lifecycle (Managed) Nodes

### Topics
- Node states: Unconfigured → Inactive → Active → Finalized
- Transition callbacks: `on_configure()`, `on_activate()`, `on_deactivate()`, `on_cleanup()`
- `lifecycle_manager` for orchestrating multi-node bringup
- Error handling and recovery strategies
- Launch integration with lifecycle events

### Exercises
1. Convert a publisher/subscriber pair into lifecycle nodes with proper resource management.
2. Build a lifecycle manager bringing up 5 nodes in dependency order.
3. Implement retry logic: if sensor node fails to activate, retry 3x then enter degraded mode.

---

## Submodule 1.3 — Custom Interfaces & Actions

### Topics
- Custom messages (.msg) — nested types, arrays, constants
- Custom services (.srv) — request/response patterns
- **Actions (.action)** — goal/result/feedback, preemption, multi-goal handling
- Interface design best practices — versioning, backward compatibility

### Exercises
1. Design a "scan and map" action: goal = area, feedback = progress %, result = occupancy grid.
2. Implement an action server with priority-based goal preemption.
3. Create a versioned message package used by multiple downstream packages.

---

## Submodule 1.4 — Composable Nodes & Executors

### Topics
- Component nodes — `rclcpp_components`, `ComposableNodeContainer`, runtime composition
- Zero-copy intra-process communication with `unique_ptr`
- Executors — `SingleThreaded`, `MultiThreaded`, `StaticSingleThreaded`
- Callback groups: `MutuallyExclusive` vs. `Reentrant`
- Real-time considerations, avoiding deadlocks

### Exercises
1. Create 3 component nodes with zero-copy transport. Benchmark vs. inter-process.
2. Design a multi-threaded executor where a 1kHz control loop coexists with low-priority logging.
3. Profile CPU/memory difference between composed vs. separate process nodes.

---

## Submodule 1.5 — TF2 Transforms (Mastery)

### Topics
- Frame conventions (REP-105): map → odom → base_link → sensors
- Static vs. dynamic transforms, time travel, extrapolation vs. interpolation
- Multi-robot TF with namespacing
- Debugging: `tf2_echo`, `view_frames`, `tf2_monitor`

### Exercises
1. Set up complete TF tree for mobile robot with base, wheels, lidar, camera, IMU.
2. Transform a point cloud from `camera_frame` to `base_link` with proper error handling.
3. Debug a deliberately broken TF tree (cycles, stale timestamps, wrong parent).

---

## Submodule 1.6 — Nav2 Deep Dive

### Topics
- Full stack: costmap → planner → controller → recovery → BT navigator
- Planners: NavFn, Smac, Theta* | Controllers: DWB, Regulated Pure Pursuit, MPPI
- Costmap 2D layers: static, inflation, obstacle, voxel — plugin architecture
- Custom plugins — your own planner, controller, or costmap layer
- Waypoint following, multi-robot navigation, GPS navigation

### Exercises
1. Set up complete Nav2 stack with custom robot. Navigate complex environments.
2. Write a custom costmap layer for "no-go zones" loaded from YAML.
3. Implement waypoint following with task execution (photo, data recording) at each point.
4. Compare 3 planner/controller combos and document performance characteristics.

### 🔌 Optional Hardware
- Deploy Nav2 on RPi 4 with lightweight lidar setup.

---

## Submodule 1.7 — ros2_control Framework

### Topics
- Architecture: `hardware_interface`, `controller_manager`, `controller_interface`
- Hardware interfaces: `SystemInterface`, `SensorInterface`, `ActuatorInterface`
- Controllers: `JointTrajectoryController`, `DiffDriveController`, custom controllers
- URDF integration: `<ros2_control>` tag, hardware plugin loading
- Simulation: `gz_ros2_control` integration

### Exercises
1. Set up ros2_control for a simulated diff-drive robot.
2. Create a custom `SystemInterface` for a 2-DOF robot arm.
3. Implement custom joint-space PD controller with gravity compensation.

### AI Prompt
```
"Explain ros2_control: hardware_interface, controller_manager, controllers.
How to write a custom SystemInterface for a 6-DOF arm. How command/state 
interfaces work with URDF <ros2_control> tag. Include complete working example."
```

---

## Submodule 1.8 — Testing & Debugging

### Topics
- Unit testing: `ament_cmake_gtest`, `ament_cmake_pytest`
- Integration testing: `launch_testing`
- Debugging: `ros2 doctor`, `rqt_graph`, `rqt_console`, `ros2 topic hz/bw/delay`
- Performance profiling, memory debugging (Valgrind)
- Bag recording & playback: `ros2 bag`, `mcap`

### Exercises
1. Write a `launch_testing` test verifying Nav2 reaches a goal within 30s.
2. Create a system test that validates sensor data flows through entire pipeline.
3. Record a navigation run, replay to debug a planning failure.

---

## 🏗️ Module 1 Project: Autonomous Multi-Waypoint Inspector Bot

### Description
Build a **simulated inspection robot** that navigates a facility, performing tasks at each waypoint.

### Requirements
1. Custom URDF with diff-drive, LiDAR, camera + ros2_control integration
2. Full Nav2 stack with tuned params + custom costmap layer
3. All nodes as lifecycle managed, at least 2 composed, custom action server
4. Integration test with `launch_testing`, CI pipeline, documented QoS choices

### Architecture
```
Lifecycle Manager
├── Map Server (lifecycle)
├── Nav2 Stack (lifecycle)
├── Inspector Node (lifecycle, action server)
│   ├── Camera capture + Anomaly detection
└── Mission Manager (lifecycle, action client)
    └── Waypoint sequence
```

### Deliverables
- [ ] GitHub repo with complete ROS2 workspace
- [ ] Docker setup for one-command demo
- [ ] Recorded ros2 bag of complete inspection mission
- [ ] Architecture diagram + design doc
- [ ] Demo video

---

*Previous: [Module 0](module_00_foundations.md) | Next: [Module 2](module_02_motion_planning.md)*
