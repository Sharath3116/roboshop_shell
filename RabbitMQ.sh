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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
    VALIDATE $? "Package download erlan"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
    VALIDATE $? "Package download rabbitmq"

dnf install rabbitmq-server -y &>> $LOGFILE
    VALIDATE $? "rabbitmq package install"

systemctl enable rabbitmq-server &>> $LOGFILE
    VALIDATE $? "Enable rabbitmq"

systemctl start rabbitmq-server &>> $LOGFILE
    VALIDATE $? "rabbitmq service start"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
    VALIDATE $? "rabbitmq package install"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
    VALIDATE $? "rabbitmq package install"
