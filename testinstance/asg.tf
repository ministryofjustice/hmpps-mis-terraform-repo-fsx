
# resource "aws_launch_template" "mis_bfs_server" {
#   name_prefix   = "foobar"
#   image_id      = data.aws_ami.amazon_ami.id
#   instance_type = var.bfs_instance_type
# }

# resource "aws_autoscaling_group" "mis_bfs_server" {
#   name                      = "mis_bfs_server"
#   desired_capacity          = 1
#   max_size                  = 1
#   min_size                  = 1

#   health_check_grace_period = 300
#   health_check_type         = "ELB"
  
#   force_delete              = true
#   vpc_zone_identifier       = local.private_subnet_map


#   availability_zones = ["eu-west-2a"]
  
#   launch_template {
#     id      = aws_launch_template.mis_bfs_server.id
#     version = "$Latest"
#   }

#   lifecycle {
#     ignore_changes = [load_balancers, target_group_arns]
#   }


# }
