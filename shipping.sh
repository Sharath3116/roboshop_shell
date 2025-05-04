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

dnf install maven -y &>> $LOGFILE
    VALIDATE $? "Packange install maven"

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
    VALIDATE $? "Package download"

cd /app 
    VALIDATE $? "Directory Entry"

mvn clean package &>> "$LOGFILE"
VALIDATE $? "Maven build"
 
mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
    VALIDATE $? "Package unzip status"

cp /home/ec2-user/shellscript/roboshop/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
    VALIDATE $? "File Copy Status"

systemctl daemon-reload &>> $LOGFILE
    VALIDATE $? "daemon-reload Status"

systemctl enable shipping &>> $LOGFILE
    VALIDATE $? "enable shipping Status"

systemctl start shipping &>> $LOGFILE
    VALIDATE $? "shipping Service Start Status"

dnf install mysql -y &>> $LOGFILE
    VALIDATE $? "mysql installation"

mysql -h mysql.olavu.in -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql.olavu.in -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h mysql.olavu.in -uroot -pRoboShop@1 < /app/db/master-data.sql

systemctl restart shipping &>> $LOGFILE
    VALIDATE $? "Restarting shipping service"