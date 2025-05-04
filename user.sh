#!/bin/bash

ID=$(id -u)

#Colour Code
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE (){
    if [ $1 -ne 0 ]
    then    
        echo -e "$2 $R Failed $N"
        exit 1
    else
        echo -e "$2 $G Sucess $N"
    fi
}

#Checking root access"
if [ $ID -ne 0 ]
then 
    echo -e "Please run script $R root user $N" &>> $LOG_FILE
    exit 1
else
    echo -e "Your $G root user $N" &>> $LOG_FILE

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

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOG_FILE
        VALIDATE $? "Download the application code to created app directory."

cd /app 
    VALIDATE $? "Directory Entry"
 
unzip -o /tmp/user.zip &>> $LOG_FILE
    VALIDATE $? "Package unzip status"

cd /app
    VALIDATE $? "Directory Entry"

npm install &>> $LOG_FILE
    VALIDATE $? "npm install status"

cp home/ec2-user/roboshop_shell/cuser.service /etc/systemd/system/user.service &>> $LOG_FILE
    VALIDATE $? "File Copy Status"

systemctl daemon-reload &>> $LOG_FILE
    VALIDATE $? "daemon-reload Status"

systemctl enable user &>> $LOG_FILE
    VALIDATE $? "enable user Status"

systemctl start user &>> $LOG_FILE
    VALIDATE $? "user Service Start Status"

cp /home/ec2-user/shellscript/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
    VALIDATE $? "CopCopying mongodb repo" 

dnf install mongodb-mongosh -y &>> $LOG_FILE
    VALIDATE $? "mongod shell install"

mongo --host mongodb.olavu.in </app/schema/user.js &>> $LOG_FILE
     VALIDATE $? "Loading user data to MongoDB"
