#!/bin/bash

LOG_FILE="health_report.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
CPU_THRESHOLD=80
RAM_THRESHOLD=80

echo "==============================" | tee -a $LOG_FILE
echo " Server Health Report"         | tee -a $LOG_FILE
echo " $DATE"                        | tee -a $LOG_FILE
echo "==============================" | tee -a $LOG_FILE

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "[CPU] Usage: $CPU%"            | tee -a $LOG_FILE
if (( $(echo "$CPU > $CPU_THRESHOLD" | bc -l) )); then
  echo "[ALERT] CPU usage HIGH!"     | tee -a $LOG_FILE
fi

RAM=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
echo "[RAM] Usage: $RAM%"            | tee -a $LOG_FILE
if [ "$RAM" -gt "$RAM_THRESHOLD" ]; then
  echo "[ALERT] RAM usage HIGH!"     | tee -a $LOG_FILE
fi

DISK=$(df -h / | awk 'NR==2 {print $5}')
echo "[DISK] Usage: $DISK"           | tee -a $LOG_FILE

for SERVICE in ssh cron networking; do
  STATUS=$(systemctl is-active $SERVICE 2>/dev/null || echo "inactive")
  echo "[SERVICE] $SERVICE: $STATUS" | tee -a $LOG_FILE
done

echo ""                              | tee -a $LOG_FILE
echo "[LOGS] Last 10 errors:"        | tee -a $LOG_FILE
journalctl -p 3 -n 10 --no-pager 2>/dev/null | tee -a $LOG_FILE

echo "==============================" | tee -a $LOG_FILE
echo " Report saved: $LOG_FILE"
