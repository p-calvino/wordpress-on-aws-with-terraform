resource "aws_autoscaling_group" "wordpress_asg" {
  name                = local.asg_name
  vpc_zone_identifier = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.wordpress_tg.arn]

  tag {
    key                 = "Name"
    value               = local.asg_name
    propagate_at_launch = true
  }
  depends_on = [aws_db_instance.wordpress_db, aws_efs_file_system.wordpress_efs, aws_lb_target_group.wordpress_tg]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 75

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }
}
