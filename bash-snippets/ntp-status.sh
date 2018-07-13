#!/bin/bash

/usr/local/etc/init.d/ntp status | grep "is running"

if [ "$?" -eq "0" ]; then
    # Get the last ntp log entry to get the clock skew
    if [ -f /var/log/service-ntp.log ]; then
        LATEST_NTP_LOG= $(tail -n 1 /var/log/service-ntp.log)
        SKEW=`echo -e "${LATEST_NTP_LOG}" | awk -F" " '{ printf "%s", $5 }'`
        # Convert skew value to an integer
        ABS_SKEW="${SKEW#-}"
        ABS_SKEW_INT=${ABS_SKEW%.*}
        # Show error message if skew is larger than 100ms (Skew value is in microseconds)"
        if [ ! -z "$ABS_SKEW_INT" ]; then
            if [ "$ABS_SKEW_INT" -lt 100000 ]; then
              NTPSERVER_WITH_STATUS="\e[32;1m${NTPSERVER}\e[0m"
            else
              NTPSERVER_WITH_STATUS="\e[31;1m${NTPSERVER}\e[0m"
              NTPD_ERROR="\e[31;1mClock skew is more than 100ms\e[0m"
            fi
        else
            NTPSERVER_WITH_STATUS="\e[33;1m${NTPSERVER}\e[0m"
            NTPD_ERROR="\e[33;1mNTPD log entry is invalid\e[0m"
        fi
    else
        NTPSERVER_WITH_STATUS="\e[33;1m${NTPSERVER}\e[0m"
        NTPD_ERROR="\e[33;1mCannot read NTPD log\e[0m"
    fi
fi