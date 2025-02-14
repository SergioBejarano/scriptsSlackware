#!/bin/bash

# Función para limpiar la pantalla
clear_screen() {
    clear
}

# Función para mostrar las últimas 15 líneas de los logs del sistema
show_last_logs() {
    # Definir los archivos de logs a revisar
    log_files=("/var/log/syslog" "/var/log/messages" "/var/log/dmesg")

    # Iterar sobre cada archivo de log y mostrar sus últimas 15 líneas
    for log in "${log_files[@]}"; do
        echo -e "\\n===== [LOG: $log] ====="
        tail -n 15 "$log"
    done
}

# Función para filtrar logs por una palabra clave ingresada por el usuario
filter_logs() {
    # Pedir al usuario que ingrese una palabra clave para filtrar los logs
    read -p "Enter the keyword to filter: " keyword
    log_files=("/var/log/syslog" "/var/log/messages" "/var/log/dmesg")

    # Iterar sobre cada archivo de log, mostrar sus últimas 15 líneas y aplicar el filtro
    for log in "${log_files[@]}"; do
        echo -e "\\n===== [LOG: $log] ====="
        tail -n 15 "$log" | grep --color=always "$keyword"
    done
}

# Bucle principal del menú
while true; do
    # Limpiar la pantalla antes de mostrar el menú
    clear_screen
    echo "===== LOG MANAGEMENT MENU ====="
    echo "1. Show last 15 lines of system logs"
    echo "2. Filter last 15 lines by keyword"
    echo "3. Exit"
    echo -n "Choose an option: "
    read option
    
    # Evaluar la opción ingresada por el usuario
    case $option in
        1)
            show_last_logs  # Llamar a la función para mostrar los logs
            ;;
        2)
            filter_logs  # Llamar a la función para filtrar logs
            ;;
        3)
            echo "Exiting..."
            exit 0  # Salir del script
            ;;
        *)
            echo "Invalid option, try again."  # Mensaje de error para opciones inválidas
            ;;
    esac
    
    # Esperar a que el usuario presione Enter antes de continuar
    echo "\nPress Enter to continue..."
    read
done
