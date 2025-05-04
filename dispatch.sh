$!/bin/bash

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
        echo -e "$2 $G Failed $N"
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
dnf install golang  -y &>> $LOGFILE
    VALIDATE $? "Packange install golang"

id roboshop &>> $LOGFILE

   if [ $? -ne 0 ] 
    then 
        useradd roboshop &>> $LOGFILE
        VALIDATE $? "roboshop user creation"
    else
        echo -e "User all ready$Y exist$N"
    fi
