#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
# trap -e 'echo -e "$R An error occurred in $LINENO, $BASH_COMMAND. Exiting... $N"' ERR  # Set up a trap to catch errors and print a message before exiting
R="\e[31m"  # Red color code
G="\e[32m"  # Green color code
Y="\e[33m"  # Yellow color code
N="\e[0m"   # Normal color code

SCRIPT_DIR=$PWD # Get the current working directory and store it in a variable
MONGODB_HOST="mongodb.lrn-devops.space"  # Define the MongoDB connection string 

USERID=$(id -u)  # Get the current cart ID and store it in a variable 

LOGS_FOLDER="/var/log/RoboShop-Project"  # Define the logs folder path
LOGS_FILE="$LOGS_FOLDER/$0.log"   # Define the log file path using the script name

# Create the logs folder if it doesn't exist
mkdir -p $LOGS_FOLDER     
# Check if the user ID is 0 (root)
if [ $USERID -eq 0 ]; then   
    echo "You are running this script as root."
    echo "You have root privileges."
else
    echo "You are running this script as a non-root cart."
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


dnf module disable nodejs -y &>> $LOGS_FILE
Function $? "Disable NodeJS module"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
Function $? "Enable NodeJS module"

dnf install nodejs -y &>> $LOGS_FILE
Function $? "Install NodeJS"

id roboshop &>> $LOGS_FILE

if [ $? -ne 0 ]; then
    cartadd --system --home /app --shell /sbin/nologin --comment "roboshop system cart" roboshop
    Function $? "Create roboshop cart"
else
    echo -e "$Y roboshop cart already exists. Skipping cart creation. $N" 
fi

mkdir -p /app   # Create the /app directory if it doesn't exist
Function $? "Create /app directory"

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
Function $? "Download cart code"

cd /app
Function $? "Change directory to /app"

rm -rf /app/*  # Remove all files in the /app directory
Function $? "Clean /app directory"

unzip /tmp/cart.zip &>> $LOGS_FILE
Function $? "Unzip cart code"

npm install  &>> $LOGS_FILE
Function $? "Install cart dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
Function $? "Copy cart service file"

systemctl daemon-reload &>> $LOGS_FILE
Function $? "Reload systemd daemon"

systemctl enable cart &>> $LOGS_FILE
Function $? "Enable cart service"

systemctl start cart &>> $LOGS_FILE
Function $? "Start cart service"
