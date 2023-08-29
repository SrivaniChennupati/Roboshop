#!/bin/bash

Logfiles_Directory=/tmp
Script_name=$0
Date=$(date +%F-%H-%M-%S)
Log_file=$Logfiles_Directory/$Script_name-$Date.log
user_id=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

validate(){

if [ $1 -ne 0 ] 
then
    echo -e "$2 .......$R FAILURE $N"
    exit 1
else 
    echo -e "$2....... $G SUCCESS $N"
fi        

}

if [ $user_id -ne 0 ]
then
    echo -e "$R ERROR : This should be Run with the Root Access $N"
    exit 1
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$Log_file

validate $? "Setting up the yum Repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$Log_file

validate $? "Setting up the yum Repo"

yum install rabbitmq-server -y &>>$Log_file

validate $? "Installing the rabbit mq server"


systemctl enable rabbitmq-server &>>$Log_file

validate $? "Enabling the rabbitmq"

systemctl start rabbitmq-server &>>$Log_file

validate $? "Starting the rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$Log_file

validate $? "Creating the user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Log_file

validate $? "Setting up the permissions"



