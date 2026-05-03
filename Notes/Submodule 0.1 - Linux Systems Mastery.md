# 📘 Notes

> **Module:** [[../curriculum/modules/module_00_foundations|module_00_foundations]]
> **Status:** 🟡 In Progress 
> **Started:** 2026-05-02
> **Completed:** Exercise 1
> **Total Hours Spent:** 7

---

## 🎯 Learning Objectives
- [x] Navigate Linux like a power user (filesystem, processes, networking, permissions)
- [ ] Write modern C++17 code with smart pointers, templates, and concurrency primitives
- [ ] Build complex projects with CMake and colcon
- [ ] Containerize robotics stacks with Docker and docker-compose
- [ ] Use Git workflows appropriate for robotics teams (branching, CI, code review)

## 📝 Notes by Submodule

### Submodule 0.1 — Linux Systems Mastery
**Status:** ⬜ In Progress

#### Key Concepts
_File System Hierarchy_ 
![[../Resources/attachments/Pasted image 20260502213940.png]] 

_Linux Commands_
https://www.kevsrobots.com/learn/linux_intro/19_cheatsheet.html

_Shell Scripting_
https://learnxinyminutes.com/bash/
https://devhints.io/bash
#### My Implementation Notes

### **Exercise 1:**

```bash
#!/bin/bash

# --- Configuration ---
LOG_FILE="topic_health.log"
THRESHOLD=10.0      # Minimum acceptable rate in Hz
CHECK_DURATION=10    # Seconds to sample each topic

echo "Starting ROS2 Topic Health Monitor..." | tee -a "$LOG_FILE"
echo "Time: $(date)" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# 1. Discover all active ROS2 topics
TOPICS=$(ros2 topic list)

for TOPIC in $TOPICS; do
    # Skip ROS2 internal parameter events to avoid log noise
    if [[ "$TOPIC" == *"/parameter_events"* || "$TOPIC" == *"/rosout"* ]]; then
        continue
    fi

    echo -n "Checking $TOPIC... "

    # 2. Sample the topic rate
    # 'timeout' forces 'ros2 topic hz' to close after CHECK_DURATION seconds
    # stderr (2) is sent to /dev/null to hide ROS2 warnings for empty topics
    RATE_OUTPUT=$(timeout $CHECK_DURATION ros2 topic hz "$TOPIC" 2>/dev/null | grep "average rate:")

    # 3. Evaluate the output
    if [ -z "$RATE_OUTPUT" ]; then
        echo "ALERT: No messages published." | tee -a "$LOG_FILE"
    else
        # Extract the exact numeric rate using awk
        RATE=$(echo "$RATE_OUTPUT" | tail -n 1 | awk '{print $3}')

        # Bash only understands integers natively. We use awk to compare floats.
        # It returns 1 if true (low rate), 0 if false (healthy rate)
        IS_LOW=$(awk -v r="$RATE" -v t="$THRESHOLD" 'BEGIN {print (r < t)}')

        if [ "$IS_LOW" -eq 1 ]; then
            echo "ALERT: Drop detected. Current rate: $RATE Hz (Threshold: $THRESHOLD Hz)" | tee -a "$LOG_FILE"
        else
            echo "OK ($RATE Hz)" | tee -a "$LOG_FILE"
        fi
    fi
done

echo "----------------------------------------" | tee -a "$LOG_FILE"
```
- **`timeout $CHECK_DURATION`**: The command `ros2 topic hz` runs infinitely until you press `Ctrl+C`. You cannot automate an infinite command in a standard loop. `timeout` is a Linux utility that sends a termination signal (SIGTERM) to the process after the specified seconds, allowing the script to move on.

- **`2>/dev/null`**: This redirects standard error (file descriptor 2) to the Linux "black hole" (`/dev/null`). If a topic exists but nothing is publishing to it, ROS2 will throw a continuous warning. We swallow that warning so our logs stay clean.

- **`grep` and `awk`**: This is classic Linux text manipulation. The output of `ros2 topic hz` is a block of text. `grep "average rate:"` filters out everything except the lines containing the rate. Then, `awk '{print $3}'` splits the final line by spaces and grabs exactly the 3rd column i.e. the raw number itself.

- **`tee -a`**: This takes the output of our `echo` commands and splits it in two directions: it prints to your terminal so you can watch it live, and it appends (`-a`) it to `topic_health.log` simultaneously.

### **Exercise 2:**
**Step 1:** Recognize the connected device using the command _lsusb_
Since I am using WSL2, the device is not directly recognized just by connecting it and running the command.
First I needed to forward the USB traffic from Windows directly into the WSL kernel. To do this, a tool called _usbipd-win_ (uses USB/IP protocol) is used.

Run powershell as administrator and install the tool:
```powershell
winget install --interactive --exact dorssel.usbipd-win
```

Install the linux client tool:
```shell
sudo apt update
sudo apt install linux-tools-virtual hwdata
```

Bind and attach the device:
1. Plug in your device (I used an ESP32)
2. Open powershell as administrator
3. List all connected USB devices
```powershell
usbipd list
```
4. Look through the output for your device. Look at the BUSID column and note it.
5. Bind the device to make it available for sharing. (1-1 is the entry from the BUSID column)
```powershell
usbipd bind --busid 1-1
```
6. Attach the device to WSL
```powershell
usbipd attach --wsl --busid 2-1
```

