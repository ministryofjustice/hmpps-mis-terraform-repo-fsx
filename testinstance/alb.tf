

# resource "aws_lb" "mis_bfs_server" {
#   name               = "mis_bfs_server"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = aws_subnet.public.*.id

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
# }


# resource "aws_autoscaling_attachment" "asg_attachment_mis_bfs_server" {
#   autoscaling_group_name = aws_autoscaling_group.mis_bfs_server.id
#   elb                    = aws_elb.test.id
# }