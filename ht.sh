#!/bin/bash
#
# Author: Arnulf Heimsbakk
# URL   : https://github.com/aheimsbakk/notes
# Date  : 2018-11-25
#
# Turn on and off hyperthreading by turning on and off sibling logical processors.
# Limitation. Will only work on processors with two threads.

cpu_path=/sys/devices/system/cpu

case "$1" in

    off|OFF)
        echo Trying to turn OFF hyperthreading
        for i in $(grep  . $cpu_path/cpu*/topology/thread_siblings_list | cut -s -d, -f2 | sort -n -u); do
            echo - turning off logical CPU $i
            echo 0 > $cpu_path/cpu$i/online
        done
        ;;

    on|ON)
        echo Trying to turn ON hyperthreading
        for i in $cpu_path/cpu*/online; do
            if [[ $(cat "$i") -eq 0 ]]; then
                echo Turning on logical CPU $(echo $i | grep -oE "[[:digit:]]+")
                echo 1 > $i
            fi
        done
        ;;

    *)
        echo Usage: "$(basename $0) [on|off]"
        echo
        echo Turn off or on hyperthreading on all CPUs.
        ;;

esac

