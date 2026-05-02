# Module 0 — Foundations & Tooling

> **Prerequisites:** Basic programming knowledge
> **Why this matters:** Every robotics job posting requires strong Linux, C++, and build-system fluency. This module ensures you're not fighting tools while learning robotics.

---

## Learning Objectives

By the end of this module, you will:
- Navigate Linux like a power user (filesystem, processes, networking, permissions)
- Write modern C++17 code with smart pointers, templates, and concurrency primitives
- Build complex projects with CMake and colcon
- Containerize robotics stacks with Docker and docker-compose
- Use Git workflows appropriate for robotics teams (branching, CI, code review)

---

## Submodule 0.1 — Linux Systems Mastery

### Topics
- **Filesystem hierarchy** — `/dev`, `/proc`, `/sys`, serial devices, udev rules
- **Process management** — `systemd`, `tmux`/`screen`, `htop`, `strace`, process signals
- **Networking** — `netstat`, `ss`, `tcpdump`, multicast for DDS, firewall rules (`ufw`/`iptables`)
- **Permissions & users** — `chmod`, `chown`, groups, `sudo` configuration
- **Shell scripting** — Bash for automation: loops, functions, argument parsing, `xargs`, `find`
- **SSH & remote development** — SSH keys, tunneling, VS Code Remote, `rsync`

### Exercises
1. Write a bash script that discovers all ROS2 topics, logs their message rates, and alerts if any drop below a threshold.
2. Configure a `udev` rule for a USB device (e.g., Arduino/ESP32) so it always mounts at `/dev/robot_serial`.
3. Set up `systemd` service files to auto-start a ROS2 launch file on boot.

### 🔌 Optional Hardware
- SSH into your RPi 4 and configure it as a remote ROS2 node development target.

