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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $Log_file

validate $? "Setting up the NodeJS Repo"

yum install nodejs -y &>>$Log_file

validate $? "Installing NodeJS"

id roboshop &>>$Log_file

if [ $? -ne 0 ]
then 
    echo -e  " $R ERROR : No such User.$N Lets add the User......"
    useradd roboshop &>>$Log_file
else 

  echo "User added already"

fi 

cd /app &>>$Log_file

if [ $? -ne 0 ]
then 
    echo -e  " $R ERROR : No such File/Directory.$N Lets create the Directory......"
    mkdir /app &>>$Log_file
    validate $? "Creating a directory"
else 
  echo "Directory Created already"

fi

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$Log_file

validate $? "downloading Artifact"

cd /app &>>$Log_file

validate $? "Moving into App Directory"

unzip -o /tmp/cart.zip &>>$Log_file

validate $? "Unzipping the Cart Artfact"

npm install &>>$Log_file

validate $? "downloading Dependencies"

cp /home/centos/Roboshop/cart.service /etc/systemd/system/cart.service &>>$Log_file

validate $? "Creating/copying systemd service for cart"

systemctl daemon-reload &>>$Log_file

validate $? "Loading the Cart Service"

systemctl enable cart &>>$Log_file

validate $? "Enabling the cart Service"

systemctl start cart &>>$Log_file

validate $? "Starting the cart Service"