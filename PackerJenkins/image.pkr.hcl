packer {
    required_plugins {
        amazon = {
            version = ">=0.0.1"
            source = "github.com/hashicorp/amazon"
        }
    }
}

variable "ssh_private_key_file" {
    default = "~/.ssh/id_rsa"
}
variable "ssh_keypair_name" {
    default = "bastion-ohio-packer"
}

variable "source_ami_name" {
    default = "CentOS Linux 7 x86_64 HVM EBS ENA 2002_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-*"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "ssh_username" {
    default = "centos"
}
variable "region" {
    default = "us-west-1"
}

variable "owners" {
    default = "679593333241"
}

variable "ami_name" {
    default = "Jenkinsinstalled"
}

variable "account_ids" {
    default = "713287746880"
}

source "amazon-ebs" "image" {
    ami_name             = "${var.ami_name} {{timestamp}}"
    ssh_private_key_file = "${var.ssh_private_key_file}"
    ssh_keypair_name     = "${var.ssh_keypair_name}"
    ssh_username         = "${var.ssh_username}"
    instance_type        = "${var.instance_type}"
    region               = "${var.region}"
    ami_users            = ["${var.account_ids}"]
    source_ami_filter {
        most_recent = true
        owners = ["${var.owners}"]
        filters = {
            name                = "${var.source_ami_name}"
            virtualization-type = "hvm"
            root-device-type    = "ebs"
        }
    }
}

build {
    sources = [
        "source.amazon-ebs.image"
    ]
    provisioner "shell" {
        inline = [
            "sudo yum update -y",
            "sudo yum install wget -y",
            "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
            "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
            "sudo yum install epel-release -y",
            "sudo yum install jenkins java-1.8.0-openjdk-devel -y",
            "sudo systemctl start jenkins",
            "sudo systemctl enable jenkins",
            ]
    }

    provisioner "breakpoint" {
        note = "waiting for your verification"
    }
}