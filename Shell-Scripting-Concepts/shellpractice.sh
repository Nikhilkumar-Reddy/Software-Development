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
    if [ $? -eq 0 ]; then    # Check the exit status of the last command
       echo " $1 successfully!"
    else
        echo " $1 failed." | tee -a $LOGS_FILE  # used to write the output to both console and log file
        exit 1
fi

}

dnf install nginxx -y  &>> $LOGS_FILE | tee -a $LOGS_FILE
Function "nginx is installed"


dnf install mysql -y  &>> $LOGS_FILE | tee -a $LOGS_FILE
Function "mysql is installed"


