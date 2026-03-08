#!/bin/bash

USERID=$(id -u)
echo "current user is: $USERID"

LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="$LOGS_FOLDER/$0.log"
mkdir -p $LOGS_FOLDER
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

dnf install nginx -y  &>> $LOGS_FILE
Function nginx is installed


dnf install mysql -y  &>> $LOGS_FILE
Function mysql is installed


