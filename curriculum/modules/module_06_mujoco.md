# Module 6 — Simulators: MuJoCo & Physics Engines

> **Prerequisites:** Modules 2, 3
> **Why this matters:** MuJoCo is the gold standard for high-fidelity physics simulation in RL research. It's used by DeepMind, OpenAI, and virtually every robotics RL lab. Understanding contact dynamics and fast physics simulation is critical for sim-to-real work.

---

## Learning Objectives
- Build robot models in MJCF format for MuJoCo
- Understand contact dynamics and MuJoCo's physics model
- Use MuJoCo for benchmarking controllers and motion planners
- Leverage MuJoCo Playground for GPU-accelerated training
- Compare MuJoCo, Gazebo, Isaac Sim, and PyBullet for different use cases

---

## Submodule 6.1 — MuJoCo Fundamentals

### Topics
- **What is MuJoCo?** — multi-joint dynamics with contact, by DeepMind
  - History: Emo Todorov → Roboti → DeepMind (now free and open-source)
- **Installation** — `pip install mujoco`, standalone viewer, Python bindings
- **MJCF format** — XML model specification
  - Bodies, joints, geoms, sites, actuators, sensors, tendons
  - Compiler settings, solver options, timestep selection
- **Simulation loop** — `mj_step`, `mj_forward`, state representation (`qpos`, `qvel`, `ctrl`)
- **Viewer & visualization** — interactive viewer, camera control, rendering
- **Contact model** — soft contacts, condim, friction cone, solref/solimp parameters

### Exercises
1. Install MuJoCo. Load the humanoid model. Explore the viewer and simulation controls.
2. Build a simple robot arm (3 DOF) from scratch in MJCF XML. Add actuators and sensors.
3. Write a Python script that runs a simulation loop, applies torques, and logs joint positions.
4. Experiment with contact parameters: change friction, stiffness, damping. Observe effects.

### AI Prompt
```
"Explain MuJoCo MJCF format for building robot models:
1) XML structure: worldbody, body, joint, geom, actuator, sensor
2) How to define a 3-DOF planar robot arm with revolute joints
3) Actuator types: motor, position, velocity servos
4) Contact model: friction, solref, solimp parameters
5) Running the simulation in Python with mujoco package
Include a complete MJCF file and Python simulation script."
```

