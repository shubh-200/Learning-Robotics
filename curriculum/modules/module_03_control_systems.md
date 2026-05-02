# Module 3 — Control Systems for Robotics

> **Duration:** 2–3 weeks | **Prerequisites:** Module 1
> **Why this matters:** Control is what makes robots move *correctly*. A motion plan is useless if the robot can't track it. MPC and state estimation appear in nearly every senior-level robotics job posting.

---

## Learning Objectives
- Implement and tune PID controllers for robotic actuators
- Design state estimators using Kalman filters and sensor fusion
- Understand and implement Model Predictive Control (MPC)
- Apply control theory to real robotic systems (diff-drive, arms, quadrotors)

---

## Submodule 3.1 — Classical Control Theory Review

### Topics
- **System modeling** — transfer functions, state-space representations
- **Stability** — Routh-Hurwitz, Nyquist, Bode plots, root locus
- **PID control** — P, PI, PD, PID, tuning methods (Ziegler-Nichols, Cohen-Coon)
  - Anti-windup, derivative filtering, output saturation
  - Cascaded PID (position → velocity → current)
- **Feedforward control** — combining FF + FB for better tracking
- **Frequency domain** — bandwidth, phase margin, gain margin, disturbance rejection

### Exercises
1. Model a DC motor as a transfer function. Design a PID controller, tune it, and simulate step response.
2. Implement cascaded PID (position + velocity loops) for a simulated joint. Compare with single-loop.
3. Analyze frequency response: determine the maximum achievable bandwidth for a given actuator.

### AI Prompt
```
"Explain PID control for robotics with practical examples:
1) How to model a DC motor + gearbox as a transfer function
2) Step-by-step Ziegler-Nichols tuning
3) Anti-windup implementation in C++
4) Cascaded PID for position-velocity control
Include Python simulation code using scipy.signal."
```

---

## Submodule 3.2 — State Estimation & Kalman Filtering

### Topics
- **Why state estimation?** — sensors are noisy, incomplete, and delayed
- **Kalman Filter (KF)** — linear systems, predict-update cycle, derivation from Bayesian inference
- **Extended Kalman Filter (EKF)** — nonlinear systems, Jacobian linearization
  - EKF for robot localization (pose estimation from odometry + landmarks)
- **Unscented Kalman Filter (UKF)** — sigma points, better for highly nonlinear systems
- **Complementary filter** — simple sensor fusion for IMU (gyro + accelerometer)
- **Particle filter** — non-Gaussian, multi-modal distributions (used in AMCL)

### Exercises
1. Implement a KF for 1D position estimation from noisy position + velocity sensors.
2. Implement an EKF for 2D robot localization fusing odometry + GPS (simulated).
3. Implement a complementary filter for IMU orientation estimation. Compare with EKF.
4. Tune the AMCL particle filter in Nav2 — understand the parameters.

