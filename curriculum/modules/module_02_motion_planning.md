# Module 2 — Motion Planning & Manipulation

> **Duration:** 3–4 weeks | **Prerequisites:** Module 1
> **Why this matters:** Manipulation is the #1 growth area in robotics. Every warehouse, factory, and home robot needs to plan and execute motions safely. MoveIt2 proficiency is a direct resume differentiator.

---

## Learning Objectives
- Understand configuration space, workspace, and planning problem formulation
- Implement forward/inverse kinematics for serial manipulators
- Use MoveIt2 for motion planning, collision checking, and trajectory execution
- Write custom planners using OMPL sampling-based algorithms
- Design grasp strategies and integrate with perception

---

## Submodule 2.1 — Kinematics Foundations

### Topics
- **Rigid body transformations** — rotation matrices, Euler angles, quaternions, homogeneous transforms
- **Forward kinematics** — DH parameters, product of exponentials
- **Inverse kinematics** — analytical vs. numerical (Jacobian pseudo-inverse, damped least-squares)
  - Singularities: what they are, how to detect, how to handle
  - Redundancy resolution for 7+ DOF arms
- **Jacobian** — geometric vs. analytical, velocity kinematics, force/torque mapping
- **Workspace analysis** — reachable vs. dexterous workspace

### Exercises
1. Implement FK for a 6-DOF arm using DH parameters from scratch in Python (no libraries).
2. Implement numerical IK using Jacobian pseudo-inverse. Test with reachable and unreachable targets.
3. Visualize the reachable workspace of a robot arm using random sampling.

### AI Prompt
```
"Derive the forward kinematics of a 6-DOF robotic arm using DH parameters step 
by step. Then show how to implement numerical inverse kinematics using the 
Jacobian pseudo-inverse method in Python with NumPy. Explain singularities and 
how damped least-squares helps."
```

