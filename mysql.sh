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

yum module disable mysql -y &>>$Log_file

validate $? "disabling MySQL 8 version"

cp /home/centos/Roboshop/mysql.repo /etc/yum.repos.d/mysql.repo &>>$Log_file

validate $? "setting up the Repo"

yum install mysql-community-server -y &>>$Log_file

validate $? "Installing mysql community Server"

systemctl enable mysqld &>>$Log_file

validate $? "Enabling the mysql"

systemctl start mysqld &>>$Log_file

validate $? "Starting the Mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$Log_file

validate $? " changing the default root password i"

mysql -uroot -pRoboShop@1 &>>$Log_file

validate $? "checking the new password working or not"