### Resources
- *Probabilistic Robotics* by Thrun, Burgard, Fox — THE reference
- [Kalman Filter Tutorial — bzarg.com](https://www.bzarg.com/p/how-a-kalman-filter-works-in-pictures/)
- [robot_localization ROS2 package](https://docs.ros.org/en/jazzy/p/robot_localization/)

---

## Submodule 3.3 — Sensor Fusion

### Topics
- **Multi-sensor fusion** — why single sensors aren't enough
- **`robot_localization` package** — EKF/UKF node for fusing odometry, IMU, GPS, visual odometry
  - Configuration: which sensors, which fields (x, y, yaw, vx, vyaw, etc.)
  - Two-EKF setup: `odom` frame EKF + `map` frame EKF
- **IMU preprocessing** — bias estimation, gravity compensation, coordinate alignment
- **Wheel odometry** — calibration, slip detection, error modeling
- **Visual-inertial odometry (VIO)** — camera + IMU fusion, ORB-SLAM3, VINS-Fusion
- **Time synchronization** — `message_filters`, `ApproximateTime`, hardware timestamps

### Exercises
1. Configure `robot_localization` to fuse wheel odometry + IMU for a diff-drive robot.
2. Implement the two-EKF setup (odom + map frames) and test with AMCL corrections.
3. Add simulated GPS and fuse all three sensors. Evaluate accuracy vs. ground truth.

### 🔌 Optional Hardware
- Fuse IMU data from ESP32 (MPU6050) with wheel odometry on RPi 4 using `robot_localization`.

---

## Submodule 3.4 — Model Predictive Control (MPC)

### Topics
- **MPC fundamentals** — predict, optimize, execute, repeat
  - Cost function design: tracking error, control effort, smoothness
  - Constraints: actuator limits, state bounds, obstacle avoidance
  - Horizon length and discretization
- **Linear MPC** — QP formulation, fast solvers (OSQP, qpOASES)
- **Nonlinear MPC (NMPC)** — for non-trivial dynamics, CasADi + IPOPT
- **MPC for mobile robots** — trajectory tracking, obstacle avoidance
- **MPC for manipulators** — joint-space vs. task-space MPC
- **MPC vs. PID** — when to use which, computational considerations
- **MPPI Controller** — sampling-based MPC used in Nav2

### Exercises
1. Implement linear MPC for a simple double-integrator system in Python.
2. Implement NMPC for a diff-drive robot following a reference trajectory. Use CasADi.
3. Compare PID vs. MPC for trajectory tracking. Quantify tracking error, control smoothness.
4. Study Nav2's MPPI controller — understand its parameters and tune it.

### AI Prompt
```
"Explain Model Predictive Control for a differential-drive robot:
1) System dynamics model (state: x, y, theta; input: v, omega)
2) Cost function formulation for trajectory tracking
3) Constraint handling (velocity limits, acceleration limits)
4) Implementation using CasADi and IPOPT in Python
5) Comparison with PID control
Include complete working Python code."
```

### Resources
- [CasADi documentation](https://web.casadi.org/)
- *Model Predictive Control* by Rawlings, Mayne, Diehl

---

## Submodule 3.5 — Advanced Control Topics

### Topics
- **Impedance/Admittance control** — compliant robot behavior for human interaction
- **Whole-body control** — for mobile manipulators, balancing + manipulation
- **Adaptive control** — handling unknown/changing parameters
- **Robust control** — H∞, structured uncertainty
- **Control in ROS2** — ros2_control real-time loop, RT kernel, `realtime_tools`

### Exercises
1. Implement impedance control for a 1-DOF system: the "virtual spring-damper."
2. Design a whole-body controller for a mobile manipulator (base velocity + arm joints).
3. Explore the real-time capabilities of ros2_control: measure jitter, understand RT priorities.

---

## 🏗️ Module 3 Project: Sensor-Fused Autonomous Navigation with MPC

### Description
Build a robot that navigates using **MPC-based trajectory tracking** with **multi-sensor fusion**.

### Requirements
1. **Robot:** Diff-drive robot in Gazebo with IMU, wheel encoders, LiDAR, (optional) GPS
2. **State Estimation:** `robot_localization` EKF fusing odometry + IMU (+ GPS if added)
3. **Controller:** Custom MPC node (Python with CasADi, or C++) that:
   - Receives reference trajectory from Nav2 planner
   - Optimizes control inputs considering dynamics constraints
   - Publishes cmd_vel to the robot
4. **Comparison:** Side-by-side comparison with Nav2's default DWB controller
   - Tracking error plots, control smoothness, computational load
5. **Visualization:** RViz showing predicted MPC trajectory at each timestep

### Deliverables
- [ ] ROS2 package with MPC controller node
- [ ] `robot_localization` configuration with tuned parameters
- [ ] Comparison report: MPC vs DWB (plots, metrics)
- [ ] GitHub repo with documentation

---

*Previous: [Module 2](module_02_motion_planning.md) | Next: [Module 4](module_04_perception.md)*
