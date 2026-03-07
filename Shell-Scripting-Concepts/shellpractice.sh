#!/bin/bash
userid=$(id -u)
echo "Current User ID: $userid"

Server=$1

if [ $userid -eq 0 ]; then
    echo "You are running this script as root."
    echo "You have root privileges."
    echo " Install $Server server "
    dnf install $Server -y
else
    echo "You are running this script as a non-root user."
    exit 1
fi

if [ $? -eq 0 ]; then   
    echo "$Server is installed successfully!"
else
    echo "$Server installation failed."
    exit 1
fi


echo " Since server install you can decide to uninstall or not :"

read -p "Enter 'yes' to uninstall or 'no' to keep: " server_uninstall

if [ "$server_uninstall" == "yes" ]; then
    dnf remove $server_uninstall -y
    if [ $? -eq 0 ]; then   
        echo "$server_uninstall is uninstalled successfully!"
    else
        echo "$server_uninstall uninstallation failed."
        exit 1
    fi
else
    echo "You chose not to uninstall $server_uninstall."
fi
