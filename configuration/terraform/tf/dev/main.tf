provider "aws" {
  region  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_credentials_file}"
  profile                 = "terraform"
}
resource "aws_key_pair" "auth" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Default security group"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "app" {
  name        = "app"
  description = "App security group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami="ami-0a313d6098716f372"   
  instance_type="t2.micro"
  security_groups = [
        "${aws_security_group.ssh.name}",
        "${aws_security_group.app.name}"
    ]
  key_name = "${aws_key_pair.auth.id}"
  
	tags {
    Name="app"
  }
  
	connection {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
  }

	provisioner "file" {
        source = "../scripts/docker.sh"
        destination = "/tmp/docker.sh"
    }

	provisioner "remote-exec" {
			inline = [
					"cd /tmp",
					"sudo chmod +x docker.sh",
					"sudo ./docker.sh"
			]
	}
  
}