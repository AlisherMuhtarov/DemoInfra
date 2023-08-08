resource "aws_launch_template" "app_asg_lc" {
  name        = "APP_ASG_LC"
  description = "LC for webserver application"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  key_name = "laptop_key"

  instance_type = "t2.medium"

  update_default_version = true

  image_id = data.aws_ami.ec2_launch.id

  instance_initiated_shutdown_behavior = "stop"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  placement {
    availability_zone = "us-east-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "App"
    }
  }

}