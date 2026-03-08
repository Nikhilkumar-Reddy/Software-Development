#!/bin/bash


R="\e[31m"  # Red color code
G="\e[32m"  # Green color code
Y="\e[33m"  # Yellow color code
N="\e[0m"   # Normal color code

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
       echo -e "$G $2 successfully!" | tee -a $LOGS_FILE
    else
        echo -e "$R $2 failed !" | tee -a $LOGS_FILE  # used to write the output to both console and log file
        exit 1
fi

}



for package in nginx mysql node.js; do
    dnf list installed $package &>> $LOGS_FILE
    if [ $? -eq 0 ]; then
        echo -e "$Y $package is already installed." | tee -a $LOGS_FILE 
    else
        dnf install $package -y  &>> $LOGS_FILE | tee -a $LOGS_FILE
        Function -e $? " $N $package is installed now"
    fi
done



