#!/bin/bash

Date=$(date +%F-%H-%M-%S)
Script_name=$0
Log_file=$Logfiles_Directory/$Script_name-$Date.log
Logfiles_Directory=/tmp

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

validate() {
if [ $1 -ne 0 ]
then
    echo -e "$2.......$R FAILURE $N"
    exit 1 
else 

    echo  -e "$2.......$G SUCCESS $N"
fi    
}

user_id=$(id -u)

if [ $user_id -ne 0 ] 
then
    echo -e "$R ERROR : This command has to run with the Root Access $N"
    exit 1 

fi 

yum install nginx -y &>>$Log_file

validate $? "NGINX Installation"

systemctl enable nginx &>>$Log_file 

validate $? "NGINX Enabling"

systemctl start nginx &>>$Log_file

validate $? "NGINX Starting"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$Log_file

validate $? "Artifact Download"

cd /usr/share/nginx/html

unzip /tmp/web.zip &>>$Log_file

systemctl restart nginx 

validate $? "NGINX Restaring"

cp /home/centos/Roboshop/roboshop.conf /etc/nginx/default.d/roboshop.conf












