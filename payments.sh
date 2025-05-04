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

dnf install python3.11 gcc python3-devel -y &>> $LOGFILE
    VALIDATE $? "python package install"

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Adding roboshop user"
else
    echo -e "roboshop user already exist...$Y SKIPPING $N"
fi

rm -rf /app &>> $LOGFILE
VALIDATE $? "clean up existing directory"

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "Downloading shipping application"

cd /app  &>> $LOGFILE
VALIDATE $? "Moving to app directory"

unzip /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "Extracting payment application"

pip3.11 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/roboshop_shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? "Copying payment service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Daemon reload"

systemctl enable payment &>> $LOGFILE
VALIDATE $? "Enable payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? "Start payment"