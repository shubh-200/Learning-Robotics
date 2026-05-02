# Module 9 — Capstone Project: Autonomous Intelligent Manipulation System

> **Duration:** 4–6 weeks | **Prerequisites:** All modules (0–8)
> **Purpose:** This is your portfolio centerpiece — the project that demonstrates end-to-end robotics engineering competency. It integrates every skill from the curriculum into a single, polished system.

---

## 🎯 Project Overview

### The System
Build an **autonomous robotic manipulation system** that can:
1. **Perceive** objects in a cluttered environment using 3D perception
2. **Plan** grasps and motions to manipulate objects
3. **Execute** manipulation tasks using learned (RL) or planned (MoveIt2) policies
4. **Navigate** a mobile base to different workstations
5. **Recover** from failures using behavior trees
6. **Run** in a production-quality, containerized, monitored architecture

### Why This Specific Project?
- **Mobile manipulation** is the fastest-growing robotics application (Amazon, Agility, 1X, Figure)
- It naturally integrates every module in the curriculum
- It mirrors real interview system-design questions
- It produces impressive demo videos for your portfolio

---

## 📐 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    BEHAVIOR TREE MANAGER                     │
│                  (Mission orchestration)                      │
├─────────────┬───────────────┬──────────────┬────────────────┤
│  Navigation │  Perception   │ Manipulation │    Safety      │
│   Module    │   Module      │   Module     │   Module       │
├─────────────┼───────────────┼──────────────┼────────────────┤
│  Nav2       │ Point Cloud   │ MoveIt2      │ Watchdog       │
│  AMCL       │ Processing    │ Grasp Plan   │ Diagnostics    │
│  MPC Ctrl   │ 3D Detection  │ RL Policy    │ Safe Stop      │
│  Costmaps   │ Pose Estim.   │ Force Ctrl   │ Heartbeat      │
├─────────────┴───────────────┴──────────────┴────────────────┤
│                     ROS2 MIDDLEWARE                           │
│             (Lifecycle, DDS, TF2, ros2_control)              │
├─────────────────────────────────────────────────────────────┤
│                   SIMULATION LAYER                           │
│              Isaac Sim / Gazebo / MuJoCo                     │
├─────────────────────────────────────────────────────────────┤
│                   INFRASTRUCTURE                             │
│           Docker / CI-CD / Monitoring / Logging              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Requirements Breakdown

### Phase 1: Environment & Robot Setup (Week 1)

#### Tasks
1. **Simulation environment:**
   - Primary: Isaac Sim warehouse with workstations, shelves, objects
   - Fallback: Gazebo with equivalent setup
   - Multiple object types with varied shapes, sizes, materials
2. **Robot model:**
   - Mobile manipulator: mobile base (diff-drive) + 6/7-DOF arm + gripper
   - Options: Fetch, TIAGo, custom mobile base + Franka/UR5
   - Complete URDF with ros2_control integration
   - All sensors: LiDAR, RGB-D camera (on base + wrist), IMU
3. **TF tree:** Complete, following REP-105, verified with `view_frames`

#### Deliverables
- [ ] Simulation world file (USD or SDF)
- [ ] Robot URDF with ros2_control tags
- [ ] Launch files for simulation + visualization
- [ ] TF tree diagram

---

### Phase 2: Perception Pipeline (Week 2)

#### Tasks
1. **Point cloud processing:**
   - Ground plane removal, object clustering, filtering
   - Real-time performance (>5 FPS on point cloud processing)
2. **Object detection:**
   - 3D bounding boxes for objects of interest
   - At least one method: classical (PCL segmentation) or learned (PointPillars/YOLO+depth)
3. **Pose estimation:**
   - 6-DOF pose for graspable objects
   - Publish as TF frames for MoveIt2 planning scene
4. **Scene understanding:**
   - Occupancy of workstations (empty/full)
   - Object inventory tracking

#### Deliverables
- [ ] Perception ROS2 package with lifecycle nodes
- [ ] Accuracy evaluation: pose error vs. ground truth
- [ ] Real-time performance benchmarks
- [ ] Integration test: perception → MoveIt2 planning scene

---

### Phase 3: Manipulation (Week 3)

#### Tasks
1. **Grasp planning:**
   - Generate grasp candidates from perceived object pose
   - Collision-aware approach, grasp, retreat motions
2. **MoveIt2 integration:**
   - Plan and execute grasps in simulation
   - Dynamic planning scene updates from perception
3. **RL-based policy (choose one):**
   - **Option A:** RL policy for the grasp execution (trained in Module 7)
   - **Option B:** RL policy for a specific difficult task (insertion, stacking)
   - Deploy as ROS2 node with real-time inference
4. **Hybrid approach:**
   - Use MoveIt2 for coarse motion planning
   - Use RL policy for fine manipulation (last few cm)
   - Or: MoveIt2 as fallback when RL policy is uncertain

#### Deliverables
- [ ] Manipulation ROS2 package
- [ ] Success rate metrics for each task type
- [ ] RL policy deployment node
- [ ] Integration test: perception → planning → execution

---

### Phase 4: Navigation & Integration (Week 4)

