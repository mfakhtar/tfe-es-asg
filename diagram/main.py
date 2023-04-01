from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2 , EC2ElasticIpAddress
from diagrams.aws.database import RDS
from diagrams.aws.network import VPC, Route53 , PrivateSubnet , PublicSubnet
from diagrams.aws.storage import S3
from diagrams.onprem.client import User
# Create the diagram
with Diagram("AWS Infrastructure", show=False):
    # Define the AWS account and region
    usr = User("User")
    aws = Cluster("AWS Account")
    with aws:
        region = Cluster("us-west-2")
        with Cluster("ap-south-1"):
            s3 = S3("S3")
        # Create the VPC with 3 subnets
            with Cluster("VPC"):
                    eip = EC2ElasticIpAddress("EIP")
    #            with Cluster("Subnets"):
                    with Cluster("Subnet1"):
                        ec2 = EC2("TFE")
                    with Cluster("DBSubnets"):
                        pri2 = PrivateSubnet("Subnet2")
                        pri3 = PrivateSubnet("Subnet3")
                        rds = RDS("DB")
            rds >> pri2
            rds >> pri3
            # Create the Route53 record
            record = Route53("fawaz-tfe")
    usr >> record >> eip >> ec2 >> rds
    usr >> record >> eip >> ec2 >> s3