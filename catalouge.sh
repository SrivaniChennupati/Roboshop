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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$Log_file

validate $? "downloading Artifact"

cd /app &>>$Log_file

validate $? "Moving into App Directory"

if [ -d  /tmp/catalogue.zip ]
then
    echo "Folder is Already Unzipped"
else 
 unzip /tmp/catalogue.zip &>>$Log_file

fi
#unzip /tmp/catalogue.zip &>>$Log_file

validate $? "Unzipping the Artfacts"

npm install &>>$Log_file

validate $? "downloading Dependencies"

cp /home/centos/Roboshop/catalouge.service /etc/systemd/system/catalouge.service &>>$Log_file

validate $? "Creating/copying systemd service for Catalouge"

systemctl daemon-reload &>>$Log_file

validate $? "Loading the Catalouge Service"

systemctl enable catalouge &>>$Log_file

validate $? "Enabling the Catalouge Service"

systemctl start catalouge &>>$Log_file

validate $? "Starting the Catalouge Service"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>>$Log_file

validate $? "Craeting/Copying the mongo repo"

yum install mongodb-org-shell -y &>>$Log_file

validate $? "Installing mongo db Clinet"

mongo --host mongodb.devopsvani.online </app/schema/catalogue.js &>>$Log_file

validate $? " Loading the Schema into Mongodb"















