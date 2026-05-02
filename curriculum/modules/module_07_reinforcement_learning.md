# Module 7 — Reinforcement Learning for Robotics

> **Duration:** 3–4 weeks | **Prerequisites:** Modules 5, 6, your existing DL background
> **Why this matters:** RL is the bridge between "hard-coded robot" and "learning robot." Sim-to-real transfer is the hottest skill in robotics hiring right now. Your DL background is a massive advantage here.

---

## Learning Objectives
- Understand RL fundamentals as applied to continuous robotic control
- Implement PPO and SAC for manipulation and locomotion tasks
- Design reward functions, observation spaces, and action spaces for robots
- Master sim-to-real transfer techniques (domain randomization, system identification)
- Train policies in MuJoCo/Isaac Sim and deploy in simulation with ROS2

---

## Submodule 7.1 — RL Fundamentals for Robotics

### Topics
- **MDP formulation** — state, action, reward, transition, discount factor
- **Policy vs. value function** — what are we learning?
- **On-policy vs. off-policy** — PPO (on) vs. SAC (off), tradeoffs
- **Continuous action spaces** — why robotics is different from Atari/board games
  - Gaussian policies, action bounds, tanh squashing
- **Observation design** — what the robot "sees": proprioception, exteroception
  - State-based vs. image-based observations
  - Observation normalization, history stacking
- **Reward design** — dense vs. sparse, shaping pitfalls, potential-based shaping
  - Common reward components: distance, velocity, energy, safety

### Exercises
1. Solve `Pendulum-v1` (Gymnasium) with PPO using Stable Baselines3. Experiment with hyperparameters.
2. Design reward functions for a reaching task. Compare dense vs. sparse rewards: learning curves.
3. Implement observation normalization and compare training stability with/without it.

### AI Prompt
```
"Explain reinforcement learning for robotic manipulation:
1) MDP formulation for a pick-and-place task (state, action, reward)
2) Why PPO and SAC are preferred for continuous control
3) Observation space design: what to include (joint positions, velocities, 
   object poses, gripper state)
4) Reward shaping strategies with concrete examples
5) Common training pitfalls and solutions
Include Python code using Gymnasium and Stable Baselines3."
```

