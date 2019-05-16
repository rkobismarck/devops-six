variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication."
  default = "~/.ssh/terraform.pub"
}
variable "private_key_path" {
  description = "Path to the SSH private key to be used for authentication."
  default = "~/.ssh/terraform"
}
variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform"
}
variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-east-1"
}
variable "aws_amis" {
  default = {
    us-east-1 = "ami-0a313d6098716f372"
  }
}
variable "aws_credentials_file" {
	description ="Path to the aws configuration credentials."
	default = "~/.aws/credentials"
}



