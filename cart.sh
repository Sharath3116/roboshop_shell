#!/bin/bash

#colour code
ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIMESTAMP.log"
    echo -e "Starting the Script $TIMESTAMP" &>> $LOG_FILE
VALIDATE (){
             if [ $1 -ne 0 ]
            then 
                echo -e "$2 $R Failed$N"
                exit 1
            else
                echo -e "$2 $G Success $N"
            fi 
            }
#checking root user status
if [ $ID -ne 0 ]
then
    echo -e "Please run script with$R root user $N"
    exit 1
else
    echo -e "Your running with $G root user $N"
fi

dnf module disable nodejs -y &>> $LOG_FILE

VALIDATE $? "Disable older Version nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE

VALIDATE $? "Eneble nodejs Version 20"

dnf install nodejs -y &>> $LOG_FILE

VALIDATE $? "Nodejs installation status"

id roboshop
    if [ $? -ne 0 ]
    then
        useradd roboshop &>> $LOG_FILE
        VALIDATE $? "User Creation status"
    else 
        echo -e "User allraedy exists $Y SKIPING $N"
        fi

mkdir -p /app &>> $LOG_FILE
    VALIDATE $? "Directory Creation"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOG_FILE
        VALIDATE $? "Download the application code to created app directory."

cd /app 
    VALIDATE $? "Directory Entry"
 
unzip -o /tmp/cart.zip &>> $LOGFILE
    VALIDATE $? "Package unzip status"

cd /app
    VALIDATE $? "Directory Entry"

npm install &>> $LOGFILE
    VALIDATE $? "npm install status"

cp //home/ec2-user/roboshop_shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
    VALIDATE $? "File Copy Status"

systemctl daemon-reload &>> $LOGFILE
    VALIDATE $? "daemon-reload Status"

systemctl enable cart &>> $LOGFILE
    VALIDATE $? "enable cart Status"

systemctl start cart &>> $LOGFILE
    VALIDATE $? "cart Service Start Status"
