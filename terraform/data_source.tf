data "aws_ami" "ec2_launch" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["base-image"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
