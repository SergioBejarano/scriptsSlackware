#!/bin/sh

while true; do
    echo -e "\nFile Search and Viewing Menu:"
    echo "1. Search for a file in a directory"
    echo "2. Search for a word in a file"
    echo "3. Search for a file and a word inside it"
    echo "4. Count the number of lines in a file"
    echo "5. Display the first n lines of a file"
    echo "6. Display the last n lines of a file"
    echo "7. Exit"
    
    echo -n "Choose an option: "; read option

    case $option in
        1)
            echo -n "Enter directory: "; read dir
            echo -n "Enter filename or part of it: "; read filename
            
            if [ -d "$dir" ]; then
                results=$(find "$dir" -type f -name "*$filename*" 2>/dev/null)
                echo "$results"
                echo "Total occurrences: $(echo "$results" | grep -c .)"
            else
                echo "Directory not found: $dir"
            fi
            ;;
        
        2)
            echo -n "Enter file path: "; read file
            echo -n "Enter word to search: "; read word
            
            if [ -f "$file" ]; then
                grep -n "$word" "$file"
                echo "Total occurrences: $(grep -c "$word" "$file" || echo 0)"
            else
                echo "File not found: $file"
            fi
            ;;
        
        3)
            echo -n "Enter directory: "; read dir
            echo -n "Enter filename or part of it: "; read filename
            echo -n "Enter word to search: "; read word
            
            if [ -d "$dir" ]; then
                find "$dir" -type f -name "*$filename*" 2>/dev/null | while read -r file; do
                    echo "Searching in: $file"
                    grep -n "$word" "$file"
                    echo "Total occurrences: $(grep -c "$word" "$file" || echo 0)"
                done
            else
                echo "Directory not found: $dir"
            fi
            ;;
        
        4)
            echo -n "Enter file path or filename: "; read file
            
            if [ -f "$file" ]; then
                echo "Total lines: $(wc -l < "$file")"
            else
                echo "File not found: $file"
            fi
            ;;
        
        5)
            echo -n "Enter file path: "; read file
            echo -n "Enter number of lines to display: "; read n
            
            if [ -f "$file" ] && [ "$n" -gt 0 ] 2>/dev/null; then
                head -n "$n" "$file"
            else
                echo "Invalid file or number of lines."
            fi
            ;;
        
        6)
            echo -n "Enter file path: "; read file
            echo -n "Enter number of lines to display: "; read n
            
            if [ -f "$file" ] && [ "$n" -gt 0 ] 2>/dev/null; then
                tail -n "$n" "$file"
            else
                echo "Invalid file or number of lines."
            fi
            ;;
        
        7)
            echo "Exiting..."
            break
            ;;
        
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
