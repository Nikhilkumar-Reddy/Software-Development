#!/bin/bash

SG_ID=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text)
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Redhat-9-DevOps-Practice" --query "Images[0].ImageId" --output text)
ZONE_ID=$(aws route53 list-hosted-zones --query 'HostedZones[0].Id' --output text | cut -d'/' -f3)
DOMAIN_NAME=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text | sed 's/\.$//')

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
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
        echo "Instance ID: $INSTANCE_ID"
        echo "Public IP: $IP"
        echo "frontend instance is created"
        RecordSetName="$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[0].Instances[0].PrivateIpAddress' \
        --output text)
        echo "Instance ID: $INSTANCE_ID"
        echo "Private IP: $IP"
        echo "backend instance is created"
        RecordSetName="$instance.$DOMAIN_NAME"
    fi

# to get the route53 record set and update the A record with the public IP of the frontend instance or backend instance.
    
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '{
    "Comment": "Update A record for '$RecordSetName'",
    "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
    "Name": "'$RecordSetName'",
    "Type": "A",
    "TTL": 1,
    "ResourceRecords": [{ "Value": "'$IP'" }]
    }
    }]
    }'

    echo "A record for $RecordSetName is updated with IP: $IP"
    
done

