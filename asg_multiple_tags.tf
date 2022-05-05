#########################
# Define tag variables 
#########################

locals {
 tags = {
    Environment                  = "POC"
    Terraform                    = "True"
    Customer                     = "GitHub"
    Product                      = "Autoscaling Group"

  }
}


#########################################
# Create ASG  with dynamic tag block
########################################

resource "aws_autoscaling_group" "asg" {
  name                = "poc-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private.id
  target_group_arns   = [aws_lb_target_group.poc.arn]
  
  tag {
    key                 = "Name"
    value               = "poc-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "product"
    value               = "POC Product"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.asg.id
    version = "$Latest"
  }

}