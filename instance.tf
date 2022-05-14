resource "aws_instance" "ec2_pivote" {
  ami                    = "ami-0528712befcd5d885"
  instance_type          = "t2.micro"
  key_name               = "aws_keyv2"
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

}

resource "null_resource" "copy_files" {
  depends_on = [
    aws_instance.ec2_pivote
  ]
  provisioner "file" {
    source      = "url-scan"
    destination = "/home/ubuntu"
  }

  connection {
    type        = "ssh"
    host        = aws_instance.ec2_pivote.public_ip
    user        = "admin"
    private_key = file("aws_keyv2")
    timeout     = "4m"
  }
}


resource "null_resource" "remote_exec_instance" {
  depends_on = [
    aws_instance.ec2_pivote,
    null_resource.copy_files
  ]
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt -y upgrade",
      "sudo apt install -y python3 python3-pip",
      "pip3 install -r ./url-scan/requirements.txt",
      "cd url-scan && python3 main.py"
    ]

  }

  connection {
    type        = "ssh"
    host        = aws_instance.ec2_pivote.public_ip
    user        = "admin"
    private_key = file("aws_keyv2")
    timeout     = "4m"
  }
}


resource "aws_security_group" "main" {
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCGwB0IK9x6MclQ8j1Ba106mcDzBb0dqKN7lUSxs2YXzLjgRS4snRXCKw6xJLW4IcyO4VcwlM5cIfgnsTawXodQkGr52+kVCXNeC+Fl6ag1BPhGnlPqBbaa0XB/iWMg5A+FkWJs8AGmwwe784fBLLP9NwO5r+1rtV00AzL6wZHOKperIsCBPgMOicn6p4qRDAnH+0K4BPJf5Rkmtl1Hro2plzy5rEzH3cAByklXIdOo0zEF/ctoARbmBVOu0v2hQUB8eOSaGaX/Gd+dOkNRN93MPml6VONSoodzgd2eWMz3ZpBykA8AoAEDfnWHlYGzHRWiZa5yNyY5R6Cg7Zqc3FXYRlydWxPU1/9HiDM+VLaglEVYwoqBAD/g5BnB/8HK3mXr3bPZCryoBXhMsJTv88z6o4koFrFL2xwcUfN+xmIjFog+GzwciMWsqQ4Qa/JieJM8ewALa+n4N5xyyeH9m+f+IpBVHspa5lGJxU+3Nj/g3HjrCcrmOfcYNm9JUDoofU= gseriche@Gonzalos-MacBook-Pro.local"

}
