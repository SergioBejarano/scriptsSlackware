#!/bin/bash

# Function to list files based on the user's directory selection and filtering
list_files() {
    local dir="$1"
    local recursive="$2"
    local pattern="$3"
    local mode="$4"

    # Set search mode
    local find_cmd="find \"$dir\" -maxdepth 1"
    [ "$recursive" = "yes" ] && find_cmd="find \"$dir\""

    # Apply filtering
    case "$mode" in
        starts_with) find_cmd+=" -type f -name \"$pattern*\"" ;;
        ends_with) find_cmd+=" -type f -name \"*$pattern\"" ;;
        contains) find_cmd+=" -type f -name \"*$pattern*\"" ;;
    esac

    eval "$find_cmd -printf '%p\t%s\t%TY-%Tm-%Td\n'"  # Print filename, size, and last modified date
}

# Function to count occurrences
count_occurrences() {
    awk '{counts[$2]++} END {for (key in counts) print counts[key], key}' | sort -nr
}

# Function to display menu
show_menu() {
    clear
    echo "File Sorting and Filtering Script"
    echo "---------------------------------"
    echo "1) Sort by most recent (group by date)"
    echo "2) Sort by oldest (group by date)"
    echo "3) Sort by size (largest first, group by size)"
    echo "4) Sort by size (smallest first, group by size)"
    echo "5) Sort by file type (File/Directory)"
    echo "6) Apply filtering"
    echo "7) Exit"
    echo "---------------------------------"
}

# Main script logic
clear
read -rp "Enter the directory to analyze: " directory
[ ! -d "$directory" ] && echo "Invalid directory!" && exit 1

while true; do
    show_menu
    read -rp "Choose an option: " choice

    case "$choice" in
        1) 
            clear
            echo "Sorting by most recent:"
            list_files "$directory" "no" "" "" | sort -k3,3r | count_occurrences | less
            ;;
        2) 
            clear
            echo "Sorting by oldest:"
            list_files "$directory" "no" "" "" | sort -k3,3 | count_occurrences | less
            ;;
        3) 
            clear
            echo "Sorting by size (largest first):"
            list_files "$directory" "no" "" "" | sort -k2,2nr | count_occurrences | less
            ;;
        4) 
            clear
            echo "Sorting by size (smallest first):"
            list_files "$directory" "no" "" "" | sort -k2,2n | count_occurrences | less
            ;;
        5) 
            clear
            echo "Sorting by file type:"
            find "$directory" -maxdepth 1 -exec stat --format="%F" {} + | sort | uniq -c | less
            ;;
        6)
            read -rp "Enable recursion (yes/no)? " recursive
            read -rp "Filter mode (starts_with, ends_with, contains): " mode
            read -rp "Enter filter pattern: " pattern
            clear
            echo "Filtered results:"
            list_files "$directory" "$recursive" "$pattern" "$mode" | less
            ;;
        7) 
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, try again!"
            ;;
    esac
done
