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

yum install python36 gcc python3-devel -y &>>$Log_file

validate $? "Installing python"

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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$Log_file

validate $? "Downloading the payment artifact"

cd /app &>>$Log_file

validate $? "moving to the app directory"

unzip -o /tmp/payment.zip &>>$Log_file

validate $? "unzipping the payment package"

pip3.6 install -r requirements.txt &>>$Log_file

validate $? "downloading the dependencies"

cp /home/centos/Roboshop/payment.service /etc/systemd/system/payment.service &>>$Log_file

validate $? "copying the payment service"

systemctl daemon-reload &>>$Log_file

validate $? "loading the paymnet service"

systemctl enable payment &>>$Log_file

validate $? "Enabling the Payment Service"

systemctl start payment &>>$Log_file

validate $? "Starting the payment service"


