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

**Exercise 1:**
```
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


#### Exercises Completed
- [x] Exercise 1
- [ ] Exercise 2

---


