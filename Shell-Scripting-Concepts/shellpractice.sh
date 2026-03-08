#!/bin/bash

USERID=$(id -u)  # Get the current user ID and store it in a variable
echo "current user is: $USERID"  

LOGS_FOLDER="/var/log/shell-script"  # Define the logs folder path
LOGS_FILE="$LOGS_FOLDER/$0.log"   # Define the log file path using the script name

# Create the logs folder if it doesn't exist
mkdir -p $LOGS_FOLDER     
# Check if the user ID is 0 (root)
if [ $USERID -eq 0 ]; then   
    echo "You are running this script as root."
    echo "You have root privileges."
else
    echo "You are running this script as a non-root user."
    exit 1
fi

Function() {
    if [ $1 -eq 0 ]; then    # Check the exit status of the last command
       echo " $2 successfully!" | tee -a $LOGS_FILE
    else
        echo " $2 failed !" | tee -a $LOGS_FILE  # used to write the output to both console and log file
        exit 1
fi

}



for package in nginx mysql node.js; do
    dnf list installed $package &>> $LOGS_FILE
    if [ $? -eq 0 ]; then
        echo "$package is already installed." | tee -a $LOGS_FILE
        exit 1
    else
        dnf install $package -y  &>> $LOGS_FILE | tee -a $LOGS_FILE
        Function $? "$package is installed now"
    fi
done



