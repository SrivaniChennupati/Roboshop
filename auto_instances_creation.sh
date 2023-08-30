#!/bin/bash

Instances=("Web","Mongodb","Catalogue","Redis","User","Cart","MySQL","Shipping","RabbitMQ","Payments","Dispatch")

for i in "${Instances[@]}"
do 
 echo "$i"

done

