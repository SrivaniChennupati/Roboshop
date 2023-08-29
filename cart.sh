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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$Log_file

validate $? "Setting up the nodejs Repo"

yum install nodejs -y &>>$Log_file

validate $? "Installing Nodejs"

id roboshop &>>$Log_file

if [ $? -ne 0 ]
then 
    echo -e  " $R ERROR : No such User.$N Lets add the User......"
    useradd roboshop &>>$Log_file
else 

  echo "User added already"

fi 

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$Log_file

validate $? "Downloading cart Artifact"

cd /app 

validate $? "Moving to app directory"

unzip -o /tmp/cart.zip

validate $? "Unzipping the cart artifact"

npm install &>>$Log_file

validate $? "Downloading Dependencies"

cp /home/centos/Roboshop/cart.service /etc/systemd/system/cart.service &>>$Log_file

validate $? "Copying/creating the systemd cart service"

systemctl daemon-reload &>>$Log_file

validate $? "Loading the cart Service"

systemctl enable cart &>>$Log_file

validate $? "Enabling the cart SErvice"

systemctl start cart &>>$Log_file

validate $? "starting the cart SErvice"

