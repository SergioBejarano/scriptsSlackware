#!/bin/bash

clear_screen() {
    clear
}

show_last_logs() {
    echo "\nShowing last 15 lines of system logs:\n"
    tail -n 15 /var/log/syslog 2>/dev/null
    tail -n 15 /var/log/auth.log 2>/dev/null
    tail -n 15 /var/log/dmesg 2>/dev/null
}

filter_logs() {
    echo -n "Enter the word to filter logs: "
    read word
    echo "\nFiltered logs containing '$word':\n"
    tail -n 15 /var/log/syslog 2>/dev/null | grep --color=auto "$word"
    tail -n 15 /var/log/auth.log 2>/dev/null | grep --color=auto "$word"
    tail -n 15 /var/log/dmesg 2>/dev/null | grep --color=auto "$word"
}

while true; do
    clear_screen
    echo "===== LOG MANAGEMENT MENU ====="
    echo "1. Show last 15 lines of system logs"
    echo "2. Filter last 15 lines by keyword"
    echo "3. Exit"
    echo -n "Choose an option: "
    read option
    
    case $option in
        1)
            show_last_logs
            ;;
        2)
            filter_logs
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
    
    echo "\nPress Enter to continue..."
    read
done