### Resources
- *Modern Robotics* by Lynch & Park (free textbook + Coursera course)
- *Robotics: Modelling, Planning and Control* by Siciliano et al.
- [Peter Corke's Robotics Toolbox](https://petercorke.com/toolboxes/robotics-toolbox/)

---

## Submodule 2.2 — Motion Planning Algorithms

### Topics
- **Configuration Space (C-space)** — free space, obstacle space, dimensionality
- **Graph-based planners** — A*, D*, Dijkstra in configuration space
- **Sampling-based planners (the industry standard)**
  - **RRT** — rapidly-exploring random trees, bias toward goal
  - **RRT*** — asymptotically optimal, rewiring
  - **PRM** — probabilistic roadmaps, multi-query planning
  - **BIT*** — batch informed trees
  - **Informed RRT*** — ellipsoidal sampling after initial solution
- **Optimization-based planning**
  - **CHOMP** — covariant Hamiltonian optimization
  - **TrajOpt** — sequential convex optimization
  - **STOMP** — stochastic trajectory optimization
- **Trajectory optimization** — time parameterization, velocity/acceleration limits
  - Time-Optimal Path Parameterization (TOPP-RA)
- **Planning under constraints** — orientation, end-effector path, joint limits

### Exercises
1. Implement RRT and RRT* from scratch in 2D. Visualize the tree growth.
2. Compare planning time and path quality for RRT, RRT*, PRM, and BIT* on the same problem.
3. Implement TOPP-RA time parameterization for a given joint-space path.

### Resources
- [OMPL Primer](https://ompl.kavrakilab.org/OMPL_Primer.pdf)
- *Planning Algorithms* by Steven LaValle (free online)
- [Motion Planning course — Russ Tedrake, MIT](https://manipulation.csail.mit.edu/)

---

## Submodule 2.3 — MoveIt2 Mastery

### Topics
- **Architecture** — `move_group`, planning pipeline, kinematics plugins, controller interface
- **Setup Assistant** — generating MoveIt config for your robot (SRDF, kinematics.yaml)
- **Planning pipeline** — OMPL integration, pilz industrial planner, custom planners
- **Planning scene** — collision objects, attached objects, allowed collision matrix (ACM)
  - Adding objects from perception (point clouds, meshes)
  - Scene monitoring and updating
- **Move Group Interface** — C++ and Python APIs
  - Joint-space goals, pose goals, named targets
  - Path constraints (orientation, position, joint)
  - Cartesian path planning
- **Servo** — real-time teleoperation with MoveIt Servo, singularity avoidance
- **Pick and Place pipeline** — grasp generation, approach/retreat motions
- **Integration with ros2_control** — follow_joint_trajectory action interface

### Exercises
1. Set up MoveIt2 for a Panda arm (or UR5) in Gazebo. Plan and execute joint and Cartesian motions.
2. Add collision objects to the planning scene. Plan around obstacles dynamically.
3. Implement a pick-and-place pipeline: detect object → plan approach → grasp → lift → place.
4. Use MoveIt Servo for real-time joystick/keyboard teleoperation.

### AI Prompt
```
"Walk me through setting up MoveIt2 for a UR5e robot arm in ROS2 Humble/Jazzy:
1) Using MoveIt Setup Assistant to generate config
2) Writing a C++ node that plans and executes a pick-and-place sequence
3) Adding collision objects to the planning scene from sensor data
4) Tuning OMPL planners for faster solutions
Include complete code and launch file examples."
```

---

## Submodule 2.4 — Grasping & Manipulation

### Topics
- **Grasp theory** — force closure, form closure, grasp quality metrics (GWS)
- **Grasp planning** — antipodal grasps, surface normals, grasp pose generation
  - Analytical grasp planning
  - Data-driven grasp planning (GraspNet, Contact-GraspNet)
- **Gripper types** — parallel jaw, suction, soft, dexterous hands
- **Manipulation primitives** — pick, place, push, pull, insert, handover
- **Task and Motion Planning (TAMP)** — combining symbolic planning with motion planning
- **Contact-rich manipulation** — peg-in-hole, assembly tasks, force control

### Exercises
1. Generate antipodal grasp candidates for objects detected in a point cloud.
2. Implement a complete pick-and-place pipeline with error recovery (failed grasp → retry).
3. Design a simple TAMP system: given a goal state of objects, plan the sequence of picks and places.

---

## Submodule 2.5 — Dynamics & Trajectory Execution

### Topics
- **Robot dynamics** — Newton-Euler, Lagrangian formulation
- **Computed torque control** — feedforward + feedback for trajectory tracking
- **Impedance/admittance control** — compliant behavior for safe interaction
- **Trajectory representations** — joint polynomials, splines, B-splines, minimum-jerk
- **Real-time trajectory execution** — interpolation, real-time constraints

### Exercises
1. Derive the dynamics of a 2-DOF planar arm using Lagrangian mechanics.
2. Implement impedance control: the robot arm yields when pushed (simulated).
3. Generate and execute a minimum-jerk trajectory for a point-to-point motion.

---

## 🏗️ Module 2 Project: Intelligent Pick-and-Place System

### Description
Build a complete **vision-guided pick-and-place system** in simulation.

### Requirements
1. **Robot:** 6/7-DOF arm (Panda, UR5, or Kinova) with parallel-jaw gripper in Gazebo
2. **Perception:** Detect objects on a table using depth camera (simple color/shape-based is OK for now)
3. **Planning:** MoveIt2 with:
   - Collision-aware planning
   - Cartesian approach/retreat motions
   - At least 2 different OMPL planners compared
4. **Execution:** Full pipeline: detect → plan grasp → approach → grasp → lift → move → place
5. **Error handling:** Failed grasp detection, re-planning, collision recovery
6. **Metrics:** Log planning time, success rate, cycle time per pick-place

### Deliverables
- [ ] ROS2 workspace with MoveIt2 configuration
- [ ] Working pick-and-place demo (video)
- [ ] Performance comparison of planners (table/chart)
- [ ] Design document explaining grasp strategy
- [ ] GitHub repo with CI

---

*Previous: [Module 1](module_01_ros2_advanced.md) | Next: [Module 3](module_03_control_systems.md)*
