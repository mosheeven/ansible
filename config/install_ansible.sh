#!bin/bash

sudo apt update -y 
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo pip3 install ansible

sudo pip3 install boto3
sudo apt-get install -y python3-botocore