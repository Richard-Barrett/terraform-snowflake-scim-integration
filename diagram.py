#!/usr/bin/env python3

# User -> Cluster(AWS -> EKS) -> Terraform -> Helm Resources(prometheus, argo-workflows, wavefront adaptor, irythm-modules)
# How to use this file to generate a diagram:
# $> python3 diagram.py
from pathlib import Path
from diagrams import Cluster, Diagram
from diagrams.saas.analytics import Snowflake as SF
from diagrams.custom import Custom
from diagrams.aws.general import Users
from diagrams.aws.management import SystemsManagerParameterStore, ParameterStore as PS
from diagrams.aws.storage import SimpleStorageServiceS3Bucket as S3

graph_attr = {
    "bgcolor": "transparent",
    "margin": "-1, -2",
    "size": "13,13!"
}

HOME_PATH = f"{Path(__file__).parent.resolve()}"

def main():
    with Diagram(filename="images/diagram", show=False, direction="LR", graph_attr=graph_attr):
        aws_users = Users()
        terraform = Custom("Terraform", icon_path=f"{HOME_PATH}/images/terraform.png")
        s3_backend = S3("Statefile Bucket")
        codefresh = Custom("Codefresh", icon_path=f"{HOME_PATH}/images/codefresh.png")
        aws_users >> s3_backend >> codefresh
        aws_users >> terraform
        terraform >> s3_backend


if __name__ == "__main__":
    main()
