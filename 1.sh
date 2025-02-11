#!/bin/bash

list_files() {
    local dir="$1"
    local option="$2"
    local filter_type="$3"
    local filter_value="$4"
    
    find_command="find \"$dir\""
    
    if [ "$filter_type" = "starts" ]; then
        find_command+=" -name \"$filter_value*\""
    elif [ "$filter_type" = "ends" ]; then
        find_command+=" -name \"*$filter_value\""
    elif [ "$filter_type" = "contains" ]; then
        find_command+=" -name \"*$filter_value*\""
    else
        find_command+=" -name \"*\""
    fi
    
    find_command+=" -printf '%p %s %TY-%Tm-%Td %y\n'"
    
    clear
    case $option in
        "recent")
            eval $find_command | sort -k3 -r | awk '{count[$3]++; print} END {for (date in count) print date, count[date]}' | less
            ;;
        "oldest")
            eval $find_command | sort -k3 | awk '{count[$3]++; print} END {for (date in count) print date, count[date]}' | less
            ;;
        "size-desc")
            eval $find_command | sort -k2 -nr | awk '{count[$2]++; print} END {for (size in count) print size, count[size]}' | less
            ;;
        "size-asc")
            eval $find_command | sort -k2 -n | awk '{count[$2]++; print} END {for (size in count) print size, count[size]}' | less
            ;;
        "type")
            eval $find_command | sort -k4 | awk '{count[$4]++; print} END {for (type in count) print type, count[type]}' | less
            ;;
    esac
    
    echo -e "\nPress Enter to return to the menu..."
    read -r
}

while true; do
    clear
    echo "Enter the directory to analyze:"
    read dir
    
    if [ ! -d "$dir" ]; then
        echo "Invalid directory!"
        sleep 2
        continue
    fi
    
    echo "Choose filtering option:"
    echo "1) No filter"
    echo "2) Starts with a given string"
    echo "3) Ends with a given string"
    echo "4) Contains a given string"
    read -p "Option: " filter_option
    
    filter_type="none"
    filter_value=""
    
    if [ "$filter_option" -ne 1 ]; then
        echo "Enter filter value:"
        read filter_value
        case $filter_option in
            2) filter_type="starts" ;;
            3) filter_type="ends" ;;
            4) filter_type="contains" ;;
        esac
    fi
    
    while true; do
        clear
        echo "Choose sorting option:"
        echo "1) Most recent"
        echo "2) Oldest"
        echo "3) Size (largest to smallest)"
        echo "4) Size (smallest to largest)"
        echo "5) File type"
        echo "6) Back to main menu"
        echo "7) Exit"
        read -p "Option: " sort_option
        
        case $sort_option in
            1) list_files "$dir" "recent" "$filter_type" "$filter_value" ;;
            2) list_files "$dir" "oldest" "$filter_type" "$filter_value" ;;
            3) list_files "$dir" "size-desc" "$filter_type" "$filter_value" ;;
            4) list_files "$dir" "size-asc" "$filter_type" "$filter_value" ;;
            5) list_files "$dir" "type" "$filter_type" "$filter_value" ;;
            6) break ;;
            7) exit 0 ;;
            *) echo "Invalid option!"; sleep 2 ;;
        esac
    done
done
