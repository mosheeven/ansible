data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

## ec2

resource "aws_instance" "server" {
  count = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  user_data = file("install_ansible.sh")
  vpc_security_group_ids = [aws_security_group.ansible-sgg.id]
  key_name               = var.key
  tags = {
    Name = "Server"
  }

  provisioner "file" {
  source      = "../config"
  destination = "/home/ubuntu"

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("/Users/moshe.even/Documents/keys/moshe-aws.pem")
    host     = self.public_ip
  }
}
}

resource "aws_instance" "nodes" {
  count =2 
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ansible-sgg.id]
  key_name               = var.key
  tags = {
    Name = "Node${count.index}"
  }
}