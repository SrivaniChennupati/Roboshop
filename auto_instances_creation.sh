#!/bin/bash

Instances=("Web" "Mongodb" "Catalogue" "Redis" "User" "Cart" "MySQL" "Shipping" "RabbitMQ" "Payments" "Dispatch")

Image_id=ami-03265a0778a880afb
Securitygroup_id=sg-0512695d6d01b2c74
Instance_Type=""

for i in "${Instances[@]}"
do 
 #echo "$i"

 if [[ "$i" == "Mongodb" || "$i" == "MySQL" ]]
 then
    $Instance_Type="t3.micro"
 else 

    $Instance_Type="t2.micro"
 fi   

echo "Creating Instance : $i"
aws ec2 run-instances --image-id $Image_id --instance-type $Instance_Type --security-group-ids $Securitygroup_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" 

done

