#!/bin/bash

# Función para listar archivos en un directorio con diferentes criterios de filtrado y ordenamiento
list_files() {
    local dir="$1"          # Directorio a analizar
    local option="$2"       # Criterio de ordenamiento
    local filter_type="$3"  # Tipo de filtro (empieza, termina o contiene)
    local filter_value="$4" # Valor del filtro (cadena ingresada por el usuario)

    # Construcción del comando `find` para listar archivos en el directorio especificado
    find_command="find \"$dir\""

    # Aplicar filtros según el tipo especificado
    if [ "$filter_type" = "starts" ]; then
        find_command+=" -name \"$filter_value*\"" # Filtrar archivos que empiezan con el valor dado
    elif [ "$filter_type" = "ends" ]; then
        find_command+=" -name \"*$filter_value\"" # Filtrar archivos que terminan con el valor dado
    elif [ "$filter_type" = "contains" ]; then
        find_command+=" -name \"*$filter_value*\"" # Filtrar archivos que contienen el valor dado
    else
        find_command+=" -name \"*\"" # No aplicar filtro
    fi

    # Agregar formato de salida: ruta, tamaño, fecha de modificación y tipo de archivo
    find_command+=" -printf '%p %s %TY-%Tm-%Td %y\n'"

    clear # Limpiar pantalla antes de mostrar resultados

    # Aplicar ordenamiento según la opción seleccionada
    case $option in
        "recent")
            # Ordenar por fecha de modificación más reciente y contar archivos por fecha
            eval $find_command | sort -k3 -r | awk '{count[$3]++; print} END {for (date in count) print date, count[date]}' | more
            ;;
        "oldest")
            # Ordenar por fecha de modificación más antigua y contar archivos por fecha
            eval $find_command | sort -k3 | awk '{count[$3]++; print} END {for (date in count) print date, count[date]}' | more
            ;;
        "size-desc")
            # Ordenar por tamaño de mayor a menor y contar archivos por tamaño
            eval $find_command | sort -k2 -nr | awk '{count[$2]++; print} END {for (size in count) print size, count[size]}' | more
            ;;
        "size-asc")
            # Ordenar por tamaño de menor a mayor y contar archivos por tamaño
            eval $find_command | sort -k2 -n | awk '{count[$2]++; print} END {for (size in count) print size, count[size]}' | more
            ;;
        "type")
            # Ordenar por tipo de archivo y contar la cantidad de cada tipo
            eval $find_command | sort -k4 | awk '{count[$4]++; print} END {for (type in count) print type, count[type]}' | more
            ;;
    esac

    # Esperar que el usuario presione Enter antes de volver al menú
    echo -e "\nPresiona Enter para volver al menú..."
    read -r
}

# Bucle principal para solicitar el directorio y aplicar filtros
while true; do
    clear
    echo "Enter the directory to analyze:" # Solicitar directorio al usuario
    read dir
    
    # Verificar si el directorio ingresado es válido
    if [ ! -d "$dir" ]; then
        echo "Invalid directory!"
        sleep 2
        continue
    fi

    # Menú de opciones para filtrar archivos
    echo "Choose filtering option:"
    echo "1) No filter"
    echo "2) Starts with a given string"
    echo "3) Ends with a given string"
    echo "4) Contains a given string"
    read -p "Option: " filter_option

    filter_type="none"
    filter_value=""

    # Aplicar el tipo de filtro basado en la opción elegida
    if [ "$filter_option" -ne 1 ]; then
        echo "Enter filter value:" # Pedir el valor del filtro
        read filter_value
        case $filter_option in
            2) filter_type="starts" ;;  # Filtrar archivos que empiezan con la cadena ingresada
            3) filter_type="ends" ;;    # Filtrar archivos que terminan con la cadena ingresada
            4) filter_type="contains" ;;# Filtrar archivos que contienen la cadena ingresada
        esac
    fi

    # Bucle para elegir el método de ordenamiento
    while true; do
        clear
        echo "Choose sorting option:"
        echo "1) Most recent"                     # Ordenar por archivos más recientes
        echo "2) Oldest"                          # Ordenar por archivos más antiguos
        echo "3) Size (largest to smallest)"      # Ordenar por tamaño descendente
        echo "4) Size (smallest to largest)"      # Ordenar por tamaño ascendente
        echo "5) File type"                       # Ordenar por tipo de archivo
        echo "6) Back to main menu"               # Volver al menú principal
        echo "7) Exit"                            # Salir del programa
        read -p "Option: " sort_option

        # Ejecutar la función `list_files` con el criterio de ordenamiento elegido
        case $sort_option in
            1) list_files "$dir" "recent" "$filter_type" "$filter_value" ;;
            2) list_files "$dir" "oldest" "$filter_type" "$filter_value" ;;
            3) list_files "$dir" "size-desc" "$filter_type" "$filter_value" ;;
            4) list_files "$dir" "size-asc" "$filter_type" "$filter_value" ;;
            5) list_files "$dir" "type" "$filter_type" "$filter_value" ;;
            6) break ;;  # Volver al menú principal
            7) exit 0 ;;  # Salir del script
            *) echo "Invalid option!"; sleep 2 ;; # Mensaje de error para opciones no válidas
        esac
    done
done
