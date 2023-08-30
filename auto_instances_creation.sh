#!/bin/bash

Instances=("Web" "Mongodb" "Catalogue" "Redis" "User" "Cart" "MySQL" "Shipping" "RabbitMQ" "Payments" "Dispatch")

Image_id=ami-03265a0778a880afb
Securitygroup_id=sg-0512695d6d01b2c74
INSTANCE_TYPE=""
domain_name=devopsvani.online
Hostedzone_id=Z00901702AI0X0PSLUZQF

for i in "${Instances[@]}"
do 
 #echo "$i"
 #Instance_Type="t2.micro"

  if [[ $i == "Mongodb" || $i == "MySQL" ]]
    then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"
   fi     

echo "Creating Instance : $i"
private_ip=$(aws ec2 run-instances --image-id $Image_id --instance-type $INSTANCE_TYPE --security-group-ids $Securitygroup_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')

 echo "created $i Instance :$private_ip"

 aws route53 change-resource-record-sets --hosted-zone-id $Hostedzone_id --change-batch '{
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'.com",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$private_ip'"}]
                        }}]
    }
'
done

