provider "aws" {
  region = "ap-south-1"
}

//--------creating instance for Jenkins server------------
resource "aws_instance" "Jenkins_server" {
  ami           = "ami-0dee22c13ea7a9a67" 
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  root_block_device {
    volume_size = var.volume_size
  }
  user_data = <<-EOF
    #!/bin/bash

    # Update the package index to ensure we have the latest list of available packages
    apt update -y

    # Install fontconfig and OpenJDK 17, both are dependencies required for Jenkins
    apt install fontconfig openjdk-17-jre -y

    # Download the Jenkins signing key and save it to the system’s trusted keyring
    wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

    # Add the Jenkins repository to the system’s package sources, referencing the signing key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    # Update the package index again to include packages from the newly added Jenkins repository
    apt-get update -y

    # Install Jenkins from the Jenkins repository
    apt-get install jenkins -y
    # get the password 
    while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
    echo "Waiting for Jenkins to be installed..."
    sleep 5
    done
    echo "Jenkins is installed. Capturing admin password."
    cat /var/lib/jenkins/secrets/initialAdminPassword >> /home/ubuntu/jenkins_pwd.txt
    echo "Password saved to /home/ubuntu/jenkins_pwd.txt"
  EOF

  tags = {
    Name = "Jenkins_Server"
  }
}

//crating security group 
resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  vpc_id      = var.sg_vpc_id

  tags = {
    Name = "Jenkins_SG"
  }
}
//inbound rules 
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_port8080" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
//outbound rules 
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
//outbond rules for ipv6
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}