### Resources
- [Spinning Up in Deep RL — OpenAI](https://spinningup.openai.com/)
- [Stable Baselines3 Docs](https://stable-baselines3.readthedocs.io/)
- *Reinforcement Learning: An Introduction* — Sutton & Barto (free online)

---

## Submodule 7.2 — PPO & SAC Deep Dive

### Topics
- **PPO (Proximal Policy Optimization)**
  - Clipped surrogate objective, GAE (Generalized Advantage Estimation)
  - Hyperparameters: clip range, learning rate, entropy coefficient, minibatch size
  - PPO for locomotion: why it works well
- **SAC (Soft Actor-Critic)**
  - Maximum entropy framework, automatic temperature tuning
  - Twin Q-networks, target networks, replay buffer
  - SAC for manipulation: why it's often preferred
- **Training infrastructure**
  - Vectorized environments: `SubprocVecEnv`, parallel data collection
  - GPU utilization: policy on GPU, environments on CPU (or MJX)
  - Logging: TensorBoard, W&B, tracking learning curves
- **Hyperparameter tuning** — grid search, Optuna, common starting points

### Exercises
1. Train SAC on `HalfCheetah-v4` (MuJoCo). Achieve competitive performance. Log with TensorBoard.
2. Compare PPO vs. SAC on a manipulation task (reaching). Plot learning curves, final performance.
3. Use Optuna to tune PPO hyperparameters for a locomotion task. Document results.
4. Train with vectorized environments (8, 16, 32 envs). Measure wall-clock speedup.

---

## Submodule 7.3 — Custom RL Environments for Robotics

### Topics
- **Gymnasium API** — `reset()`, `step()`, `observation_space`, `action_space`
- **Custom MuJoCo environments** — subclassing `gymnasium.Env` with MuJoCo backend
  - Loading MJCF models, defining observation/action spaces
  - Implementing `step()`: simulation, reward, termination, truncation
  - Implementing `reset()`: randomized initial conditions
- **Isaac Gym / Isaac Lab environments** — GPU-parallel environments in Isaac Sim
  - `ManagerBasedRLEnv`, `DirectRLEnv` APIs
  - Observation/action managers, reward managers
- **Environment wrappers** — frame stacking, action repeat, reward scaling, normalization
- **Environment testing** — `check_env()`, manual rollouts, visualization

### Exercises
1. Create a custom MuJoCo Gymnasium environment for your Module 6 reaching task.
2. Implement proper reset randomization (random target positions, initial joint angles).
3. Add environment wrappers: observation normalization, action scaling, time limits.
4. Verify environment with `check_env()`. Train PPO on it. Iterate on reward function.

---

## Submodule 7.4 — Sim-to-Real Transfer

### Topics
- **The reality gap** — why policies trained in simulation fail on real robots
  - Visual gap, dynamics gap, sensor noise gap, latency gap
- **Domain Randomization (DR)** — the most widely used technique
  - Physics DR: mass, friction, damping, joint offsets, actuator gains
  - Visual DR: lighting, textures, camera position, background
  - Sensor DR: noise, latency, dropout, bias
  - Automatic DR: ADR (OpenAI), BayesSim
- **System Identification** — fitting simulation parameters to match real data
  - Data collection on real robot, parameter optimization, iterative refinement
- **Domain Adaptation** — adapting features/representations across domains
  - RCAN, CycleGAN for visual sim-to-real
- **Sim-to-real best practices**
  - Action space design: position control > velocity > torque (for transfer)
  - Low-frequency control (20-50 Hz) is easier to transfer
  - Observation filtering and smoothing
  - Latency modeling in simulation

### Exercises
1. Train a reaching policy WITH and WITHOUT domain randomization. Compare robustness to perturbations.
2. Implement physics DR: randomize mass (±20%), friction (±50%), actuator gains (±10%) during training. Evaluate on nominal and perturbed environments.
3. Add observation noise and action latency to your environment. Train a robust policy.
4. Document a sim-to-real plan: what you would randomize, how you'd validate on real hardware.

### AI Prompt
```
"Explain sim-to-real transfer for robotic manipulation:
1) Why policies fail when transferred from simulation to real world
2) Domain randomization: what parameters to randomize, by how much
3) System identification: fitting simulator to real robot data
4) Action space choice impact on transferability
5) A complete sim-to-real workflow for a pick-and-place task
Include Python implementation of domain randomization wrappers."
```

---

## Submodule 7.5 — Vision-Based RL

### Topics
- **Image observations** — CNN encoders for pixel inputs
- **Representation learning** — autoencoders, contrastive learning for state representation
- **Data augmentation** — DrQ, RAD — augmenting images during RL training
- **Foundation models** — using pre-trained vision encoders (R3M, MVP, VC-1)
- **Asymmetric actor-critic** — privileged information in critic, images in actor
- **Point cloud-based RL** — PointNet encoder for 3D observations

### Exercises
1. Train a policy using RGB image observations (CNN encoder + PPO) for a simple task.
2. Implement data augmentation (random crop, color jitter) and compare with vanilla image RL.
3. Use a pre-trained vision encoder (R3M or CLIP) as frozen backbone. Compare sample efficiency.

---

## Submodule 7.6 — Advanced RL Topics

### Topics
- **Curriculum learning** — progressively harder tasks, automatic curriculum
- **Hierarchical RL** — high-level goals, low-level skills
- **Multi-task RL** — learning multiple manipulation primitives with one policy
- **Imitation learning** — behavior cloning, DAgger, combining IL + RL
- **Offline RL** — learning from fixed datasets (D4RL, robomimic)
- **Foundation models for robotics** — RT-1, RT-2, Octo, π0 — the frontier
  - What they are, how they're trained, current limitations
  - Open-source options: Octo, OpenVLA

### Exercises
1. Implement curriculum learning for stacking: first learn to reach, then to pick, then to stack.
2. Train a behavior cloning policy from expert demonstrations. Compare with RL from scratch.
3. Fine-tune a pre-trained model (e.g., Octo) on your custom task (if compute allows).

---

## 🏗️ Module 7 Project: Sim-to-Real Ready Manipulation Policy

### Description
Train a **robust manipulation policy** in simulation with sim-to-real transfer techniques, ready for deployment.

### Requirements
1. **Task:** Pick-and-place or peg-insertion in MuJoCo (from Module 6 benchmark)
2. **Training:**
   - PPO or SAC with proper hyperparameter tuning
   - Domain randomization: physics, visual (if image-based), sensor noise
   - Curriculum learning (progressive difficulty)
3. **Evaluation:**
   - Success rate on nominal environment
   - Success rate under heavy perturbations (test robustness)
   - Comparison: with vs. without domain randomization
   - Comparison: state-based vs. image-based (optional)
4. **ROS2 Integration:** Deploy trained policy as a ROS2 node
   - Subscribe to joint states, publish joint commands
   - Real-time inference with PyTorch
5. **Documentation:** Complete sim-to-real readiness report

### Deliverables
- [ ] Training code with configs, logging, and reproducibility (random seeds)
- [ ] Trained policy checkpoints and training curves
- [ ] Robustness evaluation report with quantitative metrics
- [ ] ROS2 inference node for real-time policy deployment
- [ ] Video: policy executing task under various conditions
- [ ] GitHub repo

---

*Previous: [Module 6](module_06_mujoco.md) | Next: [Module 8](module_08_production_systems.md)*
