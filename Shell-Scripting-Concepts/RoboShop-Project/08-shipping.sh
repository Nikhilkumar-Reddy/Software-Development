#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
# trap -e 'echo -e "$R An error occurred in $LINENO, $BASH_COMMAND. Exiting... $N"' ERR  # Set up a trap to catch errors and print a message before exiting
R="\e[31m"  # Red color code
G="\e[32m"  # Green color code
Y="\e[33m"  # Yellow color code
N="\e[0m"   # Normal color code

SCRIPT_DIR=$PWD # Get the current working directory and store it in a variable
MYSQL_HOST="mysql.lrn-devops.space"  # Define the MongoDB connection string 

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


dnf install maven -y &>> $LOGS_FILE
Function $? "Install Maven"

id roboshop &>> $LOGS_FILE

if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    Function $? "Create roboshop user"
else
    echo -e "$Y roboshop user already exists. Skipping user creation. $N" 
fi

mkdir -p /app   # Create the /app directory if it doesn't exist
Function $? "Create /app directory"

curl  -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
Function $? "Download shipping code"

cd /app
Function $? "Change directory to /app"

rm -rf /app/*  # Remove all files in the /app directory
Function $? "Clean /app directory"

unzip /tmp/shipping.zip &>> $LOGS_FILE
Function $? "Unzip shipping code"

cd /app
Function $? "Change directory to /app"

mvn clean package 
Function $? "Build shipping code"

mv target/shipping-1.0.jar shipping.jar 
Function $? "Move shipping jar file"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
Function $? "Copy shipping service file"


systemctl daemon-reload &>> $LOGS_FILE
Function $? "Reload systemd daemon"

systemctl enable shipping &>> $LOGS_FILE
Function $? "Enable shipping service"

systemctl start shipping &>> $LOGS_FILE
Function $? "Start shipping service"


dnf install mysql -y &>> $LOGS_FILE
Function $? "Install mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [$? -ne 0]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
else 
    echo -e "data is already loaded ..... $Y Skipping $N"
fi

systemctl restart shipping
Function $? " Restarting Shipping service" 