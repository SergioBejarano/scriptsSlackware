#!/bin/bash

while true; do
    echo "\n===== FILE MANAGEMENT MENU ====="
    echo "1. Search for a file by name"
    echo "2. Search for a word in a file"
    echo "3. Search for a file and then search for a word inside it"
    echo "4. Count the number of lines in a file"
    echo "5. Display the first N lines of a file"
    echo "6. Display the last N lines of a file"
    echo "7. Exit"
    echo -n "Choose an option: "
    read option
    
    case $option in
        1)
            echo -n "Enter directory to search in: "
            read dir
            echo -n "Enter filename or part of it: "
            read filename
            results=$(find "$dir" -type f -name "*$filename*" 2>/dev/null)
            count=$(echo "$results" | wc -l)
            echo "Found files:\n$results"
            echo "Total occurrences: $count"
            ;;
        
        2)
            echo -n "Enter file path: "
            read filepath
            echo -n "Enter word to search for: "
            read word
            grep -n "$word" "$filepath" 2>/dev/null
            count=$(grep -c "$word" "$filepath" 2>/dev/null)
            echo "Total occurrences: $count"
            ;;
        
        3)
            echo -n "Enter directory to search in: "
            read dir
            echo -n "Enter filename or part of it: "
            read filename
            echo -n "Enter word to search inside found files: "
            read word
            files=$(find "$dir" -type f -name "*$filename*" 2>/dev/null)
            for file in $files; do
                echo "Searching in: $file"
                grep -n "$word" "$file" 2>/dev/null
                count=$(grep -c "$word" "$file" 2>/dev/null)
                echo "Total occurrences in $file: $count"
            done
            ;;
        
        4)
            echo -n "Enter file path: "
            read filepath
            count=$(wc -l < "$filepath")
            echo "Total lines: $count"
            ;;
        
        5)
            echo -n "Enter file path: "
            read filepath
            echo -n "Enter number of lines to display: "
            read n
            head -n "$n" "$filepath"
            ;;
        
        6)
            echo -n "Enter file path: "
            read filepath
            echo -n "Enter number of lines to display: "
            read n
            tail -n "$n" "$filepath"
            ;;
        
        7)
            echo "Exiting..."
            exit 0
            ;;
        
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo "\nPress Enter to continue..."
    read
done
