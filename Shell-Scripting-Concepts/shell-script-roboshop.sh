#!/bin/bash

SG_ID=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text)
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Redhat-9-DevOps-Practice" --query "Images[0].ImageId" --output text)

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t2.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text)


    if [ $instance == "frontend" ]; then
        echo "frontend instance is created"
        public_ip=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
        echo "Instance ID: $INSTANCE_ID"
        echo "Public IP: $public_ip"
        echo "Private IP: $private_ip"
    else
        echo "backend instance is created"
        private_ip=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[0].Instances[0].PrivateIpAddress' \
        --output text)
        echo "Instance ID: $INSTANCE_ID"
        echo "Public IP: $public_ip"
        echo "Private IP: $private_ip"
    fi
done

