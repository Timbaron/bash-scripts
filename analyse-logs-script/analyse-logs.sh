#!/bin/bash

LOG_DIR="/Users/timothyakiode/Desktop/Learning/DevOps/logs"
APP_LOG_FILE="application.log"
SYS_LOG_FILE="system.log"
REPORT_FILE="/Users/timothyakiode/Desktop/Learning/DevOps/logs/log_report_analysis.txt"
LOG_THRESHOLD=2

ERROR_PATTERN=('ERROR' 'FATAL' 'CRITICAL')


echo "Analysing log files" > $REPORT_FILE
echo "============================" >> $REPORT_FILE

echo -e "\n List of log files updated in the last 24 hours"  >> $REPORT_FILE
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo "$LOG_FILES" >> $REPORT_FILE
echo "===========================" >> $REPORT_FILE

for LOG_FILE in $LOG_FILES; do

    echo -e "\n" >> $REPORT_FILE
    echo "================================================" >> $REPORT_FILE
    echo "===================$LOG_FILE====================" >> $REPORT_FILE
    echo "================================================" >> $REPORT_FILE

    for PATTERN in ${ERROR_PATTERN[@]}; do
        echo -e "\n Number of $PATTERN logs found in $LOG_FILE" >> $REPORT_FILE
        grep -c "$PATTERN" $LOG_FILE >> $REPORT_FILE

        echo -e "\n Searching $PATTERN logs in $LOG_FILE file" >> $REPORT_FILE
        grep "$PATTERN" $LOG_FILE >> $REPORT_FILE

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        echo "$ERROR_COUNT" >> $REPORT_FILE

        if [ $ERROR_COUNT -gt $LOG_THRESHOLD ]; then
            echo "⚠️ High number of $PATTERN logs found in log file $LOG_FILE"
        fi
    done

done

echo -e "\n Log analysis completed. Report saved in: $REPORT_FILE"