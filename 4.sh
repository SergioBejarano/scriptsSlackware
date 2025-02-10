#!/bin/bash

newuser() {
    username=$1
    group=$2
    full_name=$3
    home_dir=$4
    shell=$5
    perm_home=$6
    perm_group=$7
    perm_other=$8
    
    # Create the group if it does not exist
    if ! getent group "$group" >/dev/null; then
        sudo groupadd "$group"
        echo "Group '$group' created."
    fi
    
    # Create the user
    sudo useradd -m -d "$home_dir" -s "$shell" -c "$full_name" -g "$group" "$username"
    echo "User '$username' created with home directory '$home_dir' and shell '$shell'."
    
    # Set permissions
    sudo chmod "$perm_home" "$home_dir"
    sudo chmod "$perm_group" "/home/$username"
    sudo chmod "$perm_other" "/home/$username"
    echo "Permissions set: Home ($perm_home), Group ($perm_group), Other ($perm_other)"
}

newgroup() {
    groupname=$1
    gid=$2
    
    if ! getent group "$groupname" >/dev/null; then
        sudo groupadd -g "$gid" "$groupname"
        echo "Group '$groupname' created with GID '$gid'."
    else
        echo "Group '$groupname' already exists."
    fi
}

if [[ "$1" == "newuser" ]]; then
    shift
    newuser "$@"
elif [[ "$1" == "newgroup" ]]; then
    shift
    newgroup "$@"
else
    echo "Usage: $0 {newuser|newgroup} args..."
    exit 1
fi
