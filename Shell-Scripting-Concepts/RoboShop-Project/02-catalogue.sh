#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
# trap -e 'echo -e "$R An error occurred in $LINENO, $BASH_COMMAND. Exiting... $N"' ERR  # Set up a trap to catch errors and print a message before exiting
R="\e[31m"  # Red color code
G="\e[32m"  # Green color code
Y="\e[33m"  # Yellow color code
N="\e[0m"   # Normal color code

USERID=$(id -u)  # Get the current user ID and store it in a variable 

LOGS_FOLDER="/var/log/RoboShop-Project"  # Define the logs folder path
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


dnf module disable nodejs -y
Function $? "Disable NodeJS module"

dnf module enable nodejs:20 -y
Function $? "Enable NodeJS module"

dnf install nodejs -y
Function $? "Install NodeJS"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
Function $? "Create roboshop user"

mkdir /app 
Function $? "Create /app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
Function $? "Download catalogue code"

cd /app
Function $? "Change directory to /app"

unzip /tmp/catalogue.zip
Function $? "Unzip catalogue code"

