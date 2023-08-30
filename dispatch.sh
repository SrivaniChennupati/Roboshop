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

yum install golang -y &>>$Log_file

validate $? " Installing golang"

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

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>>$Log_file

validate $? " downloading dispatch artifact"

cd /app  &>>$Log_file

validate $? " moving to app directory"

unzip /tmp/dispatch.zip &>>$Log_file

validate $? "unzipping the dispatch package"


go mod init dispatch &>>$Log_file

validate $? "downloding the dependencies"

go get &>>$Log_file

validate $? "downloding the dependencies"

go build &>>$Log_file

validate $? "build the software"

cp /home/centos/Roboshop/dispatch.service /etc/systemd/system/dispatch.service &>>$Log_file

validate $? "copying dispatch service"

systemctl daemon-reload &>>$Log_file

validate $? " loading the dispatch service"

systemctl enable dispatch &>>$Log_file

validate $? " enabling the dispatch service"

systemctl start dispatch &>>$Log_file

validate $? "starting the dispatch service"