Switch back to WSL and type in the command _lsusb_.
You'll see an output as follows:
```bash
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 10c4:ea60 Silicon Labs CP210x UART Bridge
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
```

My ESP32 is recognized as Device 003. The crucial part is the ID 10c4:ea60 where, 
- Vendor ID: 10c4
- Product ID: ea60

**Step 2:** Write the _udev_ rule.
Rules are stored in `/etc/udev/rules.d/`. They are parsed in numerical order, so we usually prefix custom rules with `99-` so they run last and override default system rules.
1. Open a new file with root privileges:
```bash
sudo nano /etc/udev/rules.d/99-robot-serial.rules
```
2. Add the following line:
```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="robot_serial", MODE="0666"
```
- `==` is a matching condition. We are telling the system: _If_ the subsystem is a TTY (serial) device, _and_ the Vendor ID matches, _and_ the Product ID matches...

- `+=` and `=` are actions. ..._Then_ create a symlink named `robot_serial` and set the permissions mode to `0666` (read and write access for all users).

Adding `MODE="0666"` is a vital robotics hack. It prevents the dreaded "Permission Denied" error when your ROS2 node tries to open the serial port, saving you from having to run your nodes as `sudo` or messing with user groups.

**Step 3:** Reload and Trigger the rules
Linux needs to be told that you added a new rule. You can either unplug the device and plug it back in, or run these commands to apply it without touching the hardware:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

**Step 4:** Verify
```bash
ls -l /dev/robot_serial
```
The output was as follows:
```bash
lrwxrwxrwx 1 root root 7 May  3 16:58 /dev/robot_serial -> ttyUSB0
```

### **Exercise 3:** 

Since we need to launch a script/launch file on boot using systemd, first create a ROS2 workspace.
```bash
mkdir -p ~/ros2_ws/src
```

Use `colcon build` to build the initial empty workspace creating the `build, install, log` directories.

Create a ROS2 package. I am creating a python package here.
I am going with a simple package which will contain the launch file to bring up the turtle sim.
```bash
ros2 pkg create --build-type ament_python turtle_bringup
```
Replace `ament_python` with `ament_cmake` for a cpp package.

Now I write the launch file in `~/turtle_bringup/launch`
```bash
nano launch/turtlesim_launch.py
```

```python
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='turtlesim',
            executable='turtlesim_node',
            name='sim_window'
        )
    ])
```

Register the launch file in the setup.py file.
```python
from setuptools import find_packages, setup
import os                     # Add this
from glob import glob         # Add this

package_name = 'turtle_bringup'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        # --- Add the following line ---
        (os.path.join('share', package_name, 'launch'), glob(os.path.join('launch', '*launch.[pxy][yma]*'))),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='username',
    maintainer_email='username@todo.todo',
    description='TODO: Package description',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
        ],
    },
)
```

Build the workspace and test the launch file.
```bash
cd ~/ros2_ws
colcon build --packages-select turtle_bringup
source install setup.bash
ros2 launch turtle_bringup turtlesim_launch.py
```

Now time to auto launch this whenever we boot up WSL.
**Step 1:** Wrapper Script
`systemd` environments are extremely minimal. They do not automatically load the `.bashrc`, which means they have no idea what "ROS2" is. We have to create a script that explicitly sources your environments before launching your code.
1. Create the script in the home directory `/home/username` as `nano ~/start_robot.sh`
2. Add the following in the script:
```bash
#!/bin/bash

# Source the core ROS2 installation
source /opt/ros/jazzy/setup.bash

# Source your local workspace
source /home/username/ros2_ws/install/setup.bash

# Launch your main bringup file
ros2 launch turtle_bringup turtlesim_launch.py
```
3. Make the script executable
```bash
chmod +x start_robot.sh
```

**Step 2:** `systemd` service file
1. Create the service file in the system directory:
```bash
sudo nano /etc/systemd/system/robot-stack.service
```
2. Add the following config in it:
```bash
[Unit]
Description=ROS2 Turtle Sim
After=network.target

[Service]
Type=simple
User=username
# The following 2 lines are needed for systemd to launch gui properly (See Day 2 log)
Environment="DISPLAY=:0"
Environment="WAYLAND_DISPLAY=wayland-0"
ExecStart=/home/username/start_robot.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
- **`After=network.target`**: This ensures your robot doesn't try to start ROS2 before the Wi-Fi or DDS networking interfaces are ready.
- **`User=username`**: This is critical. If you don't specify this, `systemd` runs everything as `root`. You want your ROS2 nodes running under your normal user account so they have access to your workspace files.
- **`Restart=on-failure` & `RestartSec=5`**: This makes your robot robust. If your C++ node throws a segmentation fault and crashes, Linux will wait 5 seconds and automatically spin the entire stack back up.

**Step 3:** Enable and Start the service
1. Reload the daemon to read the new file
```bash
sudo systemctl daemon-reload
```
2. Enable the service so it starts automatically on every boot
```bash
sudo systemctl enable robot-stack.service
```
3. Start it right now without having to reboot
```bash
sudo systemctl start robot-stack.service
```

Additional debugging step:
Because this runs in the background, we won't see the `ros2` output in our terminal. To view the live logs of our robot stack, we use the `journalctl` command:
```bash
journalctl -u robot-stack.service -f
```
(The `-u` targets the specific unit, and `-f` follows the log live, just like `tail -f`).

#### Exercises Completed
- [x] Exercise 1
- [x] Exercise 2
- [x] Exercise 3

---


