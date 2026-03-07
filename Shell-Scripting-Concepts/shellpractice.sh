#!bin/bash
userid=$(id -u)
echo "Current User ID: $userid"

if [ $userid -eq 0 ]; then
    echo "You are running this script as root."
    echo "You have root privileges."
    echo " Install Nginx Web Server "
    apt update
    apt install nginx -y
else
    echo "You are running this script as a non-root user."
fi