### Resources
- [The Linux Command Line (free book)](https://linuxcommand.org/tlcl.php)
- [Missing Semester of CS Education — MIT](https://missing.csail.mit.edu/)
- `man` pages for `systemd`, `udev`, `iptables`

---

## Submodule 0.2 — Modern C++ for Robotics

### Topics
- **C++17 essentials** — `std::optional`, `std::variant`, `std::any`, structured bindings, `if constexpr`
- **Memory management** — `unique_ptr`, `shared_ptr`, `weak_ptr`, RAII patterns
- **Templates & generic programming** — variadic templates, SFINAE, `concepts` (C++20 intro)
- **Concurrency** — `std::thread`, `std::mutex`, `std::condition_variable`, `std::atomic`, thread pools
- **STL algorithms** — `std::transform`, `std::accumulate`, ranges (C++20)
- **Error handling** — exceptions vs. error codes, `std::expected` (C++23), Result patterns
- **Performance** — cache-friendly data structures, move semantics, profiling with `perf`/`valgrind`

### Exercises
1. Implement a **thread-safe circular buffer** (like a sensor data ring buffer) using `std::mutex` and `std::condition_variable`.
2. Write a **templated Kalman filter class** that works with different state/measurement dimensions.
3. Create a **plugin system** using `dlopen`/`dlsym` (or `std::shared_ptr<Base>`) that dynamically loads different motion planner implementations.

### Resources
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [Effective Modern C++ — Scott Meyers](https://www.oreilly.com/library/view/effective-modern-c/9781491908419/)
- [learncpp.com](https://www.learncpp.com/) — excellent free reference

### AI Prompt for Deep Dive
```
"Explain C++17 smart pointers (unique_ptr, shared_ptr, weak_ptr) with robotics 
examples. Show how to use them in a ROS2 node that manages sensor resources. 
Include common pitfalls and best practices for concurrent access."
```

---

## Submodule 0.3 — Build Systems: CMake & Colcon

### Topics
- **CMake fundamentals** — `CMakeLists.txt` anatomy, targets, properties, `find_package`, `target_link_libraries`
- **Modern CMake** — generator expressions, `PUBLIC`/`PRIVATE`/`INTERFACE`, config-mode packages
- **Colcon** — workspaces, overlays, `colcon build --packages-select`, `--symlink-install`, `--cmake-args`
- **Package manifests** — `package.xml` format 3, dependencies, build types (`ament_cmake`, `ament_python`)
- **Cross-compilation** — toolchain files for ARM (RPi4, Jetson)
- **Debugging builds** — `CMAKE_BUILD_TYPE=Debug`, sanitizers (ASan, TSan, UBSan)

### Exercises
1. Create a multi-package ROS2 workspace with 3 packages that depend on each other correctly.
2. Write a `CMakeLists.txt` that conditionally compiles CUDA code if GPU is available, falls back to CPU.
3. Set up a colcon workspace overlay system where a "development" overlay shadows the "base" install.

### Resources
- [Professional CMake (book)](https://crascit.com/professional-cmake/)
- [ROS2 Build System Docs](https://docs.ros.org/en/jazzy/Concepts/About-Build-System.html)

---

## Submodule 0.4 — Docker for Robotics

### Topics
- **Docker fundamentals** — images, containers, volumes, networks, `Dockerfile` best practices
- **Multi-stage builds** — small production images, build caching strategies
- **docker-compose** — multi-container robotics stacks (simulation + planner + perception)
- **GPU passthrough** — `--gpus all`, NVIDIA Container Toolkit for Isaac Sim / CUDA
- **GUI forwarding** — X11 forwarding, `xhost`, display in containers (for RViz, Gazebo)
- **ROS2 in Docker** — `ros:humble`, `ros:jazzy`, networking between containers (DDS discovery)
- **Development containers** — VS Code devcontainers for reproducible dev environments

### Exercises
1. Write a `Dockerfile` that builds your ROS2 workspace and runs it with GPU support.
2. Create a `docker-compose.yml` with 3 services: simulation, navigation, and visualization.
3. Set up a VS Code devcontainer that includes ROS2, MoveIt2, and all development tools.

### Resources
- [Docker Official Docs](https://docs.docker.com/)
- [OSRF Docker Images for ROS](https://github.com/osrf/docker_images)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)

---

## Submodule 0.5 — Git & CI/CD for Robotics

### Topics
- **Git workflows** — feature branches, rebasing vs. merging, `git bisect` for regression hunting
- **Conventional commits** — structured commit messages for changelog generation
- **GitHub Actions** — build, test, lint on every PR
- **Robotics-specific CI** — running simulation tests in CI (headless Gazebo, mock hardware)
- **Code quality** — `clang-format`, `clang-tidy`, `cpplint`, `pylint`, `mypy`
- **Documentation** — Doxygen for C++, Sphinx for Python, auto-generated API docs

### Exercises
1. Set up a GitHub Actions workflow that builds a ROS2 package, runs unit tests, and lints code.
2. Configure `clang-tidy` with a robotics-appropriate set of checks and integrate it into your build.
3. Set up `pre-commit` hooks for formatting, linting, and commit message validation.

### Resources
- [GitHub Actions for ROS2](https://github.com/ros-tooling/setup-ros)
- [Industrial CI (ros-industrial)](https://github.com/ros-industrial/industrial_ci)

---

## 🏗️ Module 0 Project: Dockerized ROS2 Development Environment

### Description
Build a **production-quality Docker development environment** for the rest of this curriculum:

### Requirements
1. **Multi-stage Dockerfile** with:
   - Base image: `ros:jazzy` or `ros:humble`
   - Development tools: compilers, debuggers, profilers
   - ROS2 packages: Nav2, MoveIt2, Gazebo
   - Python ML stack: PyTorch, OpenCV, NumPy
2. **docker-compose.yml** with services for:
   - `dev` — interactive development with mounted source
   - `sim` — headless Gazebo simulation
   - `viz` — RViz2 with X11 forwarding
3. **VS Code devcontainer** configuration
4. **GitHub Actions CI pipeline** that:
   - Builds the Docker image
   - Runs `colcon test` on a sample package
   - Lints C++ and Python code
5. **Documentation** — clear README with setup instructions

### Deliverables
- [ ] GitHub repository with the complete setup
- [ ] Working `docker-compose up` that launches sim + viz
- [ ] CI badge showing passing builds
- [ ] 5-minute demo video explaining your setup

### Evaluation Criteria
| Criterion | Weight |
|---|---|
| Docker best practices (multi-stage, caching, small image) | 25% |
| CI/CD pipeline completeness | 25% |
| Code quality tooling integration | 20% |
| Documentation quality | 15% |
| Reproducibility (works on fresh clone) | 15% |

---

*Next: [Module 1 — Intermediate & Advanced ROS2](module_01_ros2_advanced.md)*
