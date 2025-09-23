### Overview
this setup was backed by the following key tools and technologies.
1. Openvpn
2. EC2 where the application was installed to.
3. AWS ASG for auto recovery
4. AWS EFS for data persistence
5. bash scripts to glue services together
6. packer for building AMI images
7. EIPs to have a static public IP


## Openvpn (easy install)
Instructions here was taken from: https://www.cyberciti.biz/faq/ubuntu-18-04-lts-set-up-openvpn-server-in-5-minutes/
but modified to accomodate our needs.

### Manual Install
Step 1 – Update the server
```
sudo apt update
sudo apt -y upgrade
```

Step 2 – run openvpn-install.sh script
```
# This script was taken from the link above but I modified it so that it will no longer ask for user input during runs.
# Below are the default valued set
# protocol = udp
# DNS server for the clients = Google
#  Enter a name for the first client = openvpn
#

chmod +x openvpn-install.sh
sudo ./openvpn-install.sh 
```

*make sure to allow port 1194/udp*


### Deploy via terraform
create a terraform root folder and create files similar to that of the sample directory [here](./sample)
**Do not forget to change the values accordingly**

Steps:
1. Connect to our AWS account.

2. check terraform plan
```
terraform plan
```

3. review the plan. once good. invoke below then answer 'yes' when prompted (better DOUBLE check the plan as a good practice)
```
terraform apply
```


