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
  user_data = file("../ansible/config/install_ansible.sh")
  vpc_security_group_ids = [aws_security_group.ansible-sgg.id]
  key_name               = var.key
  iam_instance_profile = var.iam_role
  tags = {
    Name = "Server",
    Role = "Ansible-master"
  }

  provisioner "file" {
  source      = "../ansible"
  destination = "/home/ubuntu"

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("/Users/moshe.even/Documents/keys/moshe-aws.pem")
    host     = self.public_ip
  }
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/ansible/config/install_ansible.sh",
      "bash /home/ubuntu/ansible/config/install_ansible.sh",
      # "ansible-playbook /home/ubuntu/ansible/playbooks/configure-host.yml"
    ]
    
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
    Name = "Node${count.index}",
    Role = "web",
    Os = "ubuntu"
  }
}

resource "aws_instance" "nodes_centos" {
  count =1
  ami           = "ami-01e78c5619c5e68b4"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ansible-sgg.id]
  key_name               = var.key
  tags = {
    Name = "Node${count.index}",
    Role = "web",
    Os = "centos"
  }
}