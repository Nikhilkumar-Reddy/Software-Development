#!/bin/bash

USERID=$(id -u)
echo "current user is: $USERID"

if [ $USERID -eq 0 ]; then
    echo "You are running this script as root."
    echo "You have root privileges."
else
    echo "You are running this script as a non-root user."
    exit 1
fi

Function() {
    if [ $? -eq 0 ]; then   
       echo "$s1 successfully!"
    else
        echo "$s1 failed."
        exit 1
fi

}

dnf install nginx -y
Function nginx is installed


dnf install mysql -y
Function mysql is installed


