#!bin/bash
userid=$(id -u)
echo "Current User ID: $userid"

if [ $userid -eq 0 ]; then
    echo "You are running this script as root."
    echo "You have root privileges."
    echo " Install Nginx Web Server "
    dnf install nginx -y
else
    echo "You are running this script as a non-root user."
    exit 1
fi

if [ -f "/etc/nginx/nginx.conf" ]; then
    echo "Nginx is installed successfully!"
    dnf remove nginx -y
else
    echo "Nginx installation failed."

    exit 1
fi

