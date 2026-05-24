 Linux Server Health Monitoring Script

 Overview
Bash script to monitor CPU, RAM, Disk, Services and System Logs.
Simulates real Data Center Operations (DCO) health check workflows.

 Tools Used
- Bash Scripting
- Linux CLI (top, free, df, journalctl, systemctl)
- Cron Jobs

 Features
- CPU & RAM monitoring with alert thresholds (80%)
- Disk usage tracking
- Service status check (SSH, cron, networking)
- System error log extraction
- Saves report to health_report.log

 How to Run
chmod +x monitor.sh
./monitor.sh
