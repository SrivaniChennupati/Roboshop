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

yum install maven -y &>>$Log_file

validate $? "Installing the Maven"

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$Log_file

validate $? "downloading the shipping artifact"

cd /app &>>$Log_file

validate $? "Moving to App directory"

unzip -o /tmp/shipping.zip &>>$Log_file

validate $? "unzipping the shipping package"

mvn clean package &>>$Log_file

validate $? "downloading the dependecies"

mv target/shipping-1.0.jar shipping.jar &>>$Log_file

validate $? "moving jar file from target location"

cp /home/centos/Roboshop/shipping.service /etc/systemd/system/shipping.service &>>$Log_file

validate $? "copying the shipping service file"

systemctl daemon-reload &>>$Log_file

validate $? "loading the shipping service"

systemctl enable shipping &>>$Log_file

validate $? "enabling the shipping service"

systemctl start shipping &>>$Log_file

validate $? "starting the shipping service"

yum install mysql -y &>>$Log_file

validate $? "Installing mysql client"

mysql -h mysql.devopsvani.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$Log_file

validate $? "loading the schema to mysql db"

systemctl restart shipping &>>$Log_file

validate $? "Restarting the shipping service"



