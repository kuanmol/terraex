provider "aws" {
  region = "us-west-2"
}

# Security group for EC2
resource "aws_security_group" "kops_ec2_sg" {
  name        = "kops-ec2-sg"
  description = "Allow SSH and necessary ports for KOPS setup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "kops_ec2" {
  ami           = "ami-05134c8ef96964280"  # Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "kops-key"  # Replace with your actual key pair name

  security_groups = [aws_security_group.kops_ec2_sg.name]

  user_data = <<EOF
#!/bin/bash
set -x

# Update and install required packages
sudo apt update -y
sudo apt install -y unzip wget curl

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip || { echo "Failed to unzip AWS CLI"; exit 1; }
sudo ./aws/install || { echo "Failed to install AWS CLI"; exit 1; }

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || { echo "Failed to download kubectl"; exit 1; }
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/ || { echo "Failed to move kubectl"; exit 1; }

# Install KOPS
wget https://github.com/kubernetes/kops/releases/download/v1.26.4/kops-linux-amd64 || { echo "Failed to download kops"; exit 1; }
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops || { echo "Failed to move kops"; exit 1; }

aws configure set region us-west-2
aws configure set output json

# Set up KOPS environment variables
export KOPS_STATE_STORE=s3://kube-studnet


kops create cluster \
  --name=kubevpro.ewirevn32ds.shop \
  --state=s3://kube-studnet \
  --zones=us-west-2a,us-west-2b \
  --node-count=2 \
  --node-size=t3.small \
  --node-volume-size=8 \
  --master-size=t3.small \
  --master-volume-size=8 \
  --dns-zone=kubevpro.ewirevn32ds.shop

# Update the cluster to apply the changes
kops update cluster --name kubevpro.ewirevn32ds.shop --state=s3://kube-studnet --yes --admin

EOF

  tags = {
    Name = "KOPS EC2 Instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.kops_ec2.public_ip
}
