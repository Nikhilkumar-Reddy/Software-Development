#!bin/bash
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

if [ -f "/etc/$Server/$Server.conf" ]; then   
    echo "$Server is installed successfully!"
else
    echo "$Server installation failed."
    exit 1
fi

