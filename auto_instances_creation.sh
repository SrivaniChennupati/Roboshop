#!/bin/bash

Instances=("Web" "Mongodb" "Catalogue" "Redis" "User" "Cart" "MySQL" "Shipping" "RabbitMQ" "Payments" "Dispatch")

Image_id=ami-03265a0778a880afb
Securitygroup_id=sg-0512695d6d01b2c74
INSTANCE_TYPE=""
domain_name=devopsvani.online

for i in "${Instances[@]}"
do 
 #echo "$i"
 #Instance_Type="t2.micro"

  if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"

echo "Creating Instance : $i"
private_ip=$(aws ec2 run-instances --image-id $Image_id --instance-type $Instance_Type --security-group-ids $Securitygroup_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')

 echo "created $i Instance :$private_ip"

 
done

