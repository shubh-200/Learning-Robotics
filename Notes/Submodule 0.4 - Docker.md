# 📘 Docker for Robotics

> **Module:** Module 0
> **Status:**  🟢 Completed
> **Started:** 2026-05-04
> **Completed:** All exercises
> **Total Hours Spent:** 4

---

## 🎯 Learning Objectives
- [x] Learning docker concepts like images, containers, volumes, and networking
- [x] Write Dockerfile for ros_jazzy and docker-compose.yml for multi-stage containers
- [x] Configure VS code dev containers for remote development

## 📝 Notes by Submodule

### Submodule 0.4 — Docker
**Status:** ⬜ Completed

#### Key Concepts
### 1. Images vs. Containers

- **The Image (The Blueprint):** This is your `Dockerfile`. It is a static, read-only template that says "Start with Ubuntu 24.04, install ROS2 Jazzy, and install PyTorch."
    
- **The Container (The Robot Brain):** This is the running instance of the image. You can have five different containers running from the exact same image at the same time, completely isolated from each other.

### 2. Multi-Stage Builds

When you build a Docker image for production (to actually put on a physical robot), you don't want to include all the massive compilers and debugging tools, because they waste space. Multi-stage builds allow you to compile your C++ code in a giant "Builder" image, and then copy _only_ the final compiled binaries into a tiny "Production" image.

### 3. Volumes 

By default, when a Docker container is destroyed, all data inside it is deleted. **Volumes** allow you to map a folder on your host machine into the container.

- _For Robotics:_ You will "bind mount" your `~/ros2_ws/src` folder into the container. This means you can use your fancy VS Code setup on Windows to edit the Python files, but the ROS2 tools running _inside_ the container instantly see the changes.
    
- _The WSL2 Rule:_ Always ensure your workspace folder is physically located inside your WSL2 home directory (e.g., `~`), not on the Windows `C:\` drive!
    

### 4. Networking

ROS2 DDS discovery relies heavily on network multicasting. If you have a container running Gazebo and another running your Nav2 planner, they need to be on the same Docker network to talk to each other. Alternatively, you can run the container with `--network host`, which tells Docker to bypass its internal router and plug the container directly into your WSL2 network interface.

#### My Implementation Notes

### **Exercise 1:** Write a Dockerfile
```dockerfile
# 1. Base Image: Use the official ROS2 Jazzy desktop image
FROM osrf/ros:jazzy-desktop

# Prevent apt-get from prompting for user input during installation
ENV DEBIAN_FRONTEND=noninteractive

# 2. Install essential development tools
RUN apt-get update && apt-get install -y \
    nano \
    git \
    curl \
    wget \
    python3-pip \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# 3. Create a non-root user (Crucial for WSL2 volume mounts)
ARG USERNAME=ros_dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu \
	&& groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && apt-get update \
    && apt-get install -y sudo \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# 4. Enable NVIDIA GPU Passthrough for CUDA/Hardware Acceleration
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# 5. Switch out of root and into the new user
USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR $HOME/ros2_ws

# 6. Automate ROS2 environment sourcing
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
```

### **Exercise 2:**

```yaml
# --- 1. YAML Anchors (The DRY Principle) ---
# This block defines shared settings so we don't have to retype them for every service.
x-ros-common: &ros-common
  # Use the image built in Exercise 1
  image: my_ros2_jazzy_env:latest
  
  # Crucial for ROS2 DDS discovery: share the host's network
  network_mode: "host"
  ipc: host
  
  # Bind mount your local WSL2 workspace into the container
  volumes:
    - ~/ros2_ws:/home/ros_dev/ros2_ws
    # Mount the X11 socket for WSLg GUI forwarding
    - /tmp/.X11-unix:/tmp/.X11-unix
    
  # Pass WSL2 display variables and enable NVIDIA GPUs
  environment:
    - DISPLAY=${DISPLAY}
    - WAYLAND_DISPLAY=${WAYLAND_DISPLAY}
    - NVIDIA_VISIBLE_DEVICES=all
    - NVIDIA_DRIVER_CAPABILITIES=all
    # Isolate our ROS traffic so we don't conflict with other robots
    - ROS_DOMAIN_ID=42

# --- 2. The Services ---
services:

  # Service A: The Physics Simulation (Headless)
  sim:
    <<: *ros-common
    container_name: robot_sim
    # We use a bash wrap to ensure the ROS environment is sourced before running
    command: ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && echo 'Starting headless simulation...' && ros2 run demo_nodes_cpp talker"]

  # Service B: The Navigation Stack
  nav:
    <<: *ros-common
    container_name: robot_nav
    depends_on:
      - sim
    command: ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && echo 'Starting navigation stack...' && ros2 run demo_nodes_cpp listener"]

  # Service C: Visualization (GUI)
  viz:
    <<: *ros-common
    container_name: robot_viz
    # This service needs an interactive terminal to keep RViz2 alive
    tty: true
    stdin_open: true
    command: ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && rviz2"]
```

### **Exercise 3:**

**Step 1:**
Open VS Code and install the Dev Containers extension by Microsoft.

**Step 2:**
1. Open your WSL terminal and navigate to your workspace:
```bash
cd ~/ros2_ws
mkdir .devcontainer
cd .devcontainer
nano devcontainer.json
```
2. The config is similar to the `docker-compose.yml`:
```json
{
    "name": "ROS 2 Jazzy Robotics Environment",
    "image": "my_ros2_jazzy_env:latest",
    
    "workspaceFolder": "/home/ros_dev/ros2_ws",
    "workspaceMount": "source=${localWorkspaceFolder},target=/home/ros_dev/ros2_ws,type=bind",
    
    "runArgs": [
        "--network=host",
        "--ipc=host",
        "--gpus=all",
        "-e", "DISPLAY=${env:DISPLAY}",
        "-e", "WAYLAND_DISPLAY=${env:WAYLAND_DISPLAY}",
        "-v", "/tmp/.X11-unix:/tmp/.X11-unix"
    ],
    
    "remoteUser": "ros_dev",
    
    "customizations": {
        "vscode": {
            "settings": {
                "terminal.integrated.defaultProfile.linux": "bash"
            },
            "extensions": [
                "ms-iot.vscode-ros",
                "ms-vscode.cpptools",
                "ms-python.python",
                "twxs.cmake",
                "ms-vscode.cpptools-themes"
            ]
        }
    }
}
```

**Step 3:**
1. Navigate to ws
```bash
cd ~/ros2_ws
```
2. Open VS Code from there
```bash
code .
```
3. Look at the very bottom-left corner of the VS Code window. You will see a blue (or green) icon with `><` arrows. Click it.
4. A command palette will drop down from the top. Select **"Reopen in Container"**.
5. Once it finishes, open a new integrated terminal in VS Code (`Ctrl+~`). Type:
```bash
ros2 node list
```
Now these commands will directly execute.


#### Exercises Completed
- [x] Exercise 1
- [x] Exercise 2
- [x] Exercise 3

---