### Resources
- [MuJoCo Documentation](https://mujoco.readthedocs.io/)
- [MuJoCo GitHub](https://github.com/google-deepmind/mujoco)
- [MuJoCo XML Reference](https://mujoco.readthedocs.io/en/stable/XMLreference.html)

---

## Submodule 6.2 — Robot Modeling in MuJoCo

### Topics
- **Complex robots** — importing URDF, converting to MJCF, fixing common issues
- **Actuator modeling** — DC motor model, PD servos, torque limits, gear ratios
- **Sensor simulation** — joint sensors, force/torque sensors, accelerometers, cameras
- **MuJoCo rendering** — offscreen rendering for vision-based RL, camera placement
- **Asset management** — meshes, textures, materials for complex robot models
- **Model validation** — comparing simulated dynamics with real robot data

### Exercises
1. Import a URDF (e.g., UR5, Franka Panda) into MuJoCo. Fix any conversion issues.
2. Add realistic actuator models (with torque limits, damping, gear ratios) to a robot arm.
3. Set up camera rendering for vision-based observation (RGB, depth) in a manipulation scene.
4. Create a tabletop manipulation scene with a robot arm, table, and graspable objects.

---

## Submodule 6.3 — MuJoCo for Controller Development

### Topics
- **PD control in MuJoCo** — position/velocity servos, tuning gains
- **Inverse dynamics** — computing required torques for a desired motion
- **Operational space control** — task-space control using MuJoCo's Jacobian computation
- **Model-based control** — using MuJoCo's analytical derivatives for MPC
- **Contact-rich control** — pushing, pivoting, insertion tasks
- **Benchmarking** — comparing controller performance across physics engines

### Exercises
1. Implement operational space control: control end-effector position while the arm is redundant.
2. Use MuJoCo's inverse dynamics to compute feedforward torques for a trajectory.
3. Implement a pushing task: push a box to a target location using force control.
4. Compare PD control performance in MuJoCo vs. Gazebo for the same robot model.

---

## Submodule 6.4 — MuJoCo Playground & GPU Acceleration

### Topics
- **MuJoCo Playground** — open-source GPU-accelerated robot learning framework
  - Parallel simulation for fast RL training
  - Pre-built tasks: locomotion, manipulation, dexterous hand
- **MJX** — JAX-based GPU acceleration for MuJoCo
  - `mjx.put_model`, `mjx.step`, JIT compilation
  - Batched simulation: thousands of environments in parallel
- **Integration with RL libraries** — Brax, Stable Baselines3, CleanRL
- **Custom tasks** — defining reward functions, observations, resets
- **Performance** — MuJoCo CPU vs. MJX GPU, scaling with batch size

### Exercises
1. Run MuJoCo Playground Colab notebooks for locomotion and manipulation tasks.
2. Set up MJX: run 1000 parallel humanoid simulations on GPU. Measure speedup vs. CPU.
3. Define a custom task in MuJoCo Playground (e.g., reaching, pushing). Train with PPO.
4. Benchmark: time to collect 1M environment steps on CPU vs. GPU.

### Resources
- [MuJoCo Playground](https://playground.mujoco.org)
- [MJX Documentation](https://mujoco.readthedocs.io/en/stable/mjx.html)

---

## Submodule 6.5 — Comparing Physics Simulators

### Topics
- **Gazebo** — ODE/DART/Bullet backends, ROS integration, large ecosystem
- **Isaac Sim** — PhysX 5, photorealistic, GPU-accelerated, synthetic data
- **MuJoCo** — fast CPU sim, analytical derivatives, best for RL, contacts
- **PyBullet** — easy to use, decent physics, good for learning
- **Drake** — mathematical optimization focus, LCM/ROS, best for control research
- **Comparison dimensions:**
  - Physics accuracy (contacts, friction, deformable bodies)
  - Rendering quality (for vision-based tasks)
  - Speed (single instance vs. parallel)
  - Ease of use, community, documentation
  - ROS2 integration quality

### Exercises
1. Model the same robot and task in MuJoCo, Gazebo, and PyBullet. Compare behaviors.
2. Benchmark: simulation speed (real-time factor) for each simulator with the same scene.
3. Write a comparison report documenting strengths and weaknesses for different use cases.

---

## 🏗️ Module 6 Project: MuJoCo Manipulation Benchmark Suite

### Description
Build a **benchmark suite** of manipulation tasks in MuJoCo for evaluating controllers and RL policies.

### Requirements
1. **Tasks** (implement at least 3):
   - Reaching: move end-effector to random target positions
   - Picking: grasp an object from a table
   - Stacking: stack one block on another
   - Insertion: peg-in-hole task with tight tolerances
2. **Robot:** 6/7-DOF arm with gripper in MJCF
3. **Baselines:** For each task, implement:
   - Hand-coded controller (PD + waypoints)
   - Scripted policy (state machine)
   - (Prepared for Module 7) RL observation/action/reward specification
4. **Metrics:** Success rate, completion time, smoothness, contact forces
5. **Visualization:** Rendered videos of each task with overlays

### Deliverables
- [ ] MuJoCo project with MJCF models and task environments
- [ ] Python package with task definitions and evaluation scripts
- [ ] Baseline results table for all tasks
- [ ] Video demonstrations of each task
- [ ] GitHub repo with documentation

---

*Previous: [Module 5](module_05_isaac_sim.md) | Next: [Module 7](module_07_reinforcement_learning.md)*
