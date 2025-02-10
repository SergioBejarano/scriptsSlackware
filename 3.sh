#!/bin/bash

clear_screen() {
    clear
}

show_last_logs() {
    log_files=("/var/log/syslog" "/var/log/messages" "/var/log/dmesg")

    for log in "${log_files[@]}"; do
        echo -e "\\n===== [LOG: $log] ====="
        tail -n 15 "$log"
    done
}

filter_logs() {
    read -p "Enter the keyword to filter: " keyword
    log_files=("/var/log/syslog" "/var/log/messages" "/var/log/dmesg")

    for log in "${log_files[@]}"; do
        echo -e "\\n===== [LOG: $log] ====="
        tail -n 15 "$log" | grep --color=always "$keyword"
    done
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
