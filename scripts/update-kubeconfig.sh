#!/bin/bash
response="$(aws eks list-clusters --region us-east-1 --output text | grep -i baliketech-cluster 2>&1)" 
if [[ $? -eq 0 ]]; then
    echo "Success: baliketech-cluster exist"
    aws eks --region us-east-1 update-kubeconfig --name baliketech-cluster && export KUBE_CONFIG_PATH=~/.kube/config

else
    echo "Error: baliketech-cluster does not exist"
fi