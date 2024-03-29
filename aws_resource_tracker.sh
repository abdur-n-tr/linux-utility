#!/bin/bash

##############################
# Author: Abdur Rehman
# Date: Mar 29, 2024
#
# Version: v1
#
# This script will report the AWS resource usage.
##############################

set -x # debug mode

# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM 

# list s3 bucket names
echo "Print list of s3 buckets"
aws s3 ls | awk -F " " '{print $3}'

# list EC2 instances
echo -e "\nPrint list of EC2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

# list lambda functions
echo -e "\nPrint list of lambda functions"
aws lambda list-functions | jq '.Functions[].FunctionName'

# list IAM users
echo -e "\nPrint list of IAM users"
aws iam list-users | jq '.Users[].UserName'

# set cronjob for this script by editing crontab file using `crontab -e` and mention schedule time as 
# `* * * * * /home/arehman/projects/linux-utility/aws_resource_tracker.sh >> /home/arehman/projects/linux-utility/output.log 2>&1`
# (this will run cronjob after every min)
