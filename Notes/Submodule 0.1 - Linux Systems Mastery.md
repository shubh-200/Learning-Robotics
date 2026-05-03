# 📘 Notes

> **Module:** [[../curriculum/modules/module_00_foundations|module_00_foundations]]
> **Status:** 🟡 In Progress 
> **Started:** 2026-05-02
> **Completed:** Exercise 1
> **Total Hours Spent:** 4

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



#### Exercises Completed
- [x] Exercise 1
- [x] Exercise 2
- [ ] Exercise 3

---


