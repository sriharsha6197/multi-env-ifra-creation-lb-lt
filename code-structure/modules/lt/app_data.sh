#!/bin/bash
dnf install python3.12-pip.noarch -y | tee -a /opt/ouput.log
pip3.12 install botocore boto3 -y | tee -a /opt/output.log
dnf install ansible -y | tee -a /opt/output.log
ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=${component} | tee -a /opt/output.log
