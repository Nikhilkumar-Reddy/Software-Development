#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
# trap -e 'echo -e "$R An error occurred in $LINENO, $BASH_COMMAND. Exiting... $N"' ERR  # Set up a trap to catch errors and print a message before exiting
R="\e[31m"  # Red color code
G="\e[32m"  # Green color code
Y="\e[33m"  # Yellow color code
N="\e[0m"   # Normal color code

SCRIPT_DIR=$PWD # Get the current working directory and store it in a variable
MONGODB_HOST="mongodb.lrn-devops.space"  # Define the MongoDB connection string 

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


dnf module disable nodejs -y &>> $LOGS_FILE
Function $? "Disable NodeJS module"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
Function $? "Enable NodeJS module"

dnf install nodejs -y &>> $LOGS_FILE
Function $? "Install NodeJS"

id roboshop &>> $LOGS_FILE

if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    Function $? "Create roboshop user"
else
    echo -e "$Y roboshop user already exists. Skipping user creation. $N" 
fi

mkdir -p /app   # Create the /app directory if it doesn't exist
Function $? "Create /app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
Function $? "Download catalogue code"

cd /app
Function $? "Change directory to /app"

rm -rf /app/*  # Remove all files in the /app directory
Function $? "Clean /app directory"

unzip /tmp/catalogue.zip &>> $LOGS_FILE
Function $? "Unzip catalogue code"

npm install  &>> $LOGS_FILE
Function $? "Install catalogue dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
Function $? "Copy catalogue service file"

systemctl daemon-reload &>> $LOGS_FILE
Function $? "Reload systemd daemon"

systemctl enable catalogue &>> $LOGS_FILE
Function $? "Enable catalogue service"

systemctl start catalogue &>> $LOGS_FILE
Function $? "Start catalogue service"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo 
Function $? "Copy MongoDB repository file"

dnf install mongodb-mongosh -y &>> $LOGS_FILE
Function $? "Install MongoDB shell"


INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
Function $? "Check if catalogue database exists"

if [ $INDEX -eq -1 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js> &>> $LOGS_FILE
    Function $? "Load catalogue database"
else
    echo -e "$Y catalogue database already exists. Skipping database loading. $N" 
fi