#### Tasks
1. **Navigation:**
   - Nav2 with custom MPC controller (from Module 3) or tuned default controller
   - Navigate between workstations reliably
   - Obstacle avoidance with dynamic obstacles
2. **Behavior tree:**
   - Complete mission BT using BehaviorTree.CPP
   - Mission: navigate to workstation → detect objects → pick → navigate to target → place
   - Error recovery at every level
3. **State estimation:**
   - `robot_localization` fusing odometry + IMU
   - Reliable localization across the environment
4. **Full integration:**
   - All modules communicating via ROS2
   - Lifecycle management for ordered bringup/shutdown
   - End-to-end mission execution

#### Deliverables
- [ ] Integrated launch system for full stack
- [ ] Behavior tree XML + Groot2 visualization
- [ ] End-to-end mission demo (video)
- [ ] Integration test: complete mission in simulation

---

### Phase 5: Production Polish (Weeks 5–6)

#### Tasks
1. **Safety & diagnostics:**
   - Watchdog monitoring all critical nodes
   - Diagnostic publishers for all subsystems
   - Graceful degradation (if perception fails, safe stop; if planning fails, retry)
2. **Containerization:**
   - Multi-stage Docker build for the entire stack
   - docker-compose for easy deployment
   - GPU support for perception and RL inference
3. **CI/CD:**
   - GitHub Actions pipeline: build, lint, unit test, integration test (headless sim)
   - Automated deployment to "robot" container
4. **Monitoring:**
   - Foxglove Studio dashboard or custom web dashboard
   - Mission progress, robot status, sensor health, performance metrics
5. **Documentation:**
   - System architecture document with component diagrams
   - API documentation (Doxygen + Sphinx)
   - Deployment guide (how to run from scratch)
   - Design decisions document (why you chose each approach)
6. **Demo materials:**
   - 5-minute demo video with narration
   - README with badges, screenshots, architecture diagram
   - Performance metrics table

#### Deliverables
- [ ] Production-quality Docker deployment
- [ ] CI/CD pipeline with simulation tests
- [ ] Monitoring dashboard
- [ ] Complete documentation suite
- [ ] Demo video

---

## 🔌 Optional Hardware Extensions

If you want to demonstrate real-world deployment capability:

| Extension | Hardware | Description |
|---|---|---|
| **Edge Perception** | RPi 4 + ESP32-CAM | Run lightweight object detection on RPi 4 with camera stream from ESP32-CAM. Publish detections to ROS2. |
| **Micro-ROS Sensor Node** | ESP32 | Flash micro-ROS on ESP32. Publish IMU/encoder data to the ROS2 graph. Fuse with robot_localization. |
| **Remote Monitoring** | RPi 4 | Run a lightweight ROS2 bridge on RPi 4 that forwards topics to a cloud dashboard. |
| **Physical Demonstrator** | All hardware | Build a small mobile robot with ESP32 + RPi 4 that runs a subset of the stack (navigation only). |

---

## 📊 Evaluation Rubric

| Category | Weight | Criteria |
|---|---|---|
| **System Integration** | 25% | All modules work together, proper ROS2 architecture, lifecycle management |
| **Perception Quality** | 15% | Detection accuracy, pose estimation, real-time performance |
| **Manipulation** | 15% | Grasp success rate, RL policy quality, MoveIt2 integration |
| **Navigation** | 10% | Reliability, obstacle avoidance, MPC/controller performance |
| **Production Quality** | 15% | Docker, CI/CD, safety, diagnostics, monitoring |
| **Documentation** | 10% | Architecture docs, API docs, deployment guide, design decisions |
| **Demo & Presentation** | 10% | Video quality, README, portfolio presentation |

---

## 📌 Tips for Success

1. **Start with integration, not perfection.** Get a basic end-to-end pipeline working first (even with simple perception and scripted manipulation). Then improve each module.

2. **Use your Module projects.** This capstone is designed so that your Module 1–8 projects form the building blocks. You're integrating, not starting from scratch.

3. **Document as you go.** Don't leave documentation for the end. Write design decisions when you make them.

4. **Optimize for demo impact.** A smooth 5-minute demo video with narration is worth more than a perfect codebase no one can see.

5. **Show failure handling.** Interviewers are MORE impressed by graceful failure recovery than by 100% success rates. Show your system handling errors.

6. **Version your experiments.** Use Git tags for each phase. This lets you show progression.

---

## 🎓 After the Capstone

With this project complete, you will have:

- ✅ **8+ portfolio-grade robotics projects** on GitHub
- ✅ **A complete autonomous manipulation system** integrating perception, planning, control, and learning
- ✅ **Production engineering skills** (Docker, CI/CD, monitoring, safety)
- ✅ **Hands-on experience** with the exact tools companies use (ROS2, MoveIt2, Nav2, Isaac Sim, MuJoCo)
- ✅ **Interview readiness** with system design practice and domain knowledge
- ✅ **Demo materials** that make recruiters say "let's talk to this person"

**You are ready to apply for robotics software engineer roles.**

---

*Previous: [Module 8](module_08_production_systems.md) | Back to [Curriculum Overview](../README.md)*
