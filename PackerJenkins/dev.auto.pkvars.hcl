region = "us-west-1"
ssh_keypair_name = "bastion-ohio-packer"
ami_name = "Jenkinsinstalled"
ssh_private_key_file = "~/.ssh/id_rsa"
instance_type = "t2.micro"

#  OS specific settings

source_ami_name = "CentOS Linux 7 x86_64 HVM EBS ENA 2002_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-*"
ssh_username = "centos"
owners = "679593333241"

