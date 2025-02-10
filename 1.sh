#!/bin/bash

# Function to list files with detailed information
list_files() {
    local dir=$1
    local recursive=$2
    local find_command="find \"$dir\""

    if [ "$recursive" == "no" ]; then
        find_command+=" -maxdepth 1"
    fi

    eval "$find_command" -type f -exec stat --format="%Y %s %F %n" {} + | sort -k1,1n
}

# Function to display files sorted by modification time
sort_by_modification_time() {
    local dir=$1
    local order=$2
    local recursive=$3

    list_files "$dir" "$recursive" | sort -k1,1"$order" | awk '
    {
        mod_time = strftime("%Y-%m-%d", $1);
        size = $2;
        type = $3;
        name = substr($0, index($0, $4));
        count[mod_time]++;
        files[mod_time] = files[mod_time] name "\n";
    }
    END {
        for (date in files) {
            print "Date: " date " (" count[date] " files)";
            print files[date];
        }
    }' | less
}

# Function to display files sorted by size
sort_by_size() {
    local dir=$1
    local order=$2
    local recursive=$3

    list_files "$dir" "$recursive" | sort -k2,2"$order" -k1,1n | awk '
    {
        mod_time = strftime("%Y-%m-%d", $1);
        size = $2;
        type = $3;
        name = substr($0, index($0, $4));
        count[size]++;
        files[size] = files[size] name "\n";
    }
    END {
        for (size in files) {
            print "Size: " size " bytes (" count[size] " files)";
            print files[size];
        }
    }' | less
}

# Function to display files grouped by type
group_by_type() {
    local dir=$1
    local recursive=$2
    local find_command="find \"$dir\""

    if [ "$recursive" == "no" ]; then
        find_command+=" -maxdepth 1"
    fi

    eval "$find_command" -exec stat --format="%F %n" {} + | sort -k1,1 | awk '
    {
        type = $1;
        name = substr($0, index($0, $2));
        count[type]++;
        files[type] = files[type] name "\n";
    }
    END {
        for (type in files) {
            print "Type: " type " (" count[type] " items)";
            print files[type];
        }
    }' | less
}

# Function to filter files based on a pattern
filter_files() {
    local dir=$1
    local pattern=$2
    local recursive=$3
    local find_command="find \"$dir\""

    if [ "$recursive" == "no" ]; then
        find_command+=" -maxdepth 1"
    fi

    eval "$find_command" -name "$pattern" -exec stat --format="%F %n" {} + | less
}

# Main menu function
main_menu() {
    local dir
    local recursive
    local choice

    read -rp "Enter the directory to analyze: " dir
    if [ ! -d "$dir" ]; then
        echo "Invalid directory. Exiting."
        exit 1
    fi

    read -rp "Include subdirectories? (yes/no): " recursive
    if [[ "$recursive" != "yes" && "$recursive" != "no" ]]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi

    while true; do
        clear
        echo "Menu:"
        echo "1. Sort by most recent modification date"
        echo "2. Sort by oldest modification date"
        echo "3. Sort by size (largest to smallest)"
        echo "4. Sort by size (smallest to largest)"
        echo "5. Group by file type"
        echo "6. Filter files starting with a given string"
        echo "7. Filter files ending with a given string"
        echo "8. Filter files containing a given string"
        echo "9. Exit"
        read -rp "Choose an option: " choice

        case $choice in
            1)
                sort_by_modification_time "$dir" "r" "$recursive"
                ;;
            2)
                sort_by_modification_time "$dir" "" "$recursive"
                ;;
            3)
                sort_by_size "$dir" "r" "$recursive"
                ;;
            4)
                sort_by_size "$dir" "" "$recursive"
                ;;
            5)
                group_by_type "$dir" "$recursive"
                ;;
            6)
                read -rp "Enter the starting string: " str
                filter_files "$dir" "$str*" "$recursive"
                ;;
            7)
                read -rp "Enter the ending string: " str
                filter_files "$dir" "*$str" "$recursive"
                ;;
            8)
                read -rp "Enter the containing string: " str
                filter_files "$dir" "*$str*" "$recursive"
                ;;
            9)
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
        read -rp "Press Enter to continue..."
    done
}

# Run the main menu
main_menu
