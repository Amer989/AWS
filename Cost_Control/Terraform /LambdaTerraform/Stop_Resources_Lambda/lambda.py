import boto3

def lambda_handler(event, context):
    
    # Connect to EC2 and RDS clients
    ec2 = boto3.client('ec2')
    rds = boto3.client('rds')
    #ecs = boto3.client('ecs')
    #eks = boto3.client('eks')



    # Stop all running EC2 instances
    ec2_instances = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

    
    for reservation in ec2_instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            ec2.stop_instances(InstanceIds=[instance_id])
            print(f"Stopped EC2 instance {instance_id}")

    # Stop all running RDS instances
    rds_instances = rds.describe_db_instances()

    for instance in rds_instances['DBInstances']:
        instance_id = instance['DBInstanceIdentifier']
        if (instance['DBInstanceStatus'] == 'available' and not instance['MultiAZ'] and not instance.get('DBClusterIdentifier')) or (instance['DBInstanceStatus'] == 'available' and instance['MultiAZ'] and instance.get('SecondaryAvailabilityZone')):
            rds.stop_db_instance(DBInstanceIdentifier=instance_id)
            print(f"Stopped RDS instance {instance_id}")
        else:
            print(f"Skipping RDS instance {instance_id} due to status or being a read replica")
    #Stop all clusters        
    cluster_identifiers = rds.describe_db_clusters()
    for cluster_identifier in cluster_identifiers['DBClusters']:
        if (cluster_identifier['Status'] == 'available' and 'aurora' in cluster_identifier['Engine']):
            rds.stop_db_cluster(DBClusterIdentifier=cluster_identifier['DBClusterIdentifier'])
            print(f"Stopped RDS cluster {cluster_identifier}")
     # Stop all running ECS tasks
    # ecs_clusters = ecs.list_clusters()
    
    # for cluster_arn in ecs_clusters['clusterArns']:
    #     services = ecs.list_services(cluster=cluster_arn)
        
    #     for service_arn in services['serviceArns']:
    #         tasks = ecs.list_tasks(cluster=cluster_arn, serviceName=service_arn)
            
    #         for task_arn in tasks['taskArns']:
    #             ecs.stop_task(cluster=cluster_arn, task=task_arn)
    #             print(f"Stopped ECS task {task_arn}") 

    # Stop all running EKS nodes
    # eks_clusters = eks.list_clusters()
    
    # for cluster_name in eks_clusters['clusters']:
    #     nodegroups = eks.list_nodegroups(clusterName=cluster_name)
        
    #     for nodegroup_name in nodegroups['nodegroups']:
    #         nodes = eks.list_nodes(clusterName=cluster_name, nodegroupName=nodegroup_name)
            
    #         for node in nodes['nodes']:
    #             eks.update_nodegroup_config(
    #                 clusterName=cluster_name,
    #                 nodegroupName=nodegroup_name,
    #                 scalingConfig={
    #                     'minSize': 0,
    #                     'maxSize': 0,
    #                     'desiredSize': 0
    #                 },
    #                 labels=node['labels'],
    #                 taints=node['taints']
    #             )
    #             print(f"Stopped EKS node {node['name']} in nodegroup {nodegroup_name}")
