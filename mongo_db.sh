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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$Log_file

yum install mongodb-org -y &>>$Log_file

validate $? "Mongodb Installation"

systemctl enable mongod &>>$Log_file

validate $? "Enabling Mongodb"

systemctl start mongod &>>$Log_file

validate $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Log_file

validate $? "Editing Mongodb"

systemctl restart mongod &>>$Log_file

validate $? "Restarting Mongodb"



