import boto3
import datetime
import re

def lambda_handler(event, context):
    
    # Connect to EC2 and RDS clients
    ec2 = boto3.client('ec2')
 



    # Stop all running EC2 instances

    
    ec2_instances = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped']}])
    for reservation in ec2_instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            if( 'initiated' in instance['StateTransitionReason'] ):
                stop_time_str = instance['StateTransitionReason']
                pattern = r"\((.*?)\)"
                matches = re.search(pattern, stop_time_str)
                if matches:
                        date_time_str = matches.group(1)
                        print(date_time_str)
                        stop_time = datetime.datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S %Z')
                        stopped_days = (datetime.datetime.now() - stop_time).days
                        if stopped_days > 0:
                            instance = ec2.terminate_instances(InstanceIds=[instance_id])
                            print(stopped_days)
                            print(instance_id)
