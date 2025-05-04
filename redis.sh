#!/bin/bash

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

dnf install redis -y &>> $LOGFILE

VALIDATE $? "Redis installation"

sed -i 's/127.0.0.1/0.0.0.0/g' /ect/redis/redis.conf &>> $LOGFILE

VALIDATE $? "Verify Ports"

systemctl enable redis

VALIDATE $? "Enabling redis applicatation"

systemctl start redis

VALIDATE $? "Starting redis service"


