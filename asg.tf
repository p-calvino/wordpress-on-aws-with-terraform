resource "aws_autoscaling_group" "wordpress_asg" {
  vpc_zone_identifier = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }
  min_size          = 1
  max_size          = 4
  desired_capacity  = 2
  target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
  depends_on = [aws_db_instance.wordpress_db, aws_efs_file_system.wordpress_efs, aws_lb_target_group.wordpress_tg]

}
