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

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "mysql installation"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enable mysqld"

systemctl start mysql   &>> $LOGFILE
VALIDATE $? "mysql service start"   

mysql_secure_installation --set-root-pass RoboShop@1    &>> $LOGFILE
VALIDATE $? "test mysql db connection"

