#!/bin/bash

#colour code
ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
    echo -e "Starting the Script $TIMESTAMP" &>> $LOGFILE
VALIDATE (){
             if [ $1 -ne 0 ]
            then 
                echo -e "$2 $R Failed$N"
                exit 1
            else
                echo -e "$2 $G Sucess$N"
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

dnf module disable nodejs -y &>> $LOGFILE
    VALIDATE $? "Disable NodeJS Old version"

dnf module enable nodejs:20 -y &>> $LOGFILE
    VALIDATE $? "Enable Noeja Version 20"

dnf install nodejs -y &>> $LOGFILE
    VALIDATE $? "Packange install nodejs"

id roboshop &>> $LOGFILE

   if [ $? -ne 0 ] 
    then 
        useradd roboshop &>> $LOGFILE
        VALIDATE $? "roboshop user creation"
    else
        echo -e "User all ready$Y exist$N"
    fi
mkdir -p /app &>> $LOGFILE
    VALIDATE $? "/app Folder Creation"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
    VALIDATE $? "Package download"

cd /app 
    VALIDATE $? "Directory Entry"
 
unzip -o /tmp/catalogue.zip &>> $LOGFILE
    VALIDATE $? "Package unzip status"

cd /app
    VALIDATE $? "Directory Entry"

npm install &>> $LOGFILE
    VALIDATE $? "npm install status"

cp /home/ec2-user/shellscript/roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
    VALIDATE $? "File Copy Status"

systemctl daemon-reload &>> $LOGFILE
    VALIDATE $? "daemon-reload Status"

systemctl enable catalogue &>> $LOGFILE
    VALIDATE $? "enable catalogue Status"

systemctl start catalogue &>> $LOGFILE
    VALIDATE $? "Catalogue Service Start Status"

cp /home/ec2-user/shellscript/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    VALIDATE $? "CopCopying mongodb repo" 

dnf install -y mongodb-mongosh  &>> $LOGFILE
    VALIDATE $? "mongod shell install"

mongosh --host mongodb.olavu.in </app/schema/catalogue.js &>> $LOGFILE
     VALIDATE $? "Loading Catalogue data to MongoDB"

