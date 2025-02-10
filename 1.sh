#!/bin/bash

list_files() {
    local dir="$1"
    local option="$2"
    
    if [[ "$option" == "recursive" ]]; then
        find "$dir" -type f -or -type d -printf "%T+ %s %y %p\n"
    else
        ls -la --time-style=long-iso "$dir" | awk '{print $6, $7, $5, $1, $9}'
    fi
}

sort_files() {
    local dir="$1"
    local criteria="$2"
    local option="$3"
    
    case "$criteria" in
        recent)
            list_files "$dir" "$option" | sort -r | awk '{count[$1]++} END {for (date in count) print date, count[date]}'
            ;;
        oldest)
            list_files "$dir" "$option" | sort | awk '{count[$1]++} END {for (date in count) print date, count[date]}'
            ;;
        largest)
            list_files "$dir" "$option" | sort -k2 -nr | awk '{count[$2]++} END {for (size in count) print size, count[size]}'
            ;;
        smallest)
            list_files "$dir" "$option" | sort -k2 -n | awk '{count[$2]++} END {for (size in count) print size, count[size]}'
            ;;
        type)
            list_files "$dir" "$option" | awk '{count[$3]++} END {for (type in count) print type, count[type]}'
            ;;
    esac
}

filter_files() {
    local dir="$1"
    local option="$2"
    local filter_type="$3"
    local filter_value="$4"
    
    case "$filter_type" in
        starts)
            list_files "$dir" "$option" | awk -v val="$filter_value" '$4 ~ "^" val {print $0}'
            ;;
        ends)
            list_files "$dir" "$option" | awk -v val="$filter_value" '$4 ~ val "$" {print $0}'
            ;;
        contains)
            list_files "$dir" "$option" | awk -v val="$filter_value" '$4 ~ val {print $0}'
            ;;
    esac
}

while true; do
    clear
    echo "===== FILE MANAGEMENT MENU ====="
    echo "Enter directory to analyze:"
    read directory
    echo "Include subdirectories? (yes/no)"
    read subdir
    option="non-recursive"
    [[ "$subdir" == "yes" ]] && option="recursive"
    
    echo "1. Sort by most recent"
    echo "2. Sort by oldest"
    echo "3. Sort by size (largest first)"
    echo "4. Sort by size (smallest first)"
    echo "5. Sort by file type"
    echo "6. Filter by files starting with..."
    echo "7. Filter by files ending with..."
    echo "8. Filter by files containing..."
    echo "9. Exit"
    echo "Choose an option:"
    read choice
    
    case "$choice" in
        1) sort_files "$directory" "recent" "$option" | less ;;
        2) sort_files "$directory" "oldest" "$option" | less ;;
        3) sort_files "$directory" "largest" "$option" | less ;;
        4) sort_files "$directory" "smallest" "$option" | less ;;
        5) sort_files "$directory" "type" "$option" | less ;;
        6) echo "Enter starting string:"; read value; filter_files "$directory" "$option" "starts" "$value" | less ;;
        7) echo "Enter ending string:"; read value; filter_files "$directory" "$option" "ends" "$value" | less ;;
        8) echo "Enter containing string:"; read value; filter_files "$directory" "$option" "contains" "$value" | less ;;
        9) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, try again." ;;
    esac
    
    echo "\nPress Enter to continue..."
    read
done
