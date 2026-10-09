data "aws_vpc" "name" {
  default = true
}

resource "aws_security_group" "k8s-sec-gr" {
  name   = var.sec-gr-k8s
  vpc_id = data.aws_vpc.name.id

  tags = {
    Name = var.sec-gr-k8s
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30001
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Mevcut IAM instance profile'ı kullan
data "aws_iam_instance_profile" "petclinic-master-server-profile" {
  name = "petclinic-master-server-profile"
}

resource "aws_instance" "kube-master" {
  ami                  = "ami-005fc0f236362e99f"
  instance_type        = "t3a.medium"
  iam_instance_profile = data.aws_iam_instance_profile.petclinic-master-server-profile.name
  vpc_security_group_ids = [aws_security_group.k8s-sec-gr.id]
  key_name             = "KEY_NAME_PLACEHOLDER"
  subnet_id            = "subnet-05c2a38a937f813a5"
  availability_zone    = "us-east-1a"

  tags = {
    Name        = "kube-master"
    Project     = "tera-kube-ans"
    Role        = "master"
    Id          = "1"
    environment = "dev"
  }
}

resource "aws_instance" "worker-1" {
  ami                  = "ami-005fc0f236362e99f"
  instance_type        = "t3a.medium"
  vpc_security_group_ids = [aws_security_group.k8s-sec-gr.id]
  key_name             = "KEY_NAME_PLACEHOLDER"
  subnet_id            = "subnet-05c2a38a937f813a5"
  availability_zone    = "us-east-1a"

  tags = {
    Name        = "worker-1"
    Project     = "tera-kube-ans"
    Role        = "worker"
    Id          = "1"
    environment = "dev"
  }
}

resource "aws_instance" "worker-2" {
  ami                  = "ami-005fc0f236362e99f"
  instance_type        = "t3a.medium"
  vpc_security_group_ids = [aws_security_group.k8s-sec-gr.id]
  key_name             = "KEY_NAME_PLACEHOLDER"
  subnet_id            = "subnet-05c2a38a937f813a5"
  availability_zone    = "us-east-1a"

  tags = {
    Name        = "worker-2"
    Project     = "tera-kube-ans"
    Role        = "worker"
    Id          = "2"
    environment = "dev"
  }
}

output "kube-master-ip" {
  value       = aws_instance.kube-master.public_ip
  description = "public ip of the kube-master"
}

output "worker-1-ip" {
  value       = aws_instance.worker-1.public_ip
  description = "public ip of the worker-1"
}

output "worker-2-ip" {
  value       = aws_instance.worker-2.public_ip
  description = "public ip of the worker-2"
}
