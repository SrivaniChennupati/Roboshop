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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$Log_file

validate $? "Setting up the Redis Repo"

yum module enable redis:remi-6.2 -y &>>$Log_file

validate $? "Enabling the Redis version: 6.2"

yum install redis -y &>>$Log_file

validate $? "Installing Redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$Log_file

validate $? "updating the binding Ip"

systemctl enable redis &>>$Log_file

validate $? "Enabling the Redis"

systemctl start redis &>>$Log_file

validate $? "Starting the Redis